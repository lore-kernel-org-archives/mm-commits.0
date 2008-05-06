From: akpm@linux-foundation.org
Subject: + arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch added to -mm tree
Date: Tue, 06 May 2008 11:46:56 -0700
Message-ID: <200805061846.m46IkugB021699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754049AbYEFSrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias@kaehlcke.net, rmk@arm.linux.org.uk, tony@atomide.com


The patch titled
     ARM: OMAP1: N770: Convert audio_pwr_sem in a mutex
has been added to the -mm tree.  Its filename is
     arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ARM: OMAP1: N770: Convert audio_pwr_sem in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

ARM: OMAP1: N770: The semaphore audio_pwr_sem is used as a
mutex. Convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap1/board-nokia770.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/arm/mach-omap1/board-nokia770.c~arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex arch/arm/mach-omap1/board-nokia770.c
--- a/arch/arm/mach-omap1/board-nokia770.c~arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex
+++ a/arch/arm/mach-omap1/board-nokia770.c
@@ -202,7 +202,7 @@ static struct omap_board_config_kernel n
 #define	AMPLIFIER_CTRL_GPIO	58
 
 static struct clk *dspxor_ck;
-static DECLARE_MUTEX(audio_pwr_sem);
+static DEFINE_MUTEX(audio_pwr_lock);
 /*
  * audio_pwr_state
  * +--+-------------------------+---------------------------------------+
@@ -218,7 +218,7 @@ static DECLARE_MUTEX(audio_pwr_sem);
 static int audio_pwr_state = -1;
 
 /*
- * audio_pwr_up / down should be called under audio_pwr_sem
+ * audio_pwr_up / down should be called under audio_pwr_lock
  */
 static void nokia770_audio_pwr_up(void)
 {
@@ -237,11 +237,11 @@ static void nokia770_audio_pwr_up(void)
 
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
@@ -258,19 +258,19 @@ static void nokia770_audio_pwr_down(void
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
@@ -283,7 +283,7 @@ nokia770_audio_pwr_down_request(struct d
 		}
 		break;
 	}
-	up(&audio_pwr_sem);
+	mutex_unlock(&audio_pwr_lock);
 	return 0;
 }
 
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch

