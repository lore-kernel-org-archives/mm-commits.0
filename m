From: akpm@linux-foundation.org
Subject: + hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:50:29 -0700
Message-ID: <200707232150.l6NLoTg7013734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758738AbXGWVus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:50:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, dtor@mail.ru, greg@kroah.com, jkosina@suse.cz


The patch titled
     hid: fix a NULL pointer dereference when we fail to allocate memory
has been added to the -mm tree.  Its filename is
     hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hid: fix a NULL pointer dereference when we fail to allocate memory
From: Jesper Juhl <jesper.juhl@gmail.com>

If, in usb_hid_configure(), we fail to allocate storage for 'usbhid',
 "if (!(usbhid = kzalloc(sizeof(struct usbhid_device), GFP_KERNEL)))",
then we'll jump to the 'fail:' label where we have this code:
        usb_free_urb(usbhid->urbin);
        usb_free_urb(usbhid->urbout);
        usb_free_urb(usbhid->urbctrl);
Since we got here because we couldn't allocate storage for 'usbhid',
what we have here is a NULL pointer dereference - ouch...

This patch solves that little problem by adding a new
'fail_no_usbhid:' label after the problematic calls to
usb_free_urb() and jumps to that one instead, in the problem case.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/hid/usbhid/hid-core.c~hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory drivers/hid/usbhid/hid-core.c
--- a/drivers/hid/usbhid/hid-core.c~hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory
+++ a/drivers/hid/usbhid/hid-core.c
@@ -766,7 +766,7 @@ static struct hid_device *usb_hid_config
 	hid->quirks = quirks;
 
 	if (!(usbhid = kzalloc(sizeof(struct usbhid_device), GFP_KERNEL)))
-		goto fail;
+		goto fail_no_usbhid;
 
 	hid->driver_data = usbhid;
 	usbhid->hid = hid;
@@ -901,6 +901,7 @@ fail:
 	usb_free_urb(usbhid->urbin);
 	usb_free_urb(usbhid->urbout);
 	usb_free_urb(usbhid->urbctrl);
+fail_no_usbhid:
 	hid_free_buffers(dev, hid);
 	hid_free_device(hid);
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-gfs2-nmw.patch
hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch
git-kbuild.patch
git-mtd.patch
git-selinux.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
