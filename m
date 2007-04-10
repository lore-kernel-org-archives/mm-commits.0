From: akpm@linux-foundation.org
Subject: + input-ucb1400-set-up-drivers-name-to-show-in-sysfs.patch added to -mm tree
Date: Mon, 09 Apr 2007 21:32:50 -0700
Message-ID: <200704100432.l3A4WoZU031322@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43306 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030332AbXDJEc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 00:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cbrake@bec-systems.com, dtor@mail.ru


The patch titled
     input: ucb1400: set up driver's name to show in sysfs
has been added to the -mm tree.  Its filename is
     input-ucb1400-set-up-drivers-name-to-show-in-sysfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: input: ucb1400: set up driver's name to show in sysfs
From: Cliff Brake <cbrake@bec-systems.com>

The UCB1400 is missing a name parameter in the device_driver struct.  This
causes missing information in the /sys tree and seems to cause other
problems with the AC97 functionality.  This was tested on a PXA270 system.

Signed-off-by: Cliff Brake <cbrake@bec-systems.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ucb1400_ts.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/touchscreen/ucb1400_ts.c~input-ucb1400-set-up-drivers-name-to-show-in-sysfs drivers/input/touchscreen/ucb1400_ts.c
--- a/drivers/input/touchscreen/ucb1400_ts.c~input-ucb1400-set-up-drivers-name-to-show-in-sysfs
+++ a/drivers/input/touchscreen/ucb1400_ts.c
@@ -553,6 +553,7 @@ static int ucb1400_ts_remove(struct devi
 }
 
 static struct device_driver ucb1400_ts_driver = {
+	.name		= "ucb1400_ts",
 	.owner		= THIS_MODULE,
 	.bus		= &ac97_bus_type,
 	.probe		= ucb1400_ts_probe,
_

Patches currently in -mm which might be from cbrake@bec-systems.com are

input-ucb1400-set-up-drivers-name-to-show-in-sysfs.patch
