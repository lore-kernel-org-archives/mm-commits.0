From: akpm@linux-foundation.org
Subject: + errnoh-improve-enosyss-comment.patch added to -mm tree
Date: Fri, 10 Apr 2015 15:59:14 -0700
Message-ID: <552855c2.eaW0jevnnJxPsCsp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbbDJW7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Apr 2015 18:59:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@amacapital.net, joe@perches.com, mtk.manpages@gmail.com, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: errno.h: Improve ENOSYS's comment
has been added to the -mm tree.  Its filename is
     errnoh-improve-enosyss-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/errnoh-improve-enosyss-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/errnoh-improve-enosyss-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Lutomirski <luto@amacapital.net>
Subject: errno.h: Improve ENOSYS's comment

ENOSYS is the mechanism used by user code to detect whether the running
kernel implements a given system call.  It should not be returned by
anything except an unimplemented system call.

Unfortunately, it is rather frequently used in the kernel to indicate that
various new functions of existing system calls are not implemented.  This
should be discouraged.

Improve the comment in errno.h to help clarify ENOSYS's purpose.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/asm-generic/errno.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN include/uapi/asm-generic/errno.h~errnoh-improve-enosyss-comment include/uapi/asm-generic/errno.h
--- a/include/uapi/asm-generic/errno.h~errnoh-improve-enosyss-comment
+++ a/include/uapi/asm-generic/errno.h
@@ -6,7 +6,16 @@
 #define	EDEADLK		35	/* Resource deadlock would occur */
 #define	ENAMETOOLONG	36	/* File name too long */
 #define	ENOLCK		37	/* No record locks available */
-#define	ENOSYS		38	/* Function not implemented */
+
+/*
+ * This error code is special: arch syscall entry code will return
+ * -ENOSYS if users try to call a syscall that doesn't exist.  To keep
+ * failures of syscalls that really do exist distinguishable from
+ * failures due to attempts to use a nonexistent syscall, syscall
+ * implementations should refrain from returning -ENOSYS.
+ */
+#define	ENOSYS		38	/* Invalid system call number */
+
 #define	ENOTEMPTY	39	/* Directory not empty */
 #define	ELOOP		40	/* Too many symbolic links encountered */
 #define	EWOULDBLOCK	EAGAIN	/* Operation would block */
_

Patches currently in -mm which might be from luto@amacapital.net are

arm-factor-out-mmap-aslr-into-mmap_rnd.patch
x86-standardize-mmap_rnd-usage.patch
mm-expose-arch_mmap_rnd-when-available.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
linux-next.patch

