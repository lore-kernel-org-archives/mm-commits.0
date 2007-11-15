From: akpm@linux-foundation.org
Subject: - uml-fix-recvmsg-return-value-checking.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:38 -0800
Message-ID: <200711152108.lAFL8cag015375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933174AbXKOVIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:08:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix recvmsg return value checking
has been removed from the -mm tree.  Its filename was
     uml-fix-recvmsg-return-value-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix recvmsg return value checking
From: Jeff Dike <jdike@addtoit.com>

Stupid bug - we need to compare the return value of recvmsg to the value of
iov_len, not its size.  This caused port_helper processes not to be killed on
shutdown on x86_64 because the pids weren't being passed out properly.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/file.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/um/os-Linux/file.c~uml-fix-recvmsg-return-value-checking arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-fix-recvmsg-return-value-checking
+++ a/arch/um/os-Linux/file.c
@@ -496,8 +496,7 @@ int os_rcv_fd(int fd, int *helper_pid_ou
 	n = recvmsg(fd, &msg, 0);
 	if(n < 0)
 		return -errno;
-
-	else if(n != sizeof(iov.iov_len))
+	else if(n != iov.iov_len)
 		*helper_pid_out = -1;
 
 	cmsg = CMSG_FIRSTHDR(&msg);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
