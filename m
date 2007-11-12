From: akpm@linux-foundation.org
Subject: + uml-fix-recvmsg-return-value-checking.patch added to -mm tree
Date: Mon, 12 Nov 2007 11:56:12 -0800
Message-ID: <200711121956.lACJuERg006394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbXKLT40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 14:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: fix recvmsg return value checking
has been added to the -mm tree.  Its filename is
     uml-fix-recvmsg-return-value-checking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-fix-symlink-loops.patch
uml-fix-recvmsg-return-value-checking.patch
uml-update-address-space-affected-by-pud_clear.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
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
