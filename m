From: akpm@linux-foundation.org
Subject: [merged] errnoh-improve-enosyss-comment.patch removed from -mm
 tree
Date: Mon, 20 Apr 2015 12:17:19 -0700
Message-ID: <553550bf.rvR5XVqyJuqMoKqk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbDTTK6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@amacapital.net, joe@perches.com, mtk.manpages@gmail.com, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: errno.h: Improve ENOSYS's comment
has been removed from the -mm tree.  Its filename was
     errnoh-improve-enosyss-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

