From: akpm@linux-foundation.org
Subject: - generalize-asm-generic-ioctlh-to-allow-overriding-values.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:01 -0700
Message-ID: <200804300548.m3U5m132029819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756816AbYD3GBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:01:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     generalize asm-generic/ioctl.h to allow overriding values
has been removed from the -mm tree.  Its filename was
     generalize-asm-generic-ioctlh-to-allow-overriding-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generalize asm-generic/ioctl.h to allow overriding values
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

In the spirit of a number of other asm-generic header files,
generalize asm-generic/ioctl.h to allow arch-specific ioctl.h headers
to simply override _IOC_SIZEBITS and/or _IOC_DIRBITS before including
this header file, allowing a number of ioctl.h header files to be
shortened considerably.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/ioctl.h |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/ioctl.h~generalize-asm-generic-ioctlh-to-allow-overriding-values include/asm-generic/ioctl.h
--- a/include/asm-generic/ioctl.h~generalize-asm-generic-ioctlh-to-allow-overriding-values
+++ a/include/asm-generic/ioctl.h
@@ -21,8 +21,19 @@
  */
 #define _IOC_NRBITS	8
 #define _IOC_TYPEBITS	8
-#define _IOC_SIZEBITS	14
-#define _IOC_DIRBITS	2
+
+/*
+ * Let any architecture override either of the following before
+ * including this file.
+ */
+
+#ifndef _IOC_SIZEBITS
+# define _IOC_SIZEBITS	14
+#endif
+
+#ifndef _IOC_DIRBITS
+# define _IOC_DIRBITS	2
+#endif
 
 #define _IOC_NRMASK	((1 << _IOC_NRBITS)-1)
 #define _IOC_TYPEMASK	((1 << _IOC_TYPEBITS)-1)
@@ -35,11 +46,21 @@
 #define _IOC_DIRSHIFT	(_IOC_SIZESHIFT+_IOC_SIZEBITS)
 
 /*
- * Direction bits.
+ * Direction bits, which any architecture can choose to override
+ * before including this file.
  */
-#define _IOC_NONE	0U
-#define _IOC_WRITE	1U
-#define _IOC_READ	2U
+
+#ifndef _IOC_NONE
+# define _IOC_NONE	0U
+#endif
+
+#ifndef _IOC_WRITE
+# define _IOC_WRITE	1U
+#endif
+
+#ifndef _IOC_READ
+# define _IOC_READ	2U
+#endif
 
 #define _IOC(dir,type,nr,size) \
 	(((dir)  << _IOC_DIRSHIFT) | \
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-dvb.patch
git-mtd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

