From: akpm@linux-foundation.org
Subject: [merged] thp-fix-comment-about-memory-barrier.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:07 -0700
Message-ID: <20130430184907.9326331C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:38326 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3StJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:09 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so84784yha.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, a.p.zijlstra@chello.nl, aarcange@redhat.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: THP: fix comment about memory barrier
has been removed from the -mm tree.  Its filename was
     thp-fix-comment-about-memory-barrier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: THP: fix comment about memory barrier

Now, memory barrier in __do_huge_pmd_anonymous_page doesn't work.  Because
lru_cache_add_lru uses pagevec so it could miss spinlock easily so above
rule was broken so user might see inconsistent data.

I was not first person who pointed out the problem.  Mel and Peter pointed
out a few months ago and Peter pointed out further that even
spin_lock/unlock can't make sure it.  http://marc.info/?t=134333512700004

	In particular:

        	*A = a;
        	LOCK
        	UNLOCK
        	*B = b;

	may occur as:

        	LOCK, STORE *B, STORE *A, UNLOCK

At last, Hugh pointed out that even we don't need memory barrier in there
because __SetPageUpdate already have done it from Nick's 0ed361dec ("mm:
fix PageUptodate data race") explicitly.

So this patch fixes comment on THP and adds same comment for
do_anonymous_page, too because everybody except Hugh was missing that.  It
means we need a comment about that.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 +++++------
 mm/memory.c      |    5 +++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~thp-fix-comment-about-memory-barrier mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-comment-about-memory-barrier
+++ a/mm/huge_memory.c
@@ -713,6 +713,11 @@ static int __do_huge_pmd_anonymous_page(
 		return VM_FAULT_OOM;
 
 	clear_huge_page(page, haddr, HPAGE_PMD_NR);
+	/*
+	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * clear_huge_page writes become visible before the set_pmd_at()
+	 * write.
+	 */
 	__SetPageUptodate(page);
 
 	spin_lock(&mm->page_table_lock);
@@ -724,12 +729,6 @@ static int __do_huge_pmd_anonymous_page(
 	} else {
 		pmd_t entry;
 		entry = mk_huge_pmd(page, vma);
-		/*
-		 * The spinlocking to take the lru_lock inside
-		 * page_add_new_anon_rmap() acts as a full memory
-		 * barrier to be sure clear_huge_page writes become
-		 * visible after the set_pmd_at() write.
-		 */
 		page_add_new_anon_rmap(page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
 		pgtable_trans_huge_deposit(mm, pgtable);
diff -puN mm/memory.c~thp-fix-comment-about-memory-barrier mm/memory.c
--- a/mm/memory.c~thp-fix-comment-about-memory-barrier
+++ a/mm/memory.c
@@ -3244,6 +3244,11 @@ static int do_anonymous_page(struct mm_s
 	page = alloc_zeroed_user_highpage_movable(vma, address);
 	if (!page)
 		goto oom;
+	/*
+	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * preceeding stores to the page contents become visible before
+	 * the set_pte_at() write.
+	 */
 	__SetPageUptodate(page);
 
 	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
frontswap-make-frontswap_init-use-a-pointer-for-the-ops.patch
mm-frontswap-cleanup-code.patch
frontswap-get-rid-of-swap_lock-dependency.patch
mm-cleancache-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
cleancache-make-cleancache_init-use-a-pointer-for-the-ops.patch
mm-cleancache-clean-up-cleancache_enabled.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-zcache-to-be-built-loaded-as-a-module.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
block-aio-batch-completion-for-bios-kiocbs.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

