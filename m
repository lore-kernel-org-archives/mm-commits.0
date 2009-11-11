From: akpm@linux-foundation.org
Subject: + drivers-char-miscc-clear-allocation-bit-in-minor-bitmap-when-device-register-fails.patch added to -mm tree
Date: Wed, 11 Nov 2009 15:33:58 -0800
Message-ID: <200911112333.nABNXxeW008903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759613AbZKKXeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Nov 2009 18:34:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com


The patch titled
     drivers/char/misc.c: clear allocation bit in minor bitmap when device register fails
has been added to the -mm tree.  Its filename is
     drivers-char-miscc-clear-allocation-bit-in-minor-bitmap-when-device-register-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -217,6 +217,9 @@ int misc_register(struct miscdevice * mi
 	misc->this_device = device_create(misc_class, misc->parent, dev,
 					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
+		int i = misc->minor;
+		if (i < DYNAMIC_MINORS && i >= 0)
+			misc_minors[i>>3] &= ~(1 << (i & 7));
 		err = PTR_ERR(misc->this_device);
 		goto out;
 	}
@@ -251,9 +254,8 @@ int misc_deregister(struct miscdevice *m
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

linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch
misc-remove-mac-pmu-function-declaration-from-misc-device-class.patch
drivers-char-miscc-clear-allocation-bit-in-minor-bitmap-when-device-register-fails.patch
drivers-char-miscc-use-bitmap-bitops-functions-for-dynamic-minor-number-allocation.patch
drivers-char-miscc-use-a-proper-range-for-minor-number-dynamic-allocation.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch

