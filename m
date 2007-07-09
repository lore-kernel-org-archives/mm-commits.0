From: akpm@linux-foundation.org
Subject: - geode-mfgpt-support-for-geode-class-machines-update.patch removed from -mm tree
Date: Mon, 09 Jul 2007 12:37:32 -0700
Message-ID: <200707091937.l69JbWGa004895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625AbXGIThk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 15:37:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, mm-commits@vger.kernel.org


The patch titled
     geode-mfgpt-support-for-geode-class-machines update
has been removed from the -mm tree.  Its filename was
     geode-mfgpt-support-for-geode-class-machines-update.patch

This patch was dropped because it was folded into geode-mfgpt-support-for-geode-class-machines.patch

------------------------------------------------------
Subject: geode-mfgpt-support-for-geode-class-machines update
From: Andres Salomon <dilinger@queued.net>

Here's an updated version of this patch which makes ./scripts/checkpatch.pl
happy, and also adds documentation for the 'nomfgpt' kernel arg.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 +++
 arch/i386/kernel/mfgpt.c            |    5 ++---
 include/asm-i386/geode.h            |    4 ++--
 3 files changed, 7 insertions(+), 5 deletions(-)

diff -puN Documentation/kernel-parameters.txt~geode-mfgpt-support-for-geode-class-machines-update Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~geode-mfgpt-support-for-geode-class-machines-update
+++ a/Documentation/kernel-parameters.txt
@@ -1210,6 +1210,9 @@ and is between 256 and 4096 characters. 
 
 	nomce		[IA-32] Machine Check Exception
 
+	nomfgpt		[IA-32] Disable Multi-Function General Purpose
+			Timer usage (for AMD Geode machines).
+
 	noreplace-paravirt	[IA-32,PV_OPS] Don't patch paravirt_ops
 
 	noreplace-smp	[IA-32,SMP] Don't replace SMP instructions
diff -puN arch/i386/kernel/mfgpt.c~geode-mfgpt-support-for-geode-class-machines-update arch/i386/kernel/mfgpt.c
--- a/arch/i386/kernel/mfgpt.c~geode-mfgpt-support-for-geode-class-machines-update
+++ a/arch/i386/kernel/mfgpt.c
@@ -49,7 +49,7 @@ static struct mfgpt_timer_t {
 #define MFGPT_PERIODIC (MFGPT_HZ / HZ)
 
 /* Allow for disabling of MFGPTs */
-static int disable = 0;
+static int disable;
 static int __init mfgpt_disable(char *s)
 {
 	disable = 1;
@@ -187,8 +187,7 @@ int geode_mfgpt_alloc_timer(int timer, i
 			if (i == 5 && domain == MFGPT_DOMAIN_WORKING)
 				break;
 		}
-	}
-	else {
+	} else {
 		/* If they requested a specific timer, try to honor that */
 		if (mfgpt_timers[timer].flags & F_AVAIL)
 			return mfgpt_get(timer, owner);
diff -puN include/asm-i386/geode.h~geode-mfgpt-support-for-geode-class-machines-update include/asm-i386/geode.h
--- a/include/asm-i386/geode.h~geode-mfgpt-support-for-geode-class-machines-update
+++ a/include/asm-i386/geode.h
@@ -203,7 +203,7 @@ extern int geode_mfgpt_toggle_event(int 
 extern int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable);
 extern int geode_mfgpt_alloc_timer(int timer, int domain, struct module *owner);
 
-#define geode_mfgpt_setup_irq(t,c,i) geode_mfgpt_set_irq((t),(c),(i),1)
-#define geode_mfgpt_release_irq(t,c,i) geode_mfgpt_set_irq((t),(c),(i),0)
+#define geode_mfgpt_setup_irq(t, c, i) geode_mfgpt_set_irq((t), (c), (i), 1)
+#define geode_mfgpt_release_irq(t, c, i) geode_mfgpt_set_irq((t), (c), (i), 0)
 
 #endif
_

Patches currently in -mm which might be from dilinger@queued.net are

geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-support-for-geode-class-machines-update.patch
geode-mfgpt-clock-event-device-support.patch
geode-mfgpt-clock-event-device-support-update.patch
