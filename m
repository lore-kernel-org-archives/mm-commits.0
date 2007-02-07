From: akpm@linux-foundation.org
Subject: + drivers-mdc-use-array_size-macro-when-appropriate.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:05:47 -0800
Message-ID: <200702070005.l1705mEU001172@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56109 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030239AbXBGAGV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:06:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, neilb@suse.de


The patch titled
     drivers/md.c: Use ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     drivers-mdc-use-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/md.c: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/md/md.c~drivers-mdc-use-array_size-macro-when-appropriate drivers/md/md.c
--- a/drivers/md/md.c~drivers-mdc-use-array_size-macro-when-appropriate
+++ a/drivers/md/md.c
@@ -33,6 +33,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/linkage.h>
 #include <linux/raid/md.h>
@@ -2635,8 +2636,7 @@ metadata_store(mddev_t *mddev, const cha
 	minor = simple_strtoul(buf, &e, 10);
 	if (e==buf || (*e && *e != '\n') )
 		return -EINVAL;
-	if (major >= sizeof(super_types)/sizeof(super_types[0]) ||
-	    super_types[major].name == NULL)
+	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
 		return -ENOENT;
 	mddev->major_version = major;
 	mddev->minor_version = minor;
@@ -3973,7 +3973,7 @@ static int set_array_info(mddev_t * mdde
 	if (info->raid_disks == 0) {
 		/* just setting version number for superblock loading */
 		if (info->major_version < 0 ||
-		    info->major_version >= sizeof(super_types)/sizeof(super_types[0]) ||
+		    info->major_version >= ARRAY_SIZE(super_types) ||
 		    super_types[info->major_version].name == NULL) {
 			/* maybe try to auto-load a module? */
 			printk(KERN_INFO 
_

Patches currently in -mm which might be from darwish.07@gmail.com are

arch-arm-use-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
git-dvb.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
dvb-use-array_size-macro-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
atm-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
intel-agp-use-array_size-macro-when-appropriate.patch
reiserfs-use-array_size-macro-when-appropriate.patch
toshiba-acpi-use-array_size-macro-when-appropriate.patch
drm-use-array_size-macro-when-appropriate.patch
