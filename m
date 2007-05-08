From: akpm@linux-foundation.org
Subject: + usb_gigaset-dont-kmalloc0.patch added to -mm tree
Date: Tue, 08 May 2007 14:26:08 -0700
Message-ID: <200705082126.l48LQ85v002126@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031961AbXEHV0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, greg@kroah.com, hjlipp@web.de


The patch titled
     usb_gigaset: don't kmalloc(0)
has been added to the -mm tree.  Its filename is
     usb_gigaset-dont-kmalloc0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb_gigaset: don't kmalloc(0)
From: Tilman Schmidt <tilman@imap.cc>

Zero-sized allocations are pointless anyway, and the SLUB allocator
complains about them, so stop doing that.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Hansjoerg Lipp <hjlipp@web.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/usb-gigaset.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/isdn/gigaset/usb-gigaset.c~usb_gigaset-dont-kmalloc0 drivers/isdn/gigaset/usb-gigaset.c
--- a/drivers/isdn/gigaset/usb-gigaset.c~usb_gigaset-dont-kmalloc0
+++ a/drivers/isdn/gigaset/usb-gigaset.c
@@ -138,8 +138,6 @@ struct usb_cardstate {
 	char			bchars[6];		/* for request 0x19 */
 };
 
-struct usb_bc_state {};
-
 static inline unsigned tiocm_to_gigaset(unsigned state)
 {
 	return ((state & TIOCM_DTR) ? 1 : 0) | ((state & TIOCM_RTS) ? 2 : 0);
@@ -579,25 +577,21 @@ static int gigaset_brkchars(struct cards
 
 static int gigaset_freebcshw(struct bc_state *bcs)
 {
-	if (!bcs->hw.usb)
-		return 0;
-	//FIXME
-	kfree(bcs->hw.usb);
+	/* unused */
 	return 1;
 }
 
 /* Initialize the b-channel structure */
 static int gigaset_initbcshw(struct bc_state *bcs)
 {
-	bcs->hw.usb = kmalloc(sizeof(struct usb_bc_state), GFP_KERNEL);
-	if (!bcs->hw.usb)
-		return 0;
-
+	/* unused */
+	bcs->hw.usb = NULL;
 	return 1;
 }
 
 static void gigaset_reinitbcshw(struct bc_state *bcs)
 {
+	/* nothing to do for M10x */
 }
 
 static void gigaset_freecshw(struct cardstate *cs)
_

Patches currently in -mm which might be from tilman@imap.cc are

origin.patch
codingstyle-start-flamewar-about-use-of-braces.patch
usb_gigaset-dont-kmalloc0.patch
remove-obsolete-label-from-isdn4linux-v3.patch
