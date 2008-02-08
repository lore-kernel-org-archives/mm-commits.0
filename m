From: akpm@linux-foundation.org
Subject: - memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:21 -0800
Message-ID: <200802080803.m18832j6014089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761277AbYBHI2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, bunk@kernel.org, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rientjes@google.


The patch titled
     Memory controller: add switch to control what type of pages to limit
has been removed from the -mm tree.  Its filename was
     memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory controller: add switch to control what type of pages to limit
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Choose if we want cached pages to be accounted or not.  By default both are
accounted for.  A new set of tunables are added.

echo -n 1 > mem_control_type

switches the accounting to account for only mapped pages

echo -n 3 > mem_control_type

switches the behaviour back

[bunk@kernel.org: mm/memcontrol.c: clenups]
[akpm@linux-foundation.org: fix sparc32 build]
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 +++
 mm/filemap.c               |    2 
 mm/memcontrol.c            |   98 +++++++++++++++++++++++++++++++++--
 mm/swap_state.c            |    2 
 4 files changed, 106 insertions(+), 5 deletions(-)

diff -puN include/linux/memcontrol.h~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7
+++ a/include/linux/memcontrol.h
@@ -22,6 +22,8 @@
 
 struct mem_cgroup;
 struct page_cgroup;
+struct page;
+struct mm_struct;
 
 #ifdef CONFIG_CGROUP_MEM_CONT
 
