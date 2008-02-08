From: akpm@linux-foundation.org
Subject: - aoe-make-error-messages-more-specific.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:11 -0800
Message-ID: <200802082015.m18KFqMW010653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbYBHUtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:49:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     aoe: make error messages more specific
has been removed from the -mm tree.  Its filename was
     aoe-make-error-messages-more-specific.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
