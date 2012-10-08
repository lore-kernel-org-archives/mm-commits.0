From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:15:33 -0700
Message-ID: <20121008231534.24075100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:38399 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2JHXPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:15:35 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so450467yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:15:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haggaie@mellanox.com, a.p.zijlstra@chello.nl, andrea@qumranet.com, avi@redhat.com, cl@linux-foundation.org, hughd@google.com, jslaby@suse.cz, liranl@mellanox.com, ogerlitz@mellanox.com, raindel@mellanox.com, sagig@mellanox.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: call invalidate_range_end in do_wp_page even for zero pages
has been removed from the -mm tree.  Its filename was
     mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end-fix.patch

This patch was dropped because it was folded into mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end.patch

------------------------------------------------------
From: Haggai Eran <haggaie@mellanox.com>
Subject: mm: call invalidate_range_end in do_wp_page even for zero pages

The previous patch "mm: wrap calls to set_pte_at_notify with
invalidate_range_start and invalidate_range_end" only called the
invalidate_range_end mmu notifier function in do_wp_page when the new_page
variable wasn't NULL.  This was done in order to only call
invalidate_range_end after invalidate_range_start was called. 
Unfortunately, there are situations where new_page is NULL and
invalidate_range_start is called.  This caused invalidate_range_start to
be called without a matching invalidate_range_end, causing kvm to loop
indefinitely on the first page fault.

This patch adds a flag variable to do_wp_page that marks whether the
invalidate_range_start notifier was called.  invalidate_range_end is then
called if the flag is true.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Haggai Eran <haggaie@mellanox.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Haggai Eran <haggaie@mellanox.com>
Cc: Shachar Raindel <raindel@mellanox.com>
Cc: Liran Liss <liranl@mellanox.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/memory.c~mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end-fix mm/memory.c
--- a/mm/memory.c~mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end-fix
+++ a/mm/memory.c
@@ -2534,6 +2534,7 @@ static int do_wp_page(struct mm_struct *
 	struct page *dirty_page = NULL;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
+	bool mmun_called = false;	/* For mmu_notifiers */
 
 	old_page = vm_normal_page(vma, address, orig_pte);
 	if (!old_page) {
@@ -2711,8 +2712,9 @@ gotten:
 	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
 
-	mmun_start = address & PAGE_MASK;
-	mmun_end   = (address & PAGE_MASK) + PAGE_SIZE;
+	mmun_start  = address & PAGE_MASK;
+	mmun_end    = (address & PAGE_MASK) + PAGE_SIZE;
+	mmun_called = true;
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 
 	/*
@@ -2781,8 +2783,7 @@ gotten:
 		page_cache_release(new_page);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
-	if (new_page)
-		/* Only call the end notifier if the begin was called. */
+	if (mmun_called)
 		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	if (old_page) {
 		/*
_

Patches currently in -mm which might be from haggaie@mellanox.com are

mm-mmu_notifier-have-mmu_notifiers-use-a-global-srcu-so-they-may-safely-schedule.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
mm-mmu_notifier-make-the-mmu_notifier-srcu-static.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end.patch

