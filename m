From: akpm@linux-foundation.org
Subject: + isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch added to -mm tree
Date: Tue, 18 Mar 2008 13:57:24 -0700
Message-ID: <200803182057.m2IKvOeX015895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757925AbYCSTmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:42:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, kkeil@suse.de


The patch titled
     isdn: fix obvious cut-and-paste error in st5481_usb.c
has been added to the -mm tree.  Its filename is
     isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: fix obvious cut-and-paste error in st5481_usb.c
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Fix a rather obvious cut-and-paste error, where earlier code for the
controller URB got somehow mixed in with code for the interrupt URB.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/st5481_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hisax/st5481_usb.c~isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc drivers/isdn/hisax/st5481_usb.c
--- a/drivers/isdn/hisax/st5481_usb.c~isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc
+++ a/drivers/isdn/hisax/st5481_usb.c
@@ -342,7 +342,7 @@ void st5481_release_usb(struct st5481_ad
 	usb_kill_urb(intr->urb);
 	kfree(intr->urb->transfer_buffer);
 	usb_free_urb(intr->urb);
-	ctrl->urb = NULL;
+	intr->urb = NULL;
 }
 
 /*
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch

