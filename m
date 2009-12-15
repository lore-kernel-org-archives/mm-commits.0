From: akpm@linux-foundation.org
Subject: [merged] drivers-char-miscc-clear-allocation-bit-in-minor-bitmap-when-device-register-fails.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:56:10 -0800
Message-ID: <200912152156.nBFLuAPg015552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761343AbZLOWMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:12:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/misc.c: clear allocation bit in minor bitmap when device register fails
has been removed from the -mm tree.  Its filename was
     drivers-char-miscc-clear-allocation-bit-in-minor-bitmap-when-device-register-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/misc.c: clear allocation bit in minor bitmap when device register fails
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

If there's a failure creating the device (because there's already one with
the same name, for example), the current implementation does not clear the
bit for the allocated minor and that number is lost for future
allocations.

Second, the test currently in misc_deregister is broken, since it does not
test for the 0 minor.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/char/misc.c~drivers-char-miscc-clear-allocation-bit-in-minor-bitmap-when-device-register-fails drivers/char/misc.c
--- a/drivers/char/misc.c~drivers-char-miscc-clear-allocation-bit-in-minor-bitmap-when-device-register-fails
+++ a/drivers/char/misc.c
@@ -214,6 +214,9 @@ int misc_register(struct miscdevice * mi
 	misc->this_device = device_create(misc_class, misc->parent, dev,
 					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
+		int i = misc->minor;
+		if (i < DYNAMIC_MINORS && i >= 0)
+			misc_minors[i>>3] &= ~(1 << (i & 7));
 		err = PTR_ERR(misc->this_device);
 		goto out;
 	}
@@ -248,9 +251,8 @@ int misc_deregister(struct miscdevice *m
 	mutex_lock(&misc_mtx);
 	list_del(&misc->list);
 	device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
-	if (i < DYNAMIC_MINORS && i>0) {
-		misc_minors[i>>3] &= ~(1 << (misc->minor & 7));
-	}
+	if (i < DYNAMIC_MINORS && i >= 0)
+		misc_minors[i>>3] &= ~(1 << (i & 7));
 	mutex_unlock(&misc_mtx);
 	return 0;
 }
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

origin.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-char-miscc-use-a-proper-range-for-minor-number-dynamic-allocation.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch

