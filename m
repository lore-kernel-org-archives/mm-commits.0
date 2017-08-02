From: akpm@linux-foundation.org
Subject: + mm-migrate-fix-barriers-around-tlb_flush_pending.patch added to -mm tree
Date: Wed, 02 Aug 2017 16:34:00 -0700
Message-ID: <59826168.NA7qi4RSpf5e12Na%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbdHBXeB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 19:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namit@vmware.com, aarcange@redhat.com, davem@davemloft.net, heiko.carstens@de.ibm.com, hughd@google.com, jdike@addtoit.com, linux@armlinux.org.uk, luto@kernel.org, mgorman@suse.de, mgorman@techsingularity.net, minchan@kernel.org, mingo@redhat.com, nadav.amit@gmail.com, riel@redhat.com, schwidefsky@de.ibm.com, sergey.senozhatsky@gmail.com, tony.luck@intel.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix barriers around tlb_flush_pending
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-barriers-around-tlb_flush_pending.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-barriers-around-tlb_flush_pending.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-barriers-around-tlb_flush_pending.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: mm: migrate: fix barriers around tlb_flush_pending

Reading tlb_flush_pending while the page-table lock is taken does not
require a barrier, since the lock/unlock already acts as a barrier. 
Removing the barrier in mm_tlb_flush_pending() to address this issue.

However, migrate_misplaced_transhuge_page() calls mm_tlb_flush_pending()
while the page-table lock is already released, which may present a problem
on architectures with weak memory model (PPC).  To deal with this case, a
new parameter is added to mm_tlb_flush_pending() to indicate if it is read
without the page-table lock taken, and calling smp_mb__after_unlock_lock()
in this case.

Link: http://lkml.kernel.org/r/20170802000818.4760-3-namit@vmware.com
Signed-off-by: Nadav Amit <namit@vmware.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN include/linux/mm_types.h~mm-migrate-fix-barriers-around-tlb_flush_pending include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-migrate-fix-barriers-around-tlb_flush_pending
+++ a/include/linux/mm_types.h
@@ -526,12 +526,12 @@ static inline cpumask_t *mm_cpumask(stru
 /*
  * Memory barriers to keep this state in sync are graciously provided by
  * the page table locks, outside of which no page table modifications happen.
- * The barriers below prevent the compiler from re-ordering the instructions
- * around the memory barriers that are already present in the code.
+ * The barriers are used to ensure the order between tlb_flush_pending updates,
+ * which happen while the lock is not taken, and the PTE updates, which happen
+ * while the lock is taken, are serialized.
  */
 static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
 {
-	barrier();
 	return atomic_read(&mm->tlb_flush_pending) > 0;
 }
 
@@ -554,7 +554,13 @@ static inline void inc_tlb_flush_pending
 /* Clearing is done after a TLB flush, which also provides a barrier. */
 static inline void dec_tlb_flush_pending(struct mm_struct *mm)
 {
-	barrier();
+	/*
+	 * Guarantee that the tlb_flush_pending does not not leak into the
+	 * critical section, since we must order the PTE change and changes to
+	 * the pending TLB flush indication. We could have relied on TLB flush
+	 * as a memory barrier, but this behavior is not clearly documented.
+	 */
+	smp_mb__before_atomic();
 	atomic_dec(&mm->tlb_flush_pending);
 }
 #else
_

Patches currently in -mm which might be from namit@vmware.com are

mm-migrate-fix-barriers-around-tlb_flush_pending.patch
revert-mm-numa-defer-tlb-flush-for-thp-migration-as-long-as-possible.patch

