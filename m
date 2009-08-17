From: akpm@linux-foundation.org
Subject: + synaptics-touchscreen-for-htc-dream-check-that-smbus-is-available.patch added to -mm tree
Date: Mon, 17 Aug 2009 16:48:18 -0700
Message-ID: <200908172348.n7HNmIAR018153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758428AbZHQXsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 19:48:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, arve@android.com, dtor@mail.ru, greg@kroah.com, soni.trilok@gmail.com, swetland@google.com


The patch titled
     Synaptics touchscreen for HTC Dream: check that smbus is available
has been added to the -mm tree.  Its filename is
     synaptics-touchscreen-for-htc-dream-check-that-smbus-is-available.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Synaptics touchscreen for HTC Dream: check that smbus is available
From: Pavel Machek <pavel@ucw.cz>

Check that SMBUS APIs are available in touchscreen driver.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: Trilok Soni <soni.trilok@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: <arve@android.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/dream/synaptics_i2c_rmi.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/staging/dream/synaptics_i2c_rmi.c~synaptics-touchscreen-for-htc-dream-check-that-smbus-is-available drivers/staging/dream/synaptics_i2c_rmi.c
--- a/drivers/staging/dream/synaptics_i2c_rmi.c~synaptics-touchscreen-for-htc-dream-check-that-smbus-is-available
+++ a/drivers/staging/dream/synaptics_i2c_rmi.c
@@ -373,6 +373,12 @@ static int __devinit synaptics_ts_probe(
 		goto err_check_functionality_failed;
 	}
 
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
+		pr_err("synaptics_ts_probe: need I2C_FUNC_SMBUS_WORD_DATA\n");
+		ret = -ENODEV;
+		goto err_check_functionality_failed;
+	}
+
 	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
 	if (ts == NULL) {
 		ret = -ENOMEM;
_

Patches currently in -mm which might be from pavel@ucw.cz are

linux-next.patch
spitz-fix-touchscreen-max-presure.patch
synaptics-touchscreen-for-htc-dream-check-that-smbus-is-available.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
lis3-fix-typo.patch
lis3-add-free-fall-wakeup-function-via-platform_data.patch
lis3-add-power-management-functions.patch
lis3-add-power-management-functions-fix.patch
lis3_spi-code-cleanups.patch
framebuffer-support-for-htc-dream.patch
framebuffer-support-for-htc-dream-checkpatch-fixes.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch

