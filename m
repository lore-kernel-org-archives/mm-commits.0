From: akpm@linux-foundation.org
Subject: + memcg-remove-the-overhead-associated-with-the-root-cgroup.patch added to -mm tree
Date: Mon, 22 Jun 2009 15:44:20 -0700
Message-ID: <200906222244.n5MMiLU0016759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756097AbZFVWoc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 18:44:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: remove the overhead associated with the root cgroup
has been added to the -mm tree.  Its filename is
     memcg-remove-the-overhead-associated-with-the-root-cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove the overhead associated with the root cgroup
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Change the memory cgroup to remove the overhead associated with accounting
all pages in the root cgroup.  As a side-effect, we can no longer set a
memory hard limit in the root cgroup.

A new flag to track whether the page has been accounted or not has been
added as well.  Flags are now set atomically for page_cgroup,
pcg_default_flags is now obsolete and removed.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    4 ++
 include/linux/page_cgroup.h      |   13 ++++++
 mm/memcontrol.c                  |   54 +++++++++++++++++++++--------
 3 files changed, 57 insertions(+), 14 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-remove-the-overhead-associated-with-the-root-cgroup Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-remove-the-overhead-associated-with-the-root-cgroup
+++ a/Documentation/cgroups/memory.txt
@@ -179,6 +179,9 @@ The reclaim algorithm has not been modif
 pages that are selected for reclaiming come from the per cgroup LRU
 list.
 
+NOTE: Reclaim does not works for the root cgroup, since we cannot
+set any limits on the root cgroup
+
 2. Locking
 
 The memory controller uses the following hierarchy
@@ -210,6 +213,7 @@ We can alter the memory limit:
 NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
 mega or gigabytes.
 NOTE: We can write "-1" to reset the *.limit_in_bytes(unlimited).
+NOTE: We cannot set limits on the root cgroup anymore.
 
 # cat /cgroups/0/memory.limit_in_bytes
 4194304
diff -puN include/linux/page_cgroup.h~memcg-remove-the-overhead-associated-with-the-root-cgroup include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-remove-the-overhead-associated-with-the-root-cgroup
+++ a/include/linux/page_cgroup.h
@@ -38,6 +38,7 @@ enum {
 	PCG_LOCK,  /* page cgroup is locked */
 	PCG_CACHE, /* charged as cache */
 	PCG_USED, /* this object is in use. */
+	PCG_ACCT_LRU, /* page has been accounted for */
 };
 
 #define TESTPCGFLAG(uname, lname)			\
