From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-mm-account-for-tlb-flushes-only-when-debugging-fix.patch removed from
 -mm tree
Date: Tue, 21 Jan 2014 14:31:44 -0800
Message-ID: <52def550.j/IWkPoWLe/YZ/4Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaAUWbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 17:31:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@kernel.org, hughd@google.com, hpa@zytor.com, davidlohr@hp.com, alex.shi@linaro.org, mgorman@suse.de

Subject: [folded-merged] x86-mm-account-for-tlb-flushes-only-when-debugging-fix.patch removed from -mm tree
To: mgorman@suse.de,alex.shi@linaro.org,davidlohr@hp.com,hpa@zytor.com,hughd@google.com,mingo@kernel.org,riel@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 14:31:44 -0800


The patch titled
     Subject: x86-mm-account-for-tlb-flushes-only-when-debugging-fix
has been removed from the -mm tree.  Its filename was
     x86-mm-account-for-tlb-flushes-only-when-debugging-fix.patch

This patch was dropped because it was folded into x86-mm-account-for-tlb-flushes-only-when-debugging.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: x86-mm-account-for-tlb-flushes-only-when-debugging-fix

there are times when I am a complete muppet

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H Peter Anvin <hpa@zytor.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    4 +++-
 mm/vmstat.c                   |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/vm_event_item.h~x86-mm-account-for-tlb-flushes-only-when-debugging-fix include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~x86-mm-account-for-tlb-flushes-only-when-debugging-fix
+++ a/include/linux/vm_event_item.h
@@ -72,11 +72,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_ZERO_PAGE_ALLOC_FAILED,
 #endif
 #ifdef CONFIG_DEBUG_TLBFLUSH
+#ifdef CONFIG_SMP
 		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
 		NR_TLB_REMOTE_FLUSH_RECEIVED,/* cpu received ipi for flush */
+#endif /* CONFIG_SMP */
 		NR_TLB_LOCAL_FLUSH_ALL,
 		NR_TLB_LOCAL_FLUSH_ONE,
-#endif
+#endif /* CONFIG_DEBUG_TLBFLUSH */
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/vmstat.c~x86-mm-account-for-tlb-flushes-only-when-debugging-fix mm/vmstat.c
--- a/mm/vmstat.c~x86-mm-account-for-tlb-flushes-only-when-debugging-fix
+++ a/mm/vmstat.c
@@ -851,12 +851,14 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc",
 	"thp_zero_page_alloc_failed",
 #endif
+#ifdef CONFIG_DEBUG_TLBFLUSH
 #ifdef CONFIG_SMP
 	"nr_tlb_remote_flush",
 	"nr_tlb_remote_flush_received",
-#endif
+#endif /* CONFIG_SMP */
 	"nr_tlb_local_flush_all",
 	"nr_tlb_local_flush_one",
+#endif /* CONFIG_DEBUG_TLBFLUSH */
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch

