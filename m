From: akpm@linux-foundation.org
Subject: + dev_printk-and-new-style-class-devices.patch added to -mm tree
Date: Thu, 15 Mar 2007 14:07:44 -0700
Message-ID: <200703152107.l2FL7ixx026459@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40819 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbXCOVIE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:08:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, greg@kroah.com


The patch titled
     dev_printk and new-style class devices
has been added to the -mm tree.  Its filename is
     dev_printk-and-new-style-class-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dev_printk and new-style class devices
From: Jean Delvare <khali@linux-fr.org>

As the new-style class devices (as opposed to old-style struct
class_device) are becoming more widely used, I noticed that the
dev_printk-based functions are not working properly with these.  New-style
class devices have no driver nor bus, almost by definition, and as a result
dev_driver_string(), which is used as the first parameter of dev_printk,
resolves to an empty string.  This causes entries like the following to
show in my logs:

 i2c-2: adapter [SMBus stub driver] registered

Notice the unaesthetical leading whitespace.  In order to fix this problem,
I suggest that we extend dev_driver_string to deal with new-style class
devices:

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/base/core.c~dev_printk-and-new-style-class-devices drivers/base/core.c
--- a/drivers/base/core.c~dev_printk-and-new-style-class-devices
+++ a/drivers/base/core.c
@@ -57,7 +57,8 @@ bool is_lanana_major(unsigned int major)
 const char *dev_driver_string(struct device *dev)
 {
 	return dev->driver ? dev->driver->name :
-			(dev->bus ? dev->bus->name : "");
+			(dev->bus ? dev->bus->name :
+			(dev->class ? dev->class->name : ""));
 }
 EXPORT_SYMBOL(dev_driver_string);
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

sound-strlcpy-is-smart-enough.patch
dev_printk-and-new-style-class-devices.patch
git-dvb.patch
ehea-strlcpy-is-smart-enough.patch
scatterlisth-needs-typesh.patch
cleanup-the-includes-of-linux-pcih.patch
git-s390.patch
blackfin-blackfin-i2c-driver-update-2.patch
xtensa-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
