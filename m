From: akpm@linux-foundation.org
Subject: - fixup-container_of-usage.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:26 -0800
Message-ID: <200802082016.m18KG7eC010678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752724AbYBHUuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:50:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Fix container_of() usage
has been removed from the -mm tree.  Its filename was
     fixup-container_of-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix container_of() usage
From: Alexey Dobriyan <adobriyan@sw.ru>

Using "attr" twice is not OK, because it effectively prohibits such
container_of() on variables not named "attr".

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/cpu/sh4/sq.c    |    2 +-
 drivers/lguest/lguest_device.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sh/kernel/cpu/sh4/sq.c~fixup-container_of-usage arch/sh/kernel/cpu/sh4/sq.c
--- a/arch/sh/kernel/cpu/sh4/sq.c~fixup-container_of-usage
+++ a/arch/sh/kernel/cpu/sh4/sq.c
@@ -263,7 +263,7 @@ struct sq_sysfs_attr {
 	ssize_t (*store)(const char *buf, size_t count);
 };
 
-#define to_sq_sysfs_attr(attr)	container_of(attr, struct sq_sysfs_attr, attr)
+#define to_sq_sysfs_attr(a)	container_of(a, struct sq_sysfs_attr, attr)
 
 static ssize_t sq_sysfs_show(struct kobject *kobj, struct attribute *attr,
 			     char *buf)
diff -puN drivers/lguest/lguest_device.c~fixup-container_of-usage drivers/lguest/lguest_device.c
--- a/drivers/lguest/lguest_device.c~fixup-container_of-usage
+++ a/drivers/lguest/lguest_device.c
@@ -47,7 +47,7 @@ struct lguest_device {
 /* Since the virtio infrastructure hands us a pointer to the virtio_device all
  * the time, it helps to have a curt macro to get a pointer to the struct
  * lguest_device it's enclosed in.  */
-#define to_lgdev(vdev) container_of(vdev, struct lguest_device, vdev)
+#define to_lgdev(vd) container_of(vd, struct lguest_device, vdev)
 
 /*D:130
  * Device configurations
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
single_open-seq_release-leak-diagnostics.patch
