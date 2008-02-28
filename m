From: akpm@linux-foundation.org
Subject: + generalize-asm-generic-ioctlh-to-allow-overriding-values.patch added to -mm tree
Date: Wed, 27 Feb 2008 21:44:38 -0800
Message-ID: <200802280544.m1S5ic5b017984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbYB1Fon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 00:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     From: "Robert P. J. Day" <rpjday@crashcourse.ca>
has been added to the -mm tree.  Its filename is
     generalize-asm-generic-ioctlh-to-allow-overriding-values.patch

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
Subject: From: "Robert P. J. Day" <rpjday@crashcourse.ca>


In the spirit of a number of other asm-generic header files,
generalize asm-generic/ioctl.h to allow arch-specific ioctl.h headers
to simply override _IOC_SIZEBITS and/or _IOC_DIRBITS before including
this header file, allowing a number of ioctl.h header files to be
shortened considerably.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  i'm not sure what kernel subsystem this falls under.  this change
should not affect anything in the kernel, and the corresponding
ioctl.h headers can be tweaked sometime down the road.

index cd02729..4fb087a 100644
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

git-nfsd.patch
git-xfs.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
