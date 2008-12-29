From: akpm@linux-foundation.org
Subject: - linux-timexh-cleanup-for-userspace.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:18:50 -0800
Message-ID: <200812291918.mBTJIoK9031119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbYL2TTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:19:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     linux/timex.h: cleanup for userspace
has been removed from the -mm tree.  Its filename was
     linux-timexh-cleanup-for-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux/timex.h: cleanup for userspace
From: Mike Frysinger <vapier@gentoo.org>

Move all the kernel-specific defines and includes into the __KERNEL__
section so that they don't get leaked into userspace.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |   73 ++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff -puN include/linux/timex.h~linux-timexh-cleanup-for-userspace include/linux/timex.h
--- a/include/linux/timex.h~linux-timexh-cleanup-for-userspace
+++ a/include/linux/timex.h
@@ -53,47 +53,11 @@
 #ifndef _LINUX_TIMEX_H
 #define _LINUX_TIMEX_H
 
-#include <linux/compiler.h>
 #include <linux/time.h>
 
-#include <asm/param.h>
-
 #define NTP_API		4	/* NTP API version */
 
 /*
- * SHIFT_KG and SHIFT_KF establish the damping of the PLL and are chosen
- * for a slightly underdamped convergence characteristic. SHIFT_KH
- * establishes the damping of the FLL and is chosen by wisdom and black
- * art.
- *
- * MAXTC establishes the maximum time constant of the PLL. With the
- * SHIFT_KG and SHIFT_KF values given and a time constant range from
- * zero to MAXTC, the PLL will converge in 15 minutes to 16 hours,
- * respectively.
- */
-#define SHIFT_PLL	4	/* PLL frequency factor (shift) */
-#define SHIFT_FLL	2	/* FLL frequency factor (shift) */
-#define MAXTC		10	/* maximum time constant (shift) */
-
-/*
- * SHIFT_USEC defines the scaling (shift) of the time_freq and
- * time_tolerance variables, which represent the current frequency
- * offset and maximum frequency tolerance.
- */
-#define SHIFT_USEC 16		/* frequency offset scale (shift) */
-#define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
-#define PPM_SCALE_INV_SHIFT 19
-#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
-		       PPM_SCALE + 1)
-
-#define MAXPHASE 500000000l	/* max phase error (ns) */
-#define MAXFREQ 500000		/* max frequency error (ns/s) */
-#define MAXFREQ_SCALED ((s64)MAXFREQ << NTP_SCALE_SHIFT)
-#define MINSEC 256		/* min interval between updates (s) */
-#define MAXSEC 2048		/* max interval between updates (s) */
-#define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
-
-/*
  * syscall interface - used (mainly by NTP daemon)
  * to discipline kernel clock oscillator
  */
@@ -199,9 +163,46 @@ struct timex {
 #define TIME_BAD	TIME_ERROR /* bw compat */
 
 #ifdef __KERNEL__
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <linux/param.h>
+
 #include <asm/timex.h>
 
 /*
+ * SHIFT_KG and SHIFT_KF establish the damping of the PLL and are chosen
+ * for a slightly underdamped convergence characteristic. SHIFT_KH
+ * establishes the damping of the FLL and is chosen by wisdom and black
+ * art.
+ *
+ * MAXTC establishes the maximum time constant of the PLL. With the
+ * SHIFT_KG and SHIFT_KF values given and a time constant range from
+ * zero to MAXTC, the PLL will converge in 15 minutes to 16 hours,
+ * respectively.
+ */
+#define SHIFT_PLL	4	/* PLL frequency factor (shift) */
+#define SHIFT_FLL	2	/* FLL frequency factor (shift) */
+#define MAXTC		10	/* maximum time constant (shift) */
+
+/*
+ * SHIFT_USEC defines the scaling (shift) of the time_freq and
+ * time_tolerance variables, which represent the current frequency
+ * offset and maximum frequency tolerance.
+ */
+#define SHIFT_USEC 16		/* frequency offset scale (shift) */
+#define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
+#define PPM_SCALE_INV_SHIFT 19
+#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
+		       PPM_SCALE + 1)
+
+#define MAXPHASE 500000000l	/* max phase error (ns) */
+#define MAXFREQ 500000		/* max frequency error (ns/s) */
+#define MAXFREQ_SCALED ((s64)MAXFREQ << NTP_SCALE_SHIFT)
+#define MINSEC 256		/* min interval between updates (s) */
+#define MAXSEC 2048		/* max interval between updates (s) */
+#define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
+
+/*
  * kernel variables
  * Note: maximum error = NTP synch distance = dispersion + delay / 2;
  * estimated error = NTP dispersion.
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
autodetect_raid-add-missing-__init-marking.patch
checkpatch-try-to-catch-missing-vmlinux_symbol-in-vmlinuxldsh.patch

