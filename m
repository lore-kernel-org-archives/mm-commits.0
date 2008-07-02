From: akpm@linux-foundation.org
Subject: - arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:46:52 -0700
Message-ID: <200807020746.m627kque005600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbYGBHrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, rmk@arm.linux.org.uk, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     ARM: OMAP1: N770: Convert audio_pwr_sem in a mutex
has been removed from the -mm tree.  Its filename was
     arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ARM: OMAP1: N770: Convert audio_pwr_sem in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

ARM: OMAP1: N770: The semaphore audio_pwr_sem is used as a
mutex. Convert it to the mutex API

[akpm@linux-foundation.org: include mutex.h]
Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap1/board-nokia770.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN arch/arm/mach-omap1/board-nokia770.c~arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex arch/arm/mach-omap1/board-nokia770.c
--- a/arch/arm/mach-omap1/board-nokia770.c~arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex
+++ a/arch/arm/mach-omap1/board-nokia770.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/clk.h>
@@ -202,7 +203,7 @@ static struct omap_board_config_kernel n
 #define	AMPLIFIER_CTRL_GPIO	58
 
 static struct clk *dspxor_ck;
-static DECLARE_MUTEX(audio_pwr_sem);
+static DEFINE_MUTEX(audio_pwr_lock);
 /*
  * audio_pwr_state
  * +--+-------------------------+---------------------------------------+
@@ -218,7 +219,7 @@ static DECLARE_MUTEX(audio_pwr_sem);
 static int audio_pwr_state = -1;
 
 /*
- * audio_pwr_up / down should be called under audio_pwr_sem
+ * audio_pwr_up / down should be called under audio_pwr_lock
  */
 static void nokia770_audio_pwr_up(void)
 {
@@ -237,11 +238,11 @@ static void nokia770_audio_pwr_up(void)
 
 static void codec_delayed_power_down(struct work_struct *work)
 {
-	down(&audio_pwr_sem);
+	mutex_lock(&audio_pwr_lock);
 	if (audio_pwr_state == -1)
 		aic23_power_down();
 	clk_disable(dspxor_ck);
-	up(&audio_pwr_sem);
+	mutex_unlock(&audio_pwr_lock);
 }
 
 static DECLARE_DELAYED_WORK(codec_power_down_work, codec_delayed_power_down);
@@ -258,19 +259,19 @@ static void nokia770_audio_pwr_down(void
 static int
 nokia770_audio_pwr_up_request(struct dsp_kfunc_device *kdev, int stage)
 {
-	down(&audio_pwr_sem);
+	mutex_lock(&audio_pwr_lock);
 	if (audio_pwr_state == -1)
 		nokia770_audio_pwr_up();
 	/* force audio_pwr_state = 0, even if it was 1. */
 	audio_pwr_state = 0;
-	up(&audio_pwr_sem);
+	mutex_unlock(&audio_pwr_lock);
 	return 0;
 }
 
 static int
 nokia770_audio_pwr_down_request(struct dsp_kfunc_device *kdev, int stage)
 {
-	down(&audio_pwr_sem);
+	mutex_lock(&audio_pwr_lock);
 	switch (stage) {
 	case 1:
 		if (audio_pwr_state == 0)
@@ -283,7 +284,7 @@ nokia770_audio_pwr_down_request(struct d
 		}
 		break;
 	}
-	up(&audio_pwr_sem);
+	mutex_unlock(&audio_pwr_lock);
 	return 0;
 }
 
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

linux-next.patch
pxafb-convert-ctrlr_sem-in-a-mutex.patch
sa1100fb-convert-ctrlr_sem-in-a-mutex.patch
hfs-convert-bitmap_lock-in-a-mutex.patch
hfs-convert-extents_lock-in-a-mutex.patch
hfsplus-convert-the-extents_lock-in-a-mutex.patch
ata-over-ethernet-convert-emsgs_sema-in-a-completion.patch
affs-convert-s_bmlock-into-a-mutex.patch