@@ -52,11 +53,23 @@ static inline void SetPageCgroup##uname(
 static inline void ClearPageCgroup##uname(struct page_cgroup *pc)	\
 	{ clear_bit(PCG_##lname, &pc->flags);  }
 
+#define TESTCLEARPCGFLAG(uname, lname)			\
+static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
+	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
+
 /* Cache flag is set only once (at allocation) */
 TESTPCGFLAG(Cache, CACHE)
+CLEARPCGFLAG(Cache, CACHE)
+SETPCGFLAG(Cache, CACHE)
 
 TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
+SETPCGFLAG(Used, USED)
+
+SETPCGFLAG(AcctLRU, ACCT_LRU)
+CLEARPCGFLAG(AcctLRU, ACCT_LRU)
+TESTPCGFLAG(AcctLRU, ACCT_LRU)
+TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
 
 static inline int page_cgroup_nid(struct page_cgroup *pc)
 {
diff -puN mm/memcontrol.c~memcg-remove-the-overhead-associated-with-the-root-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-the-overhead-associated-with-the-root-cgroup
+++ a/mm/memcontrol.c
@@ -43,6 +43,7 @@
 
 struct cgroup_subsys mem_cgroup_subsys __read_mostly;
 #define MEM_CGROUP_RECLAIM_RETRIES	5
+struct mem_cgroup *root_mem_cgroup __read_mostly;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 /* Turned on only when memory cgroup is enabled && really_do_swap_account = 1 */
@@ -200,13 +201,8 @@ enum charge_type {
 #define PCGF_CACHE	(1UL << PCG_CACHE)
 #define PCGF_USED	(1UL << PCG_USED)
 #define PCGF_LOCK	(1UL << PCG_LOCK)
-static const unsigned long
-pcg_default_flags[NR_CHARGE_TYPE] = {
-	PCGF_CACHE | PCGF_USED | PCGF_LOCK, /* File Cache */
-	PCGF_USED | PCGF_LOCK, /* Anon */
-	PCGF_CACHE | PCGF_USED | PCGF_LOCK, /* Shmem */
-	0, /* FORCE */
-};
+/* Not used, but added here for completeness */
+#define PCGF_ACCT	(1UL << PCG_ACCT)
 
 /* for encoding cft->private value on file */
 #define _MEM			(0)
@@ -354,6 +350,11 @@ static int mem_cgroup_walk_tree(struct m
 	return ret;
 }
 
+static inline bool mem_cgroup_is_root(struct mem_cgroup *mem)
+{
+	return (mem == root_mem_cgroup);
+}
+
 /*
  * Following LRU functions are allowed to be used without PCG_LOCK.
  * Operations are called by routine of global LRU independently from memcg.
@@ -371,22 +372,24 @@ static int mem_cgroup_walk_tree(struct m
 void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru)
 {
 	struct page_cgroup *pc;
-	struct mem_cgroup *mem;
 	struct mem_cgroup_per_zone *mz;
 
 	if (mem_cgroup_disabled())
 		return;
 	pc = lookup_page_cgroup(page);
 	/* can happen while we handle swapcache. */
-	if (list_empty(&pc->lru) || !pc->mem_cgroup)
+	if (!TestClearPageCgroupAcctLRU(pc))
 		return;
+	VM_BUG_ON(!pc->mem_cgroup);
 	/*
 	 * We don't check PCG_USED bit. It's cleared when the "page" is finally
 	 * removed from global LRU.
 	 */
 	mz = page_cgroup_zoneinfo(pc);
-	mem = pc->mem_cgroup;
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
+	if (mem_cgroup_is_root(pc->mem_cgroup))
+		return;
+	VM_BUG_ON(list_empty(&pc->lru));
 	list_del_init(&pc->lru);
 	return;
 }
@@ -410,8 +413,8 @@ void mem_cgroup_rotate_lru_list(struct p
 	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
 	 */
 	smp_rmb();
-	/* unused page is not rotated. */
-	if (!PageCgroupUsed(pc))
+	/* unused or root page is not rotated. */
+	if (!PageCgroupUsed(pc) || PageCgroupAcctLRU(pc))
 		return;
 	mz = page_cgroup_zoneinfo(pc);
 	list_move(&pc->lru, &mz->lists[lru]);
@@ -425,6 +428,7 @@ void mem_cgroup_add_lru_list(struct page
 	if (mem_cgroup_disabled())
 		return;
 	pc = lookup_page_cgroup(page);
+	VM_BUG_ON(PageCgroupAcctLRU(pc));
 	/*
 	 * Used bit is set without atomic ops but after smp_wmb().
 	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
@@ -435,6 +439,9 @@ void mem_cgroup_add_lru_list(struct page
 
 	mz = page_cgroup_zoneinfo(pc);
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
+	SetPageCgroupAcctLRU(pc);
+	if (mem_cgroup_is_root(pc->mem_cgroup))
+		return;
 	list_add(&pc->lru, &mz->lists[lru]);
 }
 
@@ -469,7 +476,7 @@ static void mem_cgroup_lru_add_after_com
 
 	spin_lock_irqsave(&zone->lru_lock, flags);
 	/* link when the page is linked to LRU but page_cgroup isn't */
-	if (PageLRU(page) && list_empty(&pc->lru))
+	if (PageLRU(page) && !PageCgroupAcctLRU(pc))
 		mem_cgroup_add_lru_list(page, page_lru(page));
 	spin_unlock_irqrestore(&zone->lru_lock, flags);
 }
@@ -1125,9 +1132,22 @@ static void __mem_cgroup_commit_charge(s
 		css_put(&mem->css);
 		return;
 	}
+
 	pc->mem_cgroup = mem;
 	smp_wmb();
-	pc->flags = pcg_default_flags[ctype];
+	switch (ctype) {
+	case MEM_CGROUP_CHARGE_TYPE_CACHE:
+	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
+		SetPageCgroupCache(pc);
+		SetPageCgroupUsed(pc);
+		break;
+	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+		ClearPageCgroupCache(pc);
+		SetPageCgroupUsed(pc);
+		break;
+	default:
+		break;
+	}
 
 	mem_cgroup_charge_statistics(mem, pc, true);
 
@@ -2066,6 +2086,10 @@ static int mem_cgroup_write(struct cgrou
 	name = MEMFILE_ATTR(cft->private);
 	switch (name) {
 	case RES_LIMIT:
+		if (mem_cgroup_is_root(memcg)) { /* Can't set limit on root */
+			ret = -EINVAL;
+			break;
+		}
 		/* This function does all necessary parse...reuse it */
 		ret = res_counter_memparse_write_strategy(buffer, &val);
 		if (ret)
@@ -2532,6 +2556,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (cont->parent == NULL) {
 		enable_swap_cgroup();
 		parent = NULL;
+		root_mem_cgroup = mem;
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		mem->use_hierarchy = parent->use_hierarchy;
@@ -2560,6 +2585,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	return &mem->css;
 free_out:
 	__mem_cgroup_free(mem);
+	root_mem_cgroup = NULL;
 	return ERR_PTR(error);
 }
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch

