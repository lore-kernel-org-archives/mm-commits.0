From: akpm@linux-foundation.org
Subject: + fallocate-syscall-interface-deficiency.patch added to -mm tree
Date: Mon, 23 Jul 2007 13:01:38 -0700
Message-ID: <200707232001.l6NK1e19009048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46997 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759459AbXGWUCB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 16:02:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, aarora@in.ibm.com


The patch titled
     fallocate syscall interface deficiency
has been added to the -mm tree.  Its filename is
     fallocate-syscall-interface-deficiency.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fallocate syscall interface deficiency
From: Ulrich Drepper <drepper@redhat.com>

The fallocate syscall returns ENOSYS in case the filesystem does not support
the operation and expects the userlevel code to fill in.  This is good in
concept.

The problem is that the libc code for old kernels should be able to
distinguish the case where the syscall is not at all available vs not
functioning for a specific mount point.  As is this is not possible and we
always have to invoke the syscall even if the kernel doesn't support it.

I suggest the following patch.  Using EOPNOTSUPP is IMO the right thing to do.

Cc: Amit Arora <aarora@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/open.c~fallocate-syscall-interface-deficiency fs/open.c
--- a/fs/open.c~fallocate-syscall-interface-deficiency
+++ a/fs/open.c
@@ -403,7 +403,7 @@ asmlinkage long sys_fallocate(int fd, in
 	if (inode->i_op && inode->i_op->fallocate)
 		ret = inode->i_op->fallocate(inode, mode, offset, len);
 	else
-		ret = -ENOSYS;
+		ret = -EOPNOTSUPP;
 
 out_fput:
 	fput(file);
_

Patches currently in -mm which might be from drepper@redhat.com are

fallocate-syscall-interface-deficiency.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
