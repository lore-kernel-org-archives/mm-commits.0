From: akpm@linux-foundation.org
Subject: - unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:48:29 -0800
Message-ID: <200801290148.m0T1mTnk027353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38519 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933AbYA2B66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:58:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     unbork gregkh-driver-kset-convert-sys-devices-to-use-kset_create (vio.c)
has been removed from the -mm tree.  Its filename was
     unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unbork gregkh-driver-kset-convert-sys-devices-to-use-kset_create (vio.c)
From: Badari Pulavarty <pbadari@gmail.com>

Above patch renamed devices_subsys to devices_kset to catch all users of
the variable. Need fixes to vio.

# make -j8 zImage
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1389:2: warning: #warning syscall revokeat not implemented
<stdin>:1393:2: warning: #warning syscall frevoke not implemented
  CHK     include/linux/compile.h
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/powerpc/kernel/built-in.o(.toc+0x1548): undefined reference to
`devices_subsys'
make: *** [.tmp_vmlinux1] Error 1

Here is the patch, Is this correct usage ?

[akpm@linux-foundation.org: coding-style fix]
Cc: Badari Pulavarty <pbadari@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vio.c |    4 +---
 drivers/base/base.h       |    2 --
 include/linux/device.h    |    1 +
 3 files changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/kernel/vio.c~unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc
+++ a/arch/powerpc/kernel/vio.c
@@ -37,8 +37,6 @@
 #include <asm/iseries/hv_call_xm.h>
 #include <asm/iseries/iommu.h>
 
-extern struct kset devices_subsys; /* needed for vio_find_name() */
-
 static struct bus_type vio_bus_type;
 
 static struct vio_dev vio_bus_device  = { /* fake "parent" device */
@@ -369,7 +367,7 @@ static struct vio_dev *vio_find_name(con
 {
 	struct kobject *found;
 
-	found = kset_find_obj(&devices_subsys, kobj_name);
+	found = kset_find_obj(devices_kset, kobj_name);
 	if (!found)
 		return NULL;
 
diff -puN drivers/base/base.h~unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc drivers/base/base.h
--- a/drivers/base/base.h~unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc
+++ a/drivers/base/base.h
@@ -79,8 +79,6 @@ extern char *make_class_name(const char 
 
 extern int devres_release_all(struct device *dev);
 
-extern struct kset *devices_kset;
-
 #if defined(CONFIG_MODULES) && defined(CONFIG_SYSFS)
 extern void module_add_driver(struct module *mod, struct device_driver *drv);
 extern void module_remove_driver(struct device_driver *drv);
diff -puN include/linux/device.h~unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc include/linux/device.h
--- a/include/linux/device.h~unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc
+++ a/include/linux/device.h
@@ -110,6 +110,7 @@ extern int bus_unregister_notifier(struc
 #define BUS_NOTIFY_UNBIND_DRIVER	0x00000004 /* driver about to be
 						      unbound */
 
+extern struct kset *devices_kset;
 extern struct kset *bus_get_kset(struct bus_type *bus);
 extern struct klist *bus_get_device_klist(struct bus_type *bus);
 
_

Patches currently in -mm which might be from pbadari@gmail.com are

origin.patch
mem-controller-gfp-mask-fix.patch
