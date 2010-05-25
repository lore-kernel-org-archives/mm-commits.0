From: akpm@linux-foundation.org
Subject: + drivers-telephony-ixjc-use-memdup_user.patch added to -mm tree
Date: Tue, 25 May 2010 15:37:03 -0700
Message-ID: <201005252237.o4PMb3L8019103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758608Ab0EYWhH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 18:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/telephony/ixj.c: use memdup_user
has been added to the -mm tree.  Its filename is
     drivers-telephony-ixjc-use-memdup_user.patch

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
Subject: drivers/telephony/ixj.c: use memdup_user
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

 drivers/telephony/ixj.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/telephony/ixj.c~drivers-telephony-ixjc-use-memdup_user drivers/telephony/ixj.c
--- a/drivers/telephony/ixj.c~drivers-telephony-ixjc-use-memdup_user
+++ a/drivers/telephony/ixj.c
@@ -5879,20 +5879,13 @@ out:
 static int ixj_build_filter_cadence(IXJ *j, IXJ_FILTER_CADENCE __user * cp)
 {
 	IXJ_FILTER_CADENCE *lcp;
-	lcp = kmalloc(sizeof(IXJ_FILTER_CADENCE), GFP_KERNEL);
-	if (lcp == NULL) {
+	lcp = memdup_user(cp, sizeof(IXJ_FILTER_CADENCE));
+	if (IS_ERR(lcp)) {
 		if(ixjdebug & 0x0001) {
-			printk(KERN_INFO "Could not allocate memory for cadence\n");
+			printk(KERN_INFO "Could not allocate memory for cadence or could not copy cadence to kernel\n");
 		}
-		return -ENOMEM;
+		return PTR_ERR(lcp);
         }
-	if (copy_from_user(lcp, cp, sizeof(IXJ_FILTER_CADENCE))) {
-		if(ixjdebug & 0x0001) {
-			printk(KERN_INFO "Could not copy cadence to kernel\n");
-		}
-		kfree(lcp);
-		return -EFAULT;
-	}
 	if (lcp->filter > 5) {
 		if(ixjdebug & 0x0001) {
 			printk(KERN_INFO "Cadence out of range\n");
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

