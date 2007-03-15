From: akpm@linux-foundation.org
Subject: + fix-cycladesh-for-x86_64-and-probably-others.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:53:27 -0800
Message-ID: <200703151853.l2FIrT3k023415@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35755 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbXCOSxf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:53:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: klaus.kudielka@gmx.net


The patch titled
     fix cyclades.h for x86_64 (and probably others)
has been added to the -mm tree.  Its filename is
     fix-cycladesh-for-x86_64-and-probably-others.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix cyclades.h for x86_64 (and probably others)
From: Klaus Kudielka <klaus.kudielka@gmx.net>

At least on x86_64 the present cyclades.h is broken due to the wrong size
of uclong.  This affects, of course, both the kernel and the user-level
utilities.  The symptom is that cyzload refuses to load the firmware.  I
also managed to freeze the machine when unloading the module.

The patch below fixes this in an architecture-independent way.  I have
tested it with 2.6.19 and the driver works fine again with a Cyclades-Z on
an Athlon 64 X2.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cyclades.h |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN include/linux/cyclades.h~fix-cycladesh-for-x86_64-and-probably-others include/linux/cyclades.h
--- a/include/linux/cyclades.h~fix-cycladesh-for-x86_64-and-probably-others
+++ a/include/linux/cyclades.h
@@ -149,14 +149,12 @@ struct CYZ_BOOT_CTRL {
  *	architectures and compilers.
  */
 
-#if defined(__alpha__)
-typedef unsigned long	ucdouble;	/* 64 bits, unsigned */
-typedef unsigned int	uclong;		/* 32 bits, unsigned */
-#else
-typedef unsigned long	uclong;		/* 32 bits, unsigned */
-#endif
-typedef unsigned short	ucshort;	/* 16 bits, unsigned */
-typedef unsigned char	ucchar;		/* 8 bits, unsigned */
+#include <asm/types.h>
+
+typedef __u64  ucdouble;		/* 64 bits, unsigned */
+typedef __u32  uclong;			/* 32 bits, unsigned */
+typedef __u16  ucshort;		/* 16 bits, unsigned */
+typedef __u8   ucchar;			/* 8 bits, unsigned */
 
 /*
  *	Memory Window Sizes
_

Patches currently in -mm which might be from klaus.kudielka@gmx.net are

fix-cycladesh-for-x86_64-and-probably-others.patch
