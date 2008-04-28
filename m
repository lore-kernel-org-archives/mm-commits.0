From: akpm@linux-foundation.org
Subject: - isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:49 -0700
Message-ID: <200804282156.m3SLunTK018270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935966AbYD1V4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: fix obvious cut-and-paste error in st5481_usb.c
has been removed from the -mm tree.  Its filename was
     isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-mtd.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
maintainers-clarify-status-of-mn10300-mailing-list-as-moderated.patch
ipmi-make-comment-match-actual-preprocessor-check.patch
keys-explicitly-include-required-slabh-header-file.patch
nbd-delete-superfluous-test-for-__gnuc__.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

