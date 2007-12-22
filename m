From: akpm@linux-foundation.org
Subject: + usb-microtek-remove-unused-semaphore.patch added to -mm tree
Date: Fri, 21 Dec 2007 20:14:56 -0800
Message-ID: <200712220414.lBM4EuFr016617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58831 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbXLVEPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 23:15:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, greg@kroah.com


The patch titled
     usb microtek: remove unused semaphore
has been added to the -mm tree.  Its filename is
     usb-microtek-remove-unused-semaphore.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb microtek: remove unused semaphore
From: Daniel Walker <dwalker@mvista.com>

No current references, so removing it.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/image/microtek.c |    1 -
 drivers/usb/image/microtek.h |    1 -
 2 files changed, 2 deletions(-)

diff -puN drivers/usb/image/microtek.c~usb-microtek-remove-unused-semaphore drivers/usb/image/microtek.c
--- a/drivers/usb/image/microtek.c~usb-microtek-remove-unused-semaphore
+++ a/drivers/usb/image/microtek.c
@@ -794,7 +794,6 @@ static int mts_usb_probe(struct usb_inte
 
 	new_desc->usb_dev = dev;
 	new_desc->usb_intf = intf;
-	init_MUTEX(&new_desc->lock);
 
 	/* endpoints */
 	new_desc->ep_out = ep_out;
diff -puN drivers/usb/image/microtek.h~usb-microtek-remove-unused-semaphore drivers/usb/image/microtek.h
--- a/drivers/usb/image/microtek.h~usb-microtek-remove-unused-semaphore
+++ a/drivers/usb/image/microtek.h
@@ -39,7 +39,6 @@ struct mts_desc {
 	u8 ep_image;
 
 	struct Scsi_Host * host;
-	struct semaphore lock;
 
 	struct urb *urb;
 	struct mts_transfer_context context;
_

Patches currently in -mm which might be from dwalker@mvista.com are

ps3-vuart-fix-error-path-locking.patch
driver-base-memory-semaphore-to-mutex.patch
git-dvb.patch
usb-microtek-remove-unused-semaphore.patch
git-x86.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
drivers-char-tty_ioc-remove-pty_sem.patch
drivers-isdn-i4l-isdn_ttyc-remove-write_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
docs-kernel-locking-convert-semaphore-references.patch
stopmachine-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex-fix.patch
amiga-serial-driver-port_write_mutex-fixup.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
prism54-remove-questionable-down_interruptible-usage.patch
docs-convert-kref-semaphore-to-mutex.patch
