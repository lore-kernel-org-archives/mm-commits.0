From: akpm@linux-foundation.org
Subject: + thp-transhuge-memcg-commit-tail-pages-at-charge.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:17 -0800
Message-ID: <201012152357.oBFNvHZ8013584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755887Ab0LOX5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, aarcange@redhat.com


The patch titled
     thp: transhuge-memcg: commit tail pages at charge
has been added to the -mm tree.  Its filename is
     thp-transhuge-memcg-commit-tail-pages-at-charge.patch

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
@@ -2095,23 +2095,10 @@ struct mem_cgroup *try_get_mem_cgroup_fr
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
@@ -2136,6 +2123,33 @@ static void __mem_cgroup_commit_charge(s
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
@@ -2533,6 +2547,8 @@ direct_uncharge:
 static struct mem_cgroup *
 __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
+	int i;
+	int count;
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
 	int page_size = PAGE_SIZE;
@@ -2546,6 +2562,7 @@ __mem_cgroup_uncharge_common(struct page
 	if (PageTransHuge(page))
 		page_size <<= compound_order(page);
 
+	count = page_size >> PAGE_SHIFT;
 	/*
 	 * Check if our page_cgroup is valid
 	 */
@@ -2578,7 +2595,8 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	mem_cgroup_charge_statistics(mem, pc, false);
+	for (i = 0; i < count; i++)
+		mem_cgroup_charge_statistics(mem, pc + i, false);
 
 	ClearPageCgroupUsed(pc);
 	/*
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

thp-transhuge-memcg-commit-tail-pages-at-charge.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch

