From: akpm@linux-foundation.org
Subject: - frv-fix-mmap2-error-handling.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:50 -0800
Message-ID: <200812021838.mB2IcoUk007151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbYLBSkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:40:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     frv: fix mmap2 error handling
has been removed from the -mm tree.  Its filename was
     frv-fix-mmap2-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: fix mmap2 error handling
From: David Howells <dhowells@redhat.com>

Fix the error handling in sys_mmap2().  Currently, if the pgoff check
fails, fput() might have to be called (which it isn't), so do the pgoff
check first, before fget() is called.

Signed-off-by: David Howells <dhowells@redhat.com>
Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/sys_frv.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN arch/frv/kernel/sys_frv.c~frv-fix-mmap2-error-handling arch/frv/kernel/sys_frv.c
--- a/arch/frv/kernel/sys_frv.c~frv-fix-mmap2-error-handling
+++ a/arch/frv/kernel/sys_frv.c
@@ -35,22 +35,21 @@ asmlinkage long sys_mmap2(unsigned long 
 	int error = -EBADF;
 	struct file * file = NULL;
 
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-	if (!(flags & MAP_ANONYMOUS)) {
-		file = fget(fd);
-		if (!file)
-			goto out;
-	}
-
 	/* As with sparc32, make sure the shift for mmap2 is constant
 	   (12), no matter what PAGE_SIZE we have.... */
 
 	/* But unlike sparc32, don't just silently break if we're
 	   trying to map something we can't */
-	if (pgoff & ((1<<(PAGE_SHIFT-12))-1))
+	if (pgoff & ((1 << (PAGE_SHIFT - 12)) - 1))
 		return -EINVAL;
+	pgoff >>= PAGE_SHIFT - 12;
 
-	pgoff >>= (PAGE_SHIFT - 12);
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+	if (!(flags & MAP_ANONYMOUS)) {
+		file = fget(fd);
+		if (!file)
+			goto out;
+	}
 
 	down_write(&current->mm->mmap_sem);
 	error = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
frv-use-the-new-byteorder-headers.patch
mutex-subsystem-synchro-test-module.patch

