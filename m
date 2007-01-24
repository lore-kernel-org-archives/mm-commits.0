From: akpm@osdl.org
Subject: + remove-__devinit-markings-from-rtc_sysfs_add_device.patch added to -mm tree
Date: Wed, 24 Jan 2007 01:14:42 -0800
Message-ID: <200701240914.l0O9Egp7013590@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58874 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933191AbXAXJQE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 04:16:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.zummo@towertech.it, stable@kernel.org


The patch titled
     remove __devinit markings from rtc_sysfs_add_device()
has been added to the -mm tree.  Its filename is
     remove-__devinit-markings-from-rtc_sysfs_add_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove __devinit markings from rtc_sysfs_add_device()
From: Mike Frysinger <vapier@gentoo.org>

rtc_sysfs_add_device is needed even after dev initialization, so drop __devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-sysfs.c~remove-__devinit-markings-from-rtc_sysfs_add_device drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~remove-__devinit-markings-from-rtc_sysfs_add_device
+++ a/drivers/rtc/rtc-sysfs.c
@@ -78,7 +78,7 @@ static struct attribute_group rtc_attr_g
 	.attrs = rtc_attrs,
 };
 
-static int __devinit rtc_sysfs_add_device(struct class_device *class_dev,
+static int rtc_sysfs_add_device(struct class_device *class_dev,
 					struct class_interface *class_intf)
 {
 	int err;
_

Patches currently in -mm which might be from vapier@gentoo.org are

remove-__devinit-markings-from-rtc_sysfs_add_device.patch
search-a-little-harder-for-mkimage.patch
