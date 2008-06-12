From: akpm@linux-foundation.org
Subject: - always_inline-timespec_add_ns.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:41 -0700
Message-ID: <200806122037.m5CKbfw9005452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372AbYFLUtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, andi@firstfloor.org, hancockr@shaw.ca, jeremy.fitzhardinge@citrix.com, johnstul@us.ibm.com, lists@nerdbynature.de, mingo@elte.hu, segher@kernel.crashing.org, tglx@lin


The patch titled
     always_inline timespec_add_ns
has been removed from the -mm tree.  Its filename was
     always_inline-timespec_add_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: always_inline timespec_add_ns
From: Jeremy Fitzhardinge <jeremy@goop.org>

timespec_add_ns is used from the x86-64 vdso, which cannot call out to
other kernel code.  Make sure that timespec_add_ns is always inlined (and
only uses always_inlined functions) to make sure there are no unexpected
calls.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/time.h~always_inline-timespec_add_ns include/linux/time.h
--- a/include/linux/time.h~always_inline-timespec_add_ns
+++ a/include/linux/time.h
@@ -170,10 +170,13 @@ extern struct timeval ns_to_timeval(cons
  * timespec_add_ns - Adds nanoseconds to a timespec
  * @a:		pointer to timespec to be incremented
  * @ns:		unsigned nanoseconds value to be added
+ *
+ * This must always be inlined because its used from the x86-64 vdso,
+ * which cannot call other kernel functions.
  */
-static inline void timespec_add_ns(struct timespec *a, u64 ns)
+static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 {
-	a->tv_sec += iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
+	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
 	a->tv_nsec = ns;
 }
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch

