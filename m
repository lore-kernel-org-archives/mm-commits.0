From: akpm@linux-foundation.org
Subject: + drivers-isdn-use-memdup_user.patch added to -mm tree
Date: Tue, 25 May 2010 15:37:23 -0700
Message-ID: <201005252237.o4PMbNpN019134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759043Ab0EYWhd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 18:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, isdn@linux-pingi.de


The patch titled
     drivers/isdn: use memdup_user
has been added to the -mm tree.  Its filename is
     drivers-isdn-use-memdup_user.patch

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
Subject: drivers/isdn: use memdup_user
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
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_ppp.c |   11 +++--------
 drivers/isdn/pcbit/drv.c    |   10 +++-------
 drivers/isdn/sc/ioctl.c     |   23 ++++++-----------------
 3 files changed, 12 insertions(+), 32 deletions(-)

diff -puN drivers/isdn/i4l/isdn_ppp.c~drivers-isdn-use-memdup_user drivers/isdn/i4l/isdn_ppp.c
--- a/drivers/isdn/i4l/isdn_ppp.c~drivers-isdn-use-memdup_user
+++ a/drivers/isdn/i4l/isdn_ppp.c
@@ -449,14 +449,9 @@ static int get_filter(void __user *arg, 
 
 	/* uprog.len is unsigned short, so no overflow here */
 	len = uprog.len * sizeof(struct sock_filter);
-	code = kmalloc(len, GFP_KERNEL);
-	if (code == NULL)
-		return -ENOMEM;
-
-	if (copy_from_user(code, uprog.filter, len)) {
-		kfree(code);
-		return -EFAULT;
-	}
+	code = memdup_user(uprog.filter, len);
+	if (IS_ERR(code))
+		return PTR_ERR(code);
 
 	err = sk_chk_filter(code, uprog.len);
 	if (err) {
diff -puN drivers/isdn/pcbit/drv.c~drivers-isdn-use-memdup_user drivers/isdn/pcbit/drv.c
--- a/drivers/isdn/pcbit/drv.c~drivers-isdn-use-memdup_user
+++ a/drivers/isdn/pcbit/drv.c
@@ -411,14 +411,10 @@ static int pcbit_writecmd(const u_char _
 			return -EINVAL;
 		}
 
-		cbuf = kmalloc(len, GFP_KERNEL);
-		if (!cbuf)
-			return -ENOMEM;
+		cbuf = memdup_user(buf, len);
+		if (IS_ERR(cbuf))
+			return PTR_ERR(cbuf);
 
-		if (copy_from_user(cbuf, buf, len)) {
-			kfree(cbuf);
-			return -EFAULT;
-		}
 		memcpy_toio(dev->sh_mem, cbuf, len);
 		kfree(cbuf);
 		return len;
diff -puN drivers/isdn/sc/ioctl.c~drivers-isdn-use-memdup_user drivers/isdn/sc/ioctl.c
--- a/drivers/isdn/sc/ioctl.c~drivers-isdn-use-memdup_user
+++ a/drivers/isdn/sc/ioctl.c
@@ -215,19 +215,13 @@ int sc_ioctl(int card, scs_ioctl *data)
 		pr_debug("%s: DCBIOSETSPID: ioctl received\n",
 				sc_adapter[card]->devicename);
 
-		spid = kmalloc(SCIOC_SPIDSIZE, GFP_KERNEL);
-		if(!spid) {
-			kfree(rcvmsg);
-			return -ENOMEM;
-		}
-
 		/*
 		 * Get the spid from user space
 		 */
-		if (copy_from_user(spid, data->dataptr, SCIOC_SPIDSIZE)) {
+		spid = memdup_user(data->dataptr, SCIOC_SPIDSIZE);
+		if (IS_ERR(spid)) {
 			kfree(rcvmsg);
-			kfree(spid);
-			return -EFAULT;
+			return PTR_ERR(spid);
 		}
 
 		pr_debug("%s: SCIOCSETSPID: setting channel %d spid to %s\n", 
@@ -296,18 +290,13 @@ int sc_ioctl(int card, scs_ioctl *data)
 		pr_debug("%s: SCIOSETDN: ioctl received\n",
 				sc_adapter[card]->devicename);
 
-		dn = kmalloc(SCIOC_DNSIZE, GFP_KERNEL);
-		if (!dn) {
-			kfree(rcvmsg);
-			return -ENOMEM;
-		}
 		/*
 		 * Get the spid from user space
 		 */
-		if (copy_from_user(dn, data->dataptr, SCIOC_DNSIZE)) {
+		dn = memdup_user(data->dataptr, SCIOC_DNSIZE);
+		if (IS_ERR(dn)) {
 			kfree(rcvmsg);
-			kfree(dn);
-			return -EFAULT;
+			return PTR_ERR(dn);
 		}
 
 		pr_debug("%s: SCIOCSETDN: setting channel %d dn to %s\n", 
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

