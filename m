From: akpm@linux-foundation.org
Subject: + drivers-char-vtc-use-memdup_user.patch added to -mm tree
Date: Tue, 25 May 2010 15:36:59 -0700
Message-ID: <201005252236.o4PMaxwV019094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758731Ab0EYWhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 18:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/char/vt.c: use memdup_user
has been added to the -mm tree.  Its filename is
     drivers-char-vtc-use-memdup_user.patch

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
Subject: drivers/char/vt.c: use memdup_user
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/char/vt.c~drivers-char-vtc-use-memdup_user drivers/char/vt.c
--- a/drivers/char/vt.c~drivers-char-vtc-use-memdup_user
+++ a/drivers/char/vt.c
@@ -3967,13 +3967,9 @@ static int con_font_set(struct vc_data *
 	font.charcount = op->charcount;
 	font.height = op->height;
 	font.width = op->width;
-	font.data = kmalloc(size, GFP_KERNEL);
-	if (!font.data)
-		return -ENOMEM;
-	if (copy_from_user(font.data, op->data, size)) {
-		kfree(font.data);
-		return -EFAULT;
-	}
+	font.data = memdup_user(op->data, size);
+	if (IS_ERR(font.data))
+		return PTR_ERR(font.data);
 	acquire_console_sem();
 	if (vc->vc_sw->con_font_set)
 		rc = vc->vc_sw->con_font_set(vc, &font, op->flags);
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

