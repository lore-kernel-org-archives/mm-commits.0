From: akpm@linux-foundation.org
Subject: - oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:12 -0800
Message-ID: <200711192316.lAJNGC5r001754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbXKSXQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:16:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: barry.kasindorf@amd.com, mingo@elte.hu, robert.richter@amd.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     oProfile: op_model_athalon.c support for AMD Family10h (Barcelona) Performance Counters
has been removed from the -mm tree.  Its filename was
     oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oProfile: op_model_athalon.c support for AMD Family10h (Barcelona) Performance Counters
From: "Barry Kasindorf" <barry.kasindorf@amd.com>

This patch is for controlling the upper 32bits of the event ctrl msrs. 
This includes the upper 4 bits of the event select and the Guest Only and
Host Only bits

This patch is necessary to make Event Based Profiling work reliably on a
Family 10h processor

Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/oprofile/op_model_athlon.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff -puN arch/x86/oprofile/op_model_athlon.c~oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters arch/x86/oprofile/op_model_athlon.c
--- a/arch/x86/oprofile/op_model_athlon.c~oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters
+++ a/arch/x86/oprofile/op_model_athlon.c
@@ -1,6 +1,6 @@
 /**
  * @file op_model_athlon.h
- * athlon / K7 model-specific MSR operations
+ * athlon / K7 / K8 / Family 10h model-specific MSR operations
  *
  * @remark Copyright 2002 OProfile authors
  * @remark Read the file COPYING
@@ -31,12 +31,16 @@
 #define CTRL_WRITE(l,h,msrs,c) do {wrmsr(msrs->controls[(c)].addr, (l), (h));} while (0)
 #define CTRL_SET_ACTIVE(n) (n |= (1<<22))
 #define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
-#define CTRL_CLEAR(x) (x &= (1<<21))
+#define CTRL_CLEAR_LO(x) (x &= (1<<21))
+#define CTRL_CLEAR_HI(x) ( x &= 0xfffffcf0 )
 #define CTRL_SET_ENABLE(val) (val |= 1<<20)
 #define CTRL_SET_USR(val,u) (val |= ((u & 1) << 16))
 #define CTRL_SET_KERN(val,k) (val |= ((k & 1) << 17))
 #define CTRL_SET_UM(val, m) (val |= (m << 8))
-#define CTRL_SET_EVENT(val, e) (val |= e)
+#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
+#define CTRL_SET_EVENT_HIGH(val,e) (val |= ((e >> 8) & 0xf))
+#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
+#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
 
 static unsigned long reset_value[NUM_COUNTERS];
  
@@ -70,7 +74,8 @@ static void athlon_setup_ctrs(struct op_
 		if (unlikely(!CTRL_IS_RESERVED(msrs,i)))
 			continue;
 		CTRL_READ(low, high, msrs, i);
-		CTRL_CLEAR(low);
+		CTRL_CLEAR_LO(low);
+		CTRL_CLEAR_HI(high);
 		CTRL_WRITE(low, high, msrs, i);
 	}
 
@@ -89,12 +94,17 @@ static void athlon_setup_ctrs(struct op_
 			CTR_WRITE(counter_config[i].count, msrs, i);
 
 			CTRL_READ(low, high, msrs, i);
-			CTRL_CLEAR(low);
+			CTRL_CLEAR_LO(low);
+			CTRL_CLEAR_HI(high);
 			CTRL_SET_ENABLE(low);
 			CTRL_SET_USR(low, counter_config[i].user);
 			CTRL_SET_KERN(low, counter_config[i].kernel);
 			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT(low, counter_config[i].event);
+			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
+			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
+			CTRL_SET_HOST_ONLY(high, 0);
+			CTRL_SET_GUEST_ONLY(high, 0);
+
 			CTRL_WRITE(low, high, msrs, i);
 		} else {
 			reset_value[i] = 0;
_

Patches currently in -mm which might be from barry.kasindorf@amd.com are

git-x86.patch
