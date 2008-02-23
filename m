From: akpm@linux-foundation.org
Subject: - usb-microtek-remove-unused-semaphore.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:55 -0800
Message-ID: <200802232022.m1NKMt1a013467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761715AbYBWU2q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb microtek: remove unused semaphore
has been removed from the -mm tree.  Its filename was
     usb-microtek-remove-unused-semaphore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
