From: akpm@linux-foundation.org
Subject: - hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch removed from -mm tree
Date: Mon, 30 Jul 2007 11:51:22 -0700
Message-ID: <200707301851.l6UIpMnp024899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763307AbXG3Svh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 14:51:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, dtor@mail.ru, greg@kroah.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hid: fix a NULL pointer dereference when we fail to allocate memory
has been removed from the -mm tree.  Its filename was
     hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
various-doc-kernel-parameters-fixes.patch
git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hid.patch
clean-up-duplicate-includes-in-drivers-input.patch
git-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-drivers-usb.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
cciss-fix-memory-leak.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
