From: akpm@linux-foundation.org
Subject: + hwmon-coretemp-fix-a-broken-error-path.patch added to -mm tree
Date: Mon, 18 Jun 2007 00:27:48 -0700
Message-ID: <200706180727.l5I7Rmbd030779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757402AbXFRH2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jun 2007 03:28:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, r.marek@assembler.cz


The patch titled
     hwmon/coretemp: fix a broken error path
has been added to the -mm tree.  Its filename is
     hwmon-coretemp-fix-a-broken-error-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hwmon/coretemp: fix a broken error path
From: Jean Delvare <khali@linux-fr.org>

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Rudolf Marek <r.marek@assembler.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/coretemp.c~hwmon-coretemp-fix-a-broken-error-path drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~hwmon-coretemp-fix-a-broken-error-path
+++ a/drivers/hwmon/coretemp.c
@@ -185,6 +185,7 @@ static int __devinit coretemp_probe(stru
 		/* check for microcode update */
 		rdmsr_on_cpu(data->id, MSR_IA32_UCODE_REV, &eax, &edx);
 		if (edx < 0x39) {
+			err = -ENODEV;
 			dev_err(&pdev->dev,
 				"Errata AE18 not fixed, update BIOS or "
 				"microcode of the CPU!\n");
_

Patches currently in -mm which might be from khali@linux-fr.org are

hwmon-coretemp-fix-a-broken-error-path.patch
git-hwmon.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch
tty_io-use-kzalloc.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
