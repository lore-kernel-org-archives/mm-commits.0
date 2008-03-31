From: akpm@linux-foundation.org
Subject: - fix-small-mem-leak-in-driver_add_kobj.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:18:19 -0700
Message-ID: <200803312018.m2VKIJh0024048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754938AbYCaUbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:31:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     driver core: fix small mem leak in driver_add_kobj()
has been removed from the -mm tree.  Its filename was
     fix-small-mem-leak-in-driver_add_kobj.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver core: fix small mem leak in driver_add_kobj()
From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker spotted that we leak the storage allocated to 'name' in
int driver_add_kobj().  The leak looks legit to me - this is the code :

int driver_add_kobj(struct device_driver *drv, struct kobject *kobj,
                    const char *fmt, ...)
{
        va_list args;
        char *name;
        int ret;

        va_start(args, fmt);
        name = kvasprintf(GFP_KERNEL, fmt, args);
        ^^^^^^^^ This dynamically allocates space...

        va_end(args);

        if (!name)
                return -ENOMEM;

        return kobject_add(kobj, &drv->p->kobj, "%s", name);
	^^^^^^^^ This neglects to free the space allocated
}

Inside kobject_add() a copy of 'name' will be made and used.  As far as I can
see, Coverity is correct in flagging this as a leak, but I'd like some
configmation before the patch is applied.

This should fix it.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/driver.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/base/driver.c~fix-small-mem-leak-in-driver_add_kobj drivers/base/driver.c
--- a/drivers/base/driver.c~fix-small-mem-leak-in-driver_add_kobj
+++ a/drivers/base/driver.c
@@ -133,6 +133,7 @@ int driver_add_kobj(struct device_driver
 {
 	va_list args;
 	char *name;
+	int ret;
 
 	va_start(args, fmt);
 	name = kvasprintf(GFP_KERNEL, fmt, args);
@@ -141,7 +142,9 @@ int driver_add_kobj(struct device_driver
 	if (!name)
 		return -ENOMEM;
 
-	return kobject_add(kobj, &drv->p->kobj, "%s", name);
+	ret = kobject_add(kobj, &drv->p->kobj, "%s", name);
+	kfree(name);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(driver_add_kobj);
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
pci-hotplug-fix-leaks-in-ibm-hot-plug-controller-driver-ibmphp_init_devno.patch
git-sh.patch
usb-mem-leak-fixes-for-amd-5536-udc-high-full-speed-usb-device-controller-driver.patch

