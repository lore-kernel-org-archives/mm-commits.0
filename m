From: akpm@linux-foundation.org
Subject: + drivers-block-use-memdup_user.patch added to -mm tree
Date: Tue, 25 May 2010 15:36:41 -0700
Message-ID: <201005252236.o4PMafNA019064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757217Ab0EYWj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 18:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, chirag.kantharia@hp.com, jens.axboe@oracle.com


The patch titled
     drivers/block: use memdup_user
has been added to the -mm tree.  Its filename is
     drivers-block-use-memdup_user.patch

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
Subject: drivers/block: use memdup_user
From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the
allocated region.  Some checkpatch cleanups in nearby code.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
position p;
identifier l1,l2;
@@

-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+  to = memdup_user(from,size);
   if (
-      to==NULL
+      IS_ERR(to)
                 || ...) {
   <+... when != goto l1;
-  -ENOMEM
+  PTR_ERR(to)
   ...+>
   }
-  if (copy_from_user(to, from, size) != 0) {
-    <+... when != goto l2;
-    -EFAULT
-    ...+>
-  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Chirag Kantharia <chirag.kantharia@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cpqarray.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff -puN drivers/block/cpqarray.c~drivers-block-use-memdup_user drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~drivers-block-use-memdup_user
+++ a/drivers/block/cpqarray.c
@@ -1225,17 +1225,11 @@ static int ida_ctlr_ioctl(ctlr_info_t *h
 	/* Pre submit processing */
 	switch(io->cmd) {
 	case PASSTHRU_A:
-		p = kmalloc(io->sg[0].size, GFP_KERNEL);
-		if (!p) 
-		{ 
-			error = -ENOMEM; 
-			cmd_free(h, c, 0); 
-			return(error);
-		}
-		if (copy_from_user(p, io->sg[0].addr, io->sg[0].size)) {
-			kfree(p);
-			cmd_free(h, c, 0); 
-			return -EFAULT;
+		p = memdup_user(io->sg[0].addr, io->sg[0].size);
+		if (IS_ERR(p)) {
+			error = PTR_ERR(p);
+			cmd_free(h, c, 0);
+			return error;
 		}
 		c->req.hdr.blk = pci_map_single(h->pci_dev, &(io->c), 
 				sizeof(ida_ioctl_t), 
@@ -1266,18 +1260,12 @@ static int ida_ctlr_ioctl(ctlr_info_t *h
 	case DIAG_PASS_THRU:
 	case COLLECT_BUFFER:
 	case WRITE_FLASH_ROM:
-		p = kmalloc(io->sg[0].size, GFP_KERNEL);
-		if (!p) 
- 		{ 
-                        error = -ENOMEM; 
-                        cmd_free(h, c, 0);
-                        return(error);
+		p = memdup_user(io->sg[0].addr, io->sg[0].size);
+		if (IS_ERR(p)) {
+			error = PTR_ERR(p);
+			cmd_free(h, c, 0);
+			return error;
                 }
-		if (copy_from_user(p, io->sg[0].addr, io->sg[0].size)) {
-			kfree(p);
-                        cmd_free(h, c, 0);
-			return -EFAULT;
-		}
 		c->req.sg[0].size = io->sg[0].size;
 		c->req.sg[0].addr = pci_map_single(h->pci_dev, p, 
 			c->req.sg[0].size, PCI_DMA_BIDIRECTIONAL); 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-aacraid-eliminate-use-after-free.patch
arch-x86-pci-use-kasprintf.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-char-ppdevc-use-kasprintf.patch
net-can-use-memdup_user.patch
drivers-net-use-memdup_user.patch
fs-btrfs-use-memdup_user.patch
drivers-video-via-use-memdup_user.patch
mm-use-memdup_user.patch
drivers-net-cxgb3-use-memdup_user.patch
drivers-net-wan-use-memdup_user.patch
drivers-block-use-memdup_user.patch
drivers-media-use-memdup_user.patch
drivers-infiniband-core-use-memdup_user.patch
drivers-i2c-use-memdup_user.patch
drivers-ieee1394-use-memdup_user.patch
fs-autofs4-use-memdup_user.patch
drivers-scsi-use-memdup_user.patch
drivers-char-applicomc-use-memdup_user.patch
drivers-char-vtc-use-memdup_user.patch
drivers-message-i2o-i2o_configc-use-memdup_user.patch
drivers-telephony-ixjc-use-memdup_user.patch
drivers-s390-net-use-memdup_user.patch
drivers-ide-use-memdup_user.patch
net-dccp-use-memdup_user.patch
drivers-net-wireless-prism54-use-memdup_user.patch
drivers-usb-gadget-use-memdup_user.patch
drivers-isdn-use-memdup_user.patch
drivers-staging-dream-camera-use-memdup_user.patch