@@ -40,6 +42,7 @@ extern unsigned long mem_cgroup_isolate_
 					struct mem_cgroup *mem_cont,
 					int active);
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
+extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm);
 
 static inline void mem_cgroup_uncharge_page(struct page *page)
 {
@@ -84,6 +87,12 @@ static inline void mem_cgroup_move_lists
 {
 }
 
+static inline int mem_cgroup_cache_charge(struct page *page,
+						struct mm_struct *mm)
+{
+	return 0;
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/filemap.c~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7 mm/filemap.c
--- a/mm/filemap.c~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7
+++ a/mm/filemap.c
@@ -464,7 +464,7 @@ int add_to_page_cache(struct page *page,
 
 	if (error == 0) {
 
-		error = mem_cgroup_charge(page, current->mm);
+		error = mem_cgroup_cache_charge(page, current->mm);
 		if (error)
 			goto out;
 
diff -puN mm/memcontrol.c~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7 mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7
+++ a/mm/memcontrol.c
@@ -29,6 +29,8 @@
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 
+#include <asm/uaccess.h>
+
 struct cgroup_subsys mem_cgroup_subsys;
 static const int MEM_CGROUP_RECLAIM_RETRIES = 5;
 
@@ -60,6 +62,7 @@ struct mem_cgroup {
 	 * spin_lock to protect the per cgroup LRU
 	 */
 	spinlock_t lru_lock;
+	unsigned long control_type;	/* control RSS or RSS+Pagecache */
 };
 
 /*
@@ -82,6 +85,15 @@ struct page_cgroup {
 					/* mapped and cached states     */
 };
 
+enum {
+	MEM_CGROUP_TYPE_UNSPEC = 0,
+	MEM_CGROUP_TYPE_MAPPED,
+	MEM_CGROUP_TYPE_CACHED,
+	MEM_CGROUP_TYPE_ALL,
+	MEM_CGROUP_TYPE_MAX,
+};
+
+static struct mem_cgroup init_mem_cgroup;
 
 static inline
 struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
@@ -139,18 +151,18 @@ struct page_cgroup *page_get_page_cgroup
 		(page->page_cgroup & ~PAGE_CGROUP_LOCK);
 }
 
-void __always_inline lock_page_cgroup(struct page *page)
+static void __always_inline lock_page_cgroup(struct page *page)
 {
 	bit_spin_lock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 	VM_BUG_ON(!page_cgroup_locked(page));
 }
 
-void __always_inline unlock_page_cgroup(struct page *page)
+static void __always_inline unlock_page_cgroup(struct page *page)
 {
 	bit_spin_unlock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 }
 
-void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
+static void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
 {
 	if (active)
 		list_move(&pc->lru, &pc->mem_cgroup->active_list);
@@ -366,6 +378,22 @@ err:
 }
 
 /*
+ * See if the cached pages should be charged at all?
+ */
+int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm)
+{
+	struct mem_cgroup *mem;
+	if (!mm)
+		mm = &init_mm;
+
+	mem = rcu_dereference(mm->mem_cgroup);
+	if (mem->control_type == MEM_CGROUP_TYPE_ALL)
+		return mem_cgroup_charge(page, mm);
+	else
+		return 0;
+}
+
+/*
  * Uncharging is always a welcome operation, we never complain, simply
  * uncharge.
  */
@@ -375,6 +403,10 @@ void mem_cgroup_uncharge(struct page_cgr
 	struct page *page;
 	unsigned long flags;
 
+	/*
+	 * This can handle cases when a page is not charged at all and we
+	 * are switching between handling the control_type.
+	 */
 	if (!pc)
 		return;
 
@@ -425,6 +457,60 @@ static ssize_t mem_cgroup_write(struct c
 				mem_cgroup_write_strategy);
 }
 
+static ssize_t mem_control_type_write(struct cgroup *cont,
+			struct cftype *cft, struct file *file,
+			const char __user *userbuf,
+			size_t nbytes, loff_t *pos)
+{
+	int ret;
+	char *buf, *end;
+	unsigned long tmp;
+	struct mem_cgroup *mem;
+
+	mem = mem_cgroup_from_cont(cont);
+	buf = kmalloc(nbytes + 1, GFP_KERNEL);
+	ret = -ENOMEM;
+	if (buf == NULL)
+		goto out;
+
+	buf[nbytes] = 0;
+	ret = -EFAULT;
+	if (copy_from_user(buf, userbuf, nbytes))
+		goto out_free;
+
+	ret = -EINVAL;
+	tmp = simple_strtoul(buf, &end, 10);
+	if (*end != '\0')
+		goto out_free;
+
+	if (tmp <= MEM_CGROUP_TYPE_UNSPEC || tmp >= MEM_CGROUP_TYPE_MAX)
+		goto out_free;
+
+	mem->control_type = tmp;
+	ret = nbytes;
+out_free:
+	kfree(buf);
+out:
+	return ret;
+}
+
+static ssize_t mem_control_type_read(struct cgroup *cont,
+				struct cftype *cft,
+				struct file *file, char __user *userbuf,
+				size_t nbytes, loff_t *ppos)
+{
+	unsigned long val;
+	char buf[64], *s;
+	struct mem_cgroup *mem;
+
+	mem = mem_cgroup_from_cont(cont);
+	s = buf;
+	val = mem->control_type;
+	s += sprintf(s, "%lu\n", val);
+	return simple_read_from_buffer((void __user *)userbuf, nbytes,
+			ppos, buf, s - buf);
+}
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -442,6 +528,11 @@ static struct cftype mem_cgroup_files[] 
 		.private = RES_FAILCNT,
 		.read = mem_cgroup_read,
 	},
+	{
+		.name = "control_type",
+		.write = mem_control_type_write,
+		.read = mem_control_type_read,
+	},
 };
 
 static struct mem_cgroup init_mem_cgroup;
@@ -464,6 +555,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	INIT_LIST_HEAD(&mem->active_list);
 	INIT_LIST_HEAD(&mem->inactive_list);
 	spin_lock_init(&mem->lru_lock);
+	mem->control_type = MEM_CGROUP_TYPE_ALL;
 	return &mem->css;
 }
 
diff -puN mm/swap_state.c~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7 mm/swap_state.c
--- a/mm/swap_state.c~memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7
+++ a/mm/swap_state.c
@@ -78,7 +78,7 @@ int add_to_swap_cache(struct page *page,
 	error = radix_tree_preload(gfp_mask);
 	if (!error) {
 
-		error = mem_cgroup_charge(page, current->mm);
+		error = mem_cgroup_cache_charge(page, current->mm);
 		if (error)
 			goto out;
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
getdelays-fix-gcc-warnings.patch
