From: akpm@linux-foundation.org
Subject: + thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch added to -mm tree
Date: Wed, 12 Sep 2012 14:38:27 -0700
Message-ID: <20120912213827.A592E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:40724 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab2ILVi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 17:38:29 -0400
Received: by vbis24 with SMTP id s24so246757vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 14:38:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, walken@google.com


The patch titled
     Subject: thp: khugepaged_prealloc_page() forgot to reset the page alloc indicator
has been added to the -mm tree.  Its filename is
     thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: khugepaged_prealloc_page() forgot to reset the page alloc indicator

If NUMA is enabled, the indicator is not reset if the previous page
request failed, ausing us to trigger the BUG_ON() in
khugepaged_alloc_page().

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator mm/huge_memory.c
--- a/mm/huge_memory.c~thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator
+++ a/mm/huge_memory.c
@@ -1822,6 +1822,7 @@ static bool khugepaged_prealloc_page(str
 			return false;
 
 		*wait = false;
+		*hpage = NULL;
 		khugepaged_alloc_sleep();
 	} else if (*hpage) {
 		put_page(*hpage);
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
mm-mmu_notifier-make-the-mmu_notifier-srcu-static.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch

