From: akpm@linux-foundation.org
Subject: + aoe-eliminate-goto-and-improve-readability.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:03:47 -0800
Message-ID: <200712220603.lBM63la8020116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753960AbXLVGDu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:03:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, greg@kroah.com


The patch titled
     aoe: eliminate goto and improve readability
has been added to the -mm tree.  Its filename is
     aoe-eliminate-goto-and-improve-readability.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: eliminate goto and improve readability
From: "Ed L. Cashin" <ecashin@coraid.com>

Adam Richter suggested eliminating this goto.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoechr.c |   71 +++++++++++++++++------------------
 1 file changed, 35 insertions(+), 36 deletions(-)

diff -puN drivers/block/aoe/aoechr.c~aoe-eliminate-goto-and-improve-readability drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-eliminate-goto-and-improve-readability
+++ a/drivers/block/aoe/aoechr.c
@@ -194,52 +194,51 @@ aoechr_read(struct file *filp, char __us
 	ulong flags;
 
 	n = (unsigned long) filp->private_data;
-	switch (n) {
-	case MINOR_ERR:
-		spin_lock_irqsave(&emsgs_lock, flags);
-loop:
-		em = emsgs + emsgs_head_idx;
-		if ((em->flags & EMFL_VALID) == 0) {
-			if (filp->f_flags & O_NDELAY) {
-				spin_unlock_irqrestore(&emsgs_lock, flags);
-				return -EAGAIN;
-			}
-			nblocked_emsgs_readers++;
+	if (n != MINOR_ERR)
+		return -EFAULT;
 
+	spin_lock_irqsave(&emsgs_lock, flags);
+
+	for (;;) {
+		em = emsgs + emsgs_head_idx;
+		if ((em->flags & EMFL_VALID) != 0)
+			break;
+		if (filp->f_flags & O_NDELAY) {
 			spin_unlock_irqrestore(&emsgs_lock, flags);
+			return -EAGAIN;
+		}
+		nblocked_emsgs_readers++;
 
-			n = down_interruptible(&emsgs_sema);
+		spin_unlock_irqrestore(&emsgs_lock, flags);
 
-			spin_lock_irqsave(&emsgs_lock, flags);
+		n = down_interruptible(&emsgs_sema);
 
-			nblocked_emsgs_readers--;
+		spin_lock_irqsave(&emsgs_lock, flags);
 
-			if (n) {
-				spin_unlock_irqrestore(&emsgs_lock, flags);
-				return -ERESTARTSYS;
-			}
-			goto loop;
-		}
-		if (em->len > cnt) {
+		nblocked_emsgs_readers--;
+
+		if (n) {
 			spin_unlock_irqrestore(&emsgs_lock, flags);
-			return -EAGAIN;
+			return -ERESTARTSYS;
 		}
-		mp = em->msg;
-		len = em->len;
-		em->msg = NULL;
-		em->flags &= ~EMFL_VALID;
-
-		emsgs_head_idx++;
-		emsgs_head_idx %= ARRAY_SIZE(emsgs);
-
+	}
+	if (em->len > cnt) {
 		spin_unlock_irqrestore(&emsgs_lock, flags);
-
-		n = copy_to_user(buf, mp, len);
-		kfree(mp);
-		return n == 0 ? len : -EFAULT;
-	default:
-		return -EFAULT;
+		return -EAGAIN;
 	}
+	mp = em->msg;
+	len = em->len;
+	em->msg = NULL;
+	em->flags &= ~EMFL_VALID;
+
+	emsgs_head_idx++;
+	emsgs_head_idx %= ARRAY_SIZE(emsgs);
+
+	spin_unlock_irqrestore(&emsgs_lock, flags);
+
+	n = copy_to_user(buf, mp, len);
+	kfree(mp);
+	return n == 0 ? len : -EFAULT;
 }
 
 static const struct file_operations aoe_fops = {
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-bring-driver-version-number-to-47.patch
aoe-handle-multiple-network-paths-to-aoe-device.patch
aoe-mac_addr-avoid-64-bit-arch-compiler-warnings.patch
aoe-clean-up-udev-configuration-example.patch
aoe-eliminate-goto-and-improve-readability.patch
aoe-user-can-ask-driver-to-forget-previously-detected-devices.patch
aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary.patch
aoe-only-install-new-aoe-device-once.patch
aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o.patch
aoe-the-aoeminor-doesnt-need-a-long-format.patch
aoe-make-error-messages-more-specific.patch
aoe-update-copyright-date.patch
aoe-statically-initialise-devlist_lock.patch
