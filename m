From: akpm@linux-foundation.org
Subject: + mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end-fix.patch added to -mm tree
Date: Wed, 19 Sep 2012 15:07:42 -0700
Message-ID: <20120919220742.79516100101@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:63634 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2ISWHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Sep 2012 18:07:44 -0400
Received: by qcqs25 with SMTP id s25so212797qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Sep 2012 15:07:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haggaie@mellanox.com, a.p.zijlstra@chello.nl, andrea@qumranet.com, avi@redhat.com, cl@linux-foundation.org, hughd@google.com, jslaby@suse.cz, liranl@mellanox.com, ogerlitz@mellanox.com, raindel@mellanox.com, sagig@mellanox.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: mm: call invalidate_range_end in do_wp_page even for zero pages
has been added to the -mm tree.  Its filename is
     mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2529,6 +2529,7 @@ static int do_wp_page(struct mm_struct *
 	struct page *dirty_page = NULL;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
+	bool mmun_called = false;	/* For mmu_notifiers */
 
 	old_page = vm_normal_page(vma, address, orig_pte);
 	if (!old_page) {
@@ -2706,8 +2707,9 @@ gotten:
 	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
 
-	mmun_start = address & PAGE_MASK;
-	mmun_end   = (address & PAGE_MASK) + PAGE_SIZE;
+	mmun_start  = address & PAGE_MASK;
+	mmun_end    = (address & PAGE_MASK) + PAGE_SIZE;
+	mmun_called = true;
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 
 	/*
@@ -2776,8 +2778,7 @@ gotten:
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

linux-next.patch
mm-mmu_notifier-have-mmu_notifiers-use-a-global-srcu-so-they-may-safely-schedule.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
mm-mmu_notifier-make-the-mmu_notifier-srcu-static.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end.patch
mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end-fix.patch

