From: akpm@linux-foundation.org
Subject: - spi-filesystem-api-tweaks.patch removed from -mm tree
Date: Wed, 07 Feb 2007 17:08:08 -0800
Message-ID: <200702080109.l1819DCI001323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48977 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161429AbXBHBJP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 20:09:15 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1819EdD027795
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 7 Feb 2007 17:09:14 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     spi-filesystem-api-tweaks
has been removed from the -mm tree.  Its filename was
     spi-filesystem-api-tweaks.patch

This patch was dropped because greg

------------------------------------------------------
Subject: spi-filesystem-api-tweaks
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spidev.c~spi-filesystem-api-tweaks drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-filesystem-api-tweaks
+++ a/drivers/spi/spidev.c
@@ -89,7 +89,7 @@ spidev_read(struct file *filp, char __us
 	if (count > bufsiz)
 		return -EMSGSIZE;
 
-	spidev = (struct device_data *)filp->private_data;
+	spidev = filp->private_data;
 	spi = spidev->spi;
 
 	mutex_lock(&spidev->buf_lock);
@@ -125,7 +125,7 @@ spidev_write(struct file *filp, const ch
 	if (count > bufsiz)
 		return -EMSGSIZE;
 
-	spidev = (struct device_data *)filp->private_data;
+	spidev = filp->private_data;
 	spi = spidev->spi;
 
 	mutex_lock(&spidev->buf_lock);
@@ -174,7 +174,7 @@ spidev_ioctl(struct inode *inode, struct
 	if (err)
 		return -EFAULT;
 
-	dev_data = (struct device_data *)filp->private_data;
+	dev_data = filp->private_data;
 	spi = dev_data->spi;
 
 	switch (cmd) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-bay-driver-warning-fix.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
spi-filesystem-api-tweaks.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
fix-utrace-utrace-ptrace-compat.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix-3-fix.patch
