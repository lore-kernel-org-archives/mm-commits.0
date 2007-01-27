From: akpm@osdl.org
Subject: - remove-__devinit-markings-from-rtc_sysfs_add_device.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:32:16 -0800
Message-ID: <200701270132.l0R1WGea031915@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35619 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbXA0Bdw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:33:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, a.zummo@towertech.it, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     remove __devinit markings from rtc_sysfs_add_device()
has been removed from the -mm tree.  Its filename was
     remove-__devinit-markings-from-rtc_sysfs_add_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
search-a-little-harder-for-mkimage.patch
some-rtc-documentation-updates.patch
