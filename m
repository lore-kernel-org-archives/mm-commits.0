From: akpm@linux-foundation.org
Subject: - aoe-eliminate-goto-and-improve-readability.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:15:57 -0800
Message-ID: <200802082015.m18KFcKA010635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48009 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753297AbYBHUum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:50:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     aoe: eliminate goto and improve readability
has been removed from the -mm tree.  Its filename was
     aoe-eliminate-goto-and-improve-readability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
