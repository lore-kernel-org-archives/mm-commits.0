From: akpm@osdl.org
Subject: + use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch added to -mm tree
Date: Wed, 03 Jan 2007 13:00:27 -0800
Message-ID: <200701032100.l03L0REl031061@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49629 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbXACVCj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 16:02:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deller@gmx.de, linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     use cycle_t instead of u64 in struct time_interpolator
has been added to the -mm tree.  Its filename is
     use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use cycle_t instead of u64 in struct time_interpolator
From: Helge Deller <deller@gmx.de>

The 32bit and 64bit PARISC Linux kernels suffers from the problem, that the
gettimeofday() call sometimes returns non-monotonic times.

The easiest way to fix this, is to drop the PARISC-specific implementation
and switch over to the generic TIME_INTERPOLATION framework.

But in order to make it even compile on 32bit PARISC, the patch below which
touches the generic Linux code, is mandatory.

More information and the full patch with the parisc-specific changes is included in this thread: http://lists.parisc-linux.org/pipermail/parisc-linux/2006-December/031003.html

As far as I could see, this patch does not change anything for the existing
architectures which use this framework (IA64 and SPARC64), since "cycles_t"
is defined there as unsigned 64bit-integer anyway (which then makes this
patch a no-change for them).

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <linux-arch@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/timex.h |    4 ++--
 kernel/timer.c        |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/timex.h~use-cycle_t-instead-of-u64-in-struct-time_interpolator include/linux/timex.h
--- a/include/linux/timex.h~use-cycle_t-instead-of-u64-in-struct-time_interpolator
+++ a/include/linux/timex.h
@@ -255,10 +255,10 @@ struct time_interpolator {
 	u8 jitter;			/* if set compensate for fluctuations */
 	u32 nsec_per_cyc;		/* set by register_time_interpolator() */
 	void *addr;			/* address of counter or function */
-	u64 mask;			/* mask the valid bits of the counter */
+	cycles_t mask;			/* mask the valid bits of the counter */
 	unsigned long offset;		/* nsec offset at last update of interpolator */
 	u64 last_counter;		/* counter value in units of the counter at last update */
-	u64 last_cycle;			/* Last timer value if TIME_SOURCE_JITTER is set */
+	cycles_t last_cycle;		/* Last timer value if TIME_SOURCE_JITTER is set */
 	u64 frequency;			/* frequency in counts/second */
 	long drift;			/* drift in parts-per-million (or -1) */
 	unsigned long skips;		/* skips forward */
diff -puN kernel/timer.c~use-cycle_t-instead-of-u64-in-struct-time_interpolator kernel/timer.c
--- a/kernel/timer.c~use-cycle_t-instead-of-u64-in-struct-time_interpolator
+++ a/kernel/timer.c
@@ -1624,7 +1624,7 @@ struct time_interpolator *time_interpola
 static struct time_interpolator *time_interpolator_list __read_mostly;
 static DEFINE_SPINLOCK(time_interpolator_lock);
 
-static inline u64 time_interpolator_get_cycles(unsigned int src)
+static inline cycles_t time_interpolator_get_cycles(unsigned int src)
 {
 	unsigned long (*x)(void);
 
@@ -1650,8 +1650,8 @@ static inline u64 time_interpolator_get_
 
 	if (time_interpolator->jitter)
 	{
-		u64 lcycle;
-		u64 now;
+		cycles_t lcycle;
+		cycles_t now;
 
 		do {
 			lcycle = time_interpolator->last_cycle;
_

Patches currently in -mm which might be from deller@gmx.de are

use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
