From: akpm@linux-foundation.org
Subject: + sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch added to -mm tree
Date: Tue, 08 Apr 2008 00:57:25 -0700
Message-ID: <200804080757.m387vPVr015222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbYDHH5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 03:57:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, hch@lst.de


The patch titled
     sysv fs: remove superfluous check for __GNUC__ compiler
has been added to the -mm tree.  Its filename is
     sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch

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
Subject: sysv fs: remove superfluous check for __GNUC__ compiler
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since <linux/sysv_fs.h> isn't exported to userspace, there is little
point checking that this is a GNU-compatible compiler.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysv_fs.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/sysv_fs.h~sysv-fs-remove-superfluous-check-for-__gnuc__-compiler include/linux/sysv_fs.h
--- a/include/linux/sysv_fs.h~sysv-fs-remove-superfluous-check-for-__gnuc__-compiler
+++ a/include/linux/sysv_fs.h
@@ -1,11 +1,7 @@
 #ifndef _LINUX_SYSV_FS_H
 #define _LINUX_SYSV_FS_H
 
-#if defined(__GNUC__)
-# define __packed2__	__attribute__((packed, aligned(2)))
-#else
->> I want to scream! <<
-#endif
+#define __packed2__	__attribute__((packed, aligned(2)))
 
 
 #ifndef __KERNEL__
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-powerpc.patch
fix-gregkh-driver-kobject-replace-list_for_each-with-list_for_each_entry.patch
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
nbd-delete-superfluous-test-for-__gnuc__.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

