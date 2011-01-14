From: akpm@linux-foundation.org
Subject: [merged] thp-transhuge-memcg-commit-tail-pages-at-charge.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:34 -0800
Message-ID: <201101142250.p0EMoONP005407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886Ab1ANWuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: transhuge-memcg: commit tail pages at charge
has been removed from the -mm tree.  Its filename was
     thp-transhuge-memcg-commit-tail-pages-at-charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: transhuge-memcg: commit tail pages at charge
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

By this patch, when a transparent hugepage is charged, not only the head
page but also all the tail pages are committed, IOW pc->mem_cgroup and
pc->flags of tail pages are set.

Without this patch:

- Tail pages are not linked to any memcg's LRU at splitting. This causes many
  problems, for example, the charged memcg's directory can never be rmdir'ed
  because it doesn't have enough pages to scan to make the usage decrease to 0.
- "rss" field in memory.stat would be incorrect. Moreover, usage_in_bytes in
  root cgroup is calculated by the stat not by res_counter(since 2.6.32),
  it would be incorrect too.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   52 ++++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~thp-transhuge-memcg-commit-tail-pages-at-charge mm/memcontrol.c
--- a/mm/memcontrol.c~thp-transhuge-memcg-commit-tail-pages-at-charge
+++ a/mm/memcontrol.c
@@ -2094,23 +2094,10 @@ struct mem_cgroup *try_get_mem_cgroup_fr
  * commit a charge got by __mem_cgroup_try_charge() and makes page_cgroup to be
  * USED state. If already USED, uncharge and return.
  */
-
-static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
-				       struct page_cgroup *pc,
-				       enum charge_type ctype,
-				       int page_size)
+static void ____mem_cgroup_commit_charge(struct mem_cgroup *mem,
+					 struct page_cgroup *pc,
+					 enum charge_type ctype)
 {
-	/* try_charge() can return NULL to *memcg, taking care of it. */
-	if (!mem)
-		return;
-
-	lock_page_cgroup(pc);
-	if (unlikely(PageCgroupUsed(pc))) {
-		unlock_page_cgroup(pc);
-		mem_cgroup_cancel_charge(mem, page_size);
-		return;
-	}
-
 	pc->mem_cgroup = mem;
 	/*
 	 * We access a page_cgroup asynchronously without lock_page_cgroup().
@@ -2135,6 +2122,33 @@ static void __mem_cgroup_commit_charge(s
 	}
 
 	mem_cgroup_charge_statistics(mem, pc, true);
+}
+
+static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
+				       struct page_cgroup *pc,
+				       enum charge_type ctype,
+				       int page_size)
+{
+	int i;
+	int count = page_size >> PAGE_SHIFT;
+
+	/* try_charge() can return NULL to *memcg, taking care of it. */
+	if (!mem)
+		return;
+
+	lock_page_cgroup(pc);
+	if (unlikely(PageCgroupUsed(pc))) {
+		unlock_page_cgroup(pc);
+		mem_cgroup_cancel_charge(mem, page_size);
+		return;
+	}
+
+	/*
+	 * we don't need page_cgroup_lock about tail pages, becase they are not
+	 * accessed by any other context at this point.
+	 */
+	for (i = 0; i < count; i++)
+		____mem_cgroup_commit_charge(mem, pc + i, ctype);
 
 	unlock_page_cgroup(pc);
 	/*
@@ -2532,6 +2546,8 @@ direct_uncharge:
 static struct mem_cgroup *
 __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
+	int i;
+	int count;
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
 	int page_size = PAGE_SIZE;
@@ -2545,6 +2561,7 @@ __mem_cgroup_uncharge_common(struct page
 	if (PageTransHuge(page))
 		page_size <<= compound_order(page);
 
+	count = page_size >> PAGE_SHIFT;
 	/*
 	 * Check if our page_cgroup is valid
 	 */
@@ -2577,7 +2594,8 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	mem_cgroup_charge_statistics(mem, pc, false);
+	for (i = 0; i < count; i++)
+		mem_cgroup_charge_statistics(mem, pc + i, false);
 
 	ClearPageCgroupUsed(pc);
 	/*
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch

