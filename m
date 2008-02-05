From: akpm@linux-foundation.org
Subject: - uml-add-newlines-to-printks.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:27 -0800
Message-ID: <200802052238.m15Mc8t5012926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760839AbYBEWl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: add newlines to printks
has been removed from the -mm tree.  Its filename was
     uml-add-newlines-to-printks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: add newlines to printks
From: Jeff Dike <jdike@addtoit.com>

Some printks were missing newlines.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/skas/process.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/um/os-Linux/skas/process.c~uml-add-newlines-to-printks arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-add-newlines-to-printks
+++ a/arch/um/os-Linux/skas/process.c
@@ -273,7 +273,7 @@ int start_userspace(unsigned long stub_s
 	if (stack == MAP_FAILED) {
 		err = -errno;
 		printk(UM_KERN_ERR "start_userspace : mmap failed, "
-		       "errno = %d", errno);
+		       "errno = %d\n", errno);
 		return err;
 	}
 
@@ -289,7 +289,7 @@ int start_userspace(unsigned long stub_s
 	if (pid < 0) {
 		err = -errno;
 		printk(UM_KERN_ERR "start_userspace : clone failed, "
-		       "errno = %d", errno);
+		       "errno = %d\n", errno);
 		return err;
 	}
 
@@ -298,7 +298,7 @@ int start_userspace(unsigned long stub_s
 		if (n < 0) {
 			err = -errno;
 			printk(UM_KERN_ERR "start_userspace : wait failed, "
-			       "errno = %d", errno);
+			       "errno = %d\n", errno);
 			goto out_kill;
 		}
 	} while (WIFSTOPPED(status) && (WSTOPSIG(status) == SIGVTALRM));
@@ -306,7 +306,7 @@ int start_userspace(unsigned long stub_s
 	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGSTOP)) {
 		err = -EINVAL;
 		printk(UM_KERN_ERR "start_userspace : expected SIGSTOP, got "
-		       "status = %d", status);
+		       "status = %d\n", status);
 		goto out_kill;
 	}
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
