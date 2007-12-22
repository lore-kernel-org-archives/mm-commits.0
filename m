From: akpm@linux-foundation.org
Subject: + aoe-make-error-messages-more-specific.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:04:00 -0800
Message-ID: <200712220604.lBM640JF020135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55509 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbXLVGED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:04:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, greg@kroah.com


The patch titled
     aoe: make error messages more specific
has been added to the -mm tree.  Its filename is
     aoe-make-error-messages-more-specific.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: make error messages more specific
From: "Ed L. Cashin" <ecashin@coraid.com>

Andrew Morton pointed out that the "too many targets" message in patch 2 could
be printed for failing GFP_ATOMIC allocations.  This patch makes the messages
more specific.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-make-error-messages-more-specific drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-make-error-messages-more-specific
+++ a/drivers/block/aoe/aoecmd.c
@@ -957,15 +957,17 @@ addtgt(struct aoedev *d, char *addr, ulo
 	for (; tt < te && *tt; tt++)
 		;
 
-	if (tt == te)
+	if (tt == te) {
+		printk(KERN_INFO
+			"aoe: device addtgt failure; too many targets\n");
 		return NULL;
-
+	}
 	t = kcalloc(1, sizeof *t, GFP_ATOMIC);
-	if (!t)
-		return NULL;
 	f = kcalloc(nframes, sizeof *f, GFP_ATOMIC);
-	if (!f) {
+	if (!t || !f) {
+		kfree(f);
 		kfree(t);
+		printk(KERN_INFO "aoe: cannot allocate memory to add target\n");
 		return NULL;
 	}
 
@@ -1029,9 +1031,6 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	if (!t) {
 		t = addtgt(d, h->src, n);
 		if (!t) {
-			printk(KERN_INFO
-				"aoe: device addtgt failure; "
-				"too many targets?\n");
 			spin_unlock_irqrestore(&d->lock, flags);
 			return;
 		}
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
