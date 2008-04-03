From: akpm@linux-foundation.org
Subject: + nbd-delete-superfluous-test-for-__gnuc__.patch added to -mm tree
Date: Thu, 03 Apr 2008 12:36:10 -0700
Message-ID: <200804031936.m33JaAKc018839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762232AbYDCTgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 15:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, paul.clements@steeleye.com


The patch titled
     nbd: delete superfluous test for __GNUC__
has been added to the -mm tree.  Its filename is
     nbd-delete-superfluous-test-for-__gnuc__.patch

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
Subject: nbd: delete superfluous test for __GNUC__
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since <linux/compiler.h> already tests for __GNUC__, there's no point in nbd.h
repeating that test.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nbd.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/nbd.h~nbd-delete-superfluous-test-for-__gnuc__ include/linux/nbd.h
--- a/include/linux/nbd.h~nbd-delete-superfluous-test-for-__gnuc__
+++ a/include/linux/nbd.h
@@ -86,11 +86,7 @@ struct nbd_request {
 	char handle[8];
 	__be64 from;
 	__be32 len;
-}
-#ifdef __GNUC__
-	__attribute__ ((packed))
-#endif
-;
+} __attribute__ ((packed));
 
 /*
  * This is the reply packet that nbd-server sends back to the client after
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
efs-update-error-msg-to-not-refer-to-deleted-read_inode.patch
git-powerpc.patch
git-ieee1394.patch
git-infiniband.patch
mmc-use-shorter-equivalent-set_current_state.patch
git-net.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
mfd-use-shorter-set_current_state.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
nbd-delete-superfluous-test-for-__gnuc__.patch

