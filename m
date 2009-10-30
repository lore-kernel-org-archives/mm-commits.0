From: akpm@linux-foundation.org
Subject: [wrecked] synaptics-touchscreen-for-htc-dream-check-that-smbus-is-available.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:47:13 -0700
Message-ID: <200910302047.n9UKlE9w002979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757377AbZJ3Ur7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:47:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, arve@android.com, dtor@mail.ru, greg@kroah.com, soni.trilok@gmail.com, swetland@google.com, mm-commits@vger.kernel.org


The patch titled
     Synaptics touchscreen for HTC Dream: check that smbus is available
has been removed from the -mm tree.  Its filename was
     synaptics-touchscreen-for-htc-dream-check-that-smbus-is-available.patch

This patch was dropped because other changes were merged, which wrecked this patch

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
@@ -379,6 +379,12 @@ static int __devinit synaptics_ts_probe(
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

origin.patch
linux-next.patch
synaptics-touchscreen-for-htc-dream-check-that-smbus-is-available.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

