From: akpm@linux-foundation.org
Subject: + drivers-media-use-memdup_user.patch added to -mm tree
Date: Tue, 25 May 2010 15:36:43 -0700
Message-ID: <201005252236.o4PMah0m019069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758860Ab0EYWhV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 18:37:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, mchehab@infradead.org


The patch titled
     drivers/media: use memdup_user
has been added to the -mm tree.  Its filename is
     drivers-media-use-memdup_user.patch

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
Subject: drivers/media: use memdup_user
From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the
allocated region.

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
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-core/dvb_demux.c |   10 +++-------
 drivers/media/video/dabusb.c           |   13 ++++---------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff -puN drivers/media/dvb/dvb-core/dvb_demux.c~drivers-media-use-memdup_user drivers/media/dvb/dvb-core/dvb_demux.c
--- a/drivers/media/dvb/dvb-core/dvb_demux.c~drivers-media-use-memdup_user
+++ a/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -1130,13 +1130,9 @@ static int dvbdmx_write(struct dmx_demux
 	if ((!demux->frontend) || (demux->frontend->source != DMX_MEMORY_FE))
 		return -EINVAL;
 
-	p = kmalloc(count, GFP_USER);
-	if (!p)
-		return -ENOMEM;
-	if (copy_from_user(p, buf, count)) {
-		kfree(p);
-		return -EFAULT;
-	}
+	p = memdup_user(buf, count);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
 	if (mutex_lock_interruptible(&dvbdemux->mutex)) {
 		kfree(p);
 		return -ERESTARTSYS;
diff -puN drivers/media/video/dabusb.c~drivers-media-use-memdup_user drivers/media/video/dabusb.c
--- a/drivers/media/video/dabusb.c~drivers-media-use-memdup_user
+++ a/drivers/media/video/dabusb.c
@@ -706,16 +706,11 @@ static long dabusb_ioctl (struct file *f
 	switch (cmd) {
 
 	case IOCTL_DAB_BULK:
-		pbulk = kmalloc(sizeof (bulk_transfer_t), GFP_KERNEL);
+		pbulk = memdup_user((void __user *)arg,
+				    sizeof(bulk_transfer_t));
 
-		if (!pbulk) {
-			ret = -ENOMEM;
-			break;
-		}
-
-		if (copy_from_user (pbulk, (void __user *) arg, sizeof (bulk_transfer_t))) {
-			ret = -EFAULT;
-			kfree (pbulk);
+		if (IS_ERR(pbulk)) {
+			ret = PTR_ERR(pbulk);
 			break;
 		}
 
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

