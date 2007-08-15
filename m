From: akpm@linux-foundation.org
Subject: + remove-strict-ansi-check-from-__u64-in-asm-typesh.patch added to -mm tree
Date: Wed, 15 Aug 2007 13:00:38 -0700
Message-ID: <200708152000.l7FK0cvN012536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756807AbXHOUBi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:01:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olh@suse.de, linux-arch@vger.kernel.org


The patch titled
     remove strict ansi check from __u64 in asm/types.h
has been added to the -mm tree.  Its filename is
     remove-strict-ansi-check-from-__u64-in-asm-typesh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove strict ansi check from __u64 in asm/types.h
From: Olaf Hering <olh@suse.de>

Remove the __STRICT_ANSI__ check from the __u64/__s64 declaration on
32bit targets.

GCC can be made to warn about usage of long long types with ISO C90
(-ansi), but only with -pedantic.  You can write this in a way that even
then it doesn't cause warnings, namely by:

#ifdef __GNUC__
__extension__ typedef __signed__ long long __s64;
__extension__ typedef unsigned long long __u64;
#endif

The __extension__ keyword in front of this switches off any pedantic
warnings for this expression.

Signed-off-by: Olaf Hering <olh@suse.de>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/types.h      |    6 +++---
 include/asm-avr32/types.h    |    6 +++---
 include/asm-blackfin/types.h |    6 +++---
 include/asm-cris/types.h     |    6 +++---
 include/asm-frv/types.h      |    6 +++---
 include/asm-h8300/types.h    |    6 +++---
 include/asm-i386/types.h     |    6 +++---
 include/asm-m32r/types.h     |    6 +++---
 include/asm-m68k/types.h     |    6 +++---
 include/asm-mips/types.h     |    6 +++---
 include/asm-parisc/types.h   |    6 +++---
 include/asm-powerpc/types.h  |    6 +++---
 include/asm-s390/types.h     |    6 +++---
 include/asm-sh/types.h       |    6 +++---
 include/asm-sh64/types.h     |    6 +++---
 include/asm-v850/types.h     |    6 +++---
 include/asm-xtensa/types.h   |    6 +++---
 17 files changed, 51 insertions(+), 51 deletions(-)

diff -puN include/asm-arm/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-arm/types.h
--- a/include/asm-arm/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-arm/types.h
@@ -19,9 +19,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -puN include/asm-avr32/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-avr32/types.h
--- a/include/asm-avr32/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-avr32/types.h
@@ -25,9 +25,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -puN include/asm-blackfin/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-blackfin/types.h
--- a/include/asm-blackfin/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-blackfin/types.h
@@ -27,9 +27,9 @@ typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
 /* HK0617   -- Changes to unsigned long temporarily */
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif				/* __ASSEMBLY__ */
diff -puN include/asm-cris/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-cris/types.h
--- a/include/asm-cris/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-cris/types.h
@@ -19,9 +19,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -puN include/asm-frv/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-frv/types.h
--- a/include/asm-frv/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-frv/types.h
@@ -30,9 +30,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -puN include/asm-h8300/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-h8300/types.h
--- a/include/asm-h8300/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-h8300/types.h
@@ -27,9 +27,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 /*
diff -puN include/asm-i386/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-i386/types.h
--- a/include/asm-i386/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-i386/types.h
@@ -19,9 +19,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -puN include/asm-m32r/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-m32r/types.h
--- a/include/asm-m32r/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-m32r/types.h
@@ -19,9 +19,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 #endif /* __ASSEMBLY__ */
 
diff -puN include/asm-m68k/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-m68k/types.h
--- a/include/asm-m68k/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-m68k/types.h
@@ -27,9 +27,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -puN include/asm-mips/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-mips/types.h
--- a/include/asm-mips/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-mips/types.h
@@ -34,9 +34,9 @@ typedef unsigned long __u64;
 
 #else
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif
diff -puN include/asm-parisc/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-parisc/types.h
--- a/include/asm-parisc/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-parisc/types.h
@@ -19,9 +19,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -puN include/asm-powerpc/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-powerpc/types.h
--- a/include/asm-powerpc/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-powerpc/types.h
@@ -40,9 +40,9 @@ typedef unsigned int __u32;
 typedef __signed__ long __s64;
 typedef unsigned long __u64;
 #else
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 #endif /* __powerpc64__ */
 
diff -puN include/asm-s390/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-s390/types.h
--- a/include/asm-s390/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-s390/types.h
@@ -28,9 +28,9 @@ typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
 #ifndef __s390x__
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 #else /* __s390x__ */
 typedef __signed__ long __s64;
diff -puN include/asm-sh/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-sh/types.h
--- a/include/asm-sh/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-sh/types.h
@@ -19,9 +19,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -puN include/asm-sh64/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-sh64/types.h
--- a/include/asm-sh64/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-sh64/types.h
@@ -30,9 +30,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -puN include/asm-v850/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-v850/types.h
--- a/include/asm-v850/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-v850/types.h
@@ -27,9 +27,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 #endif /* !__ASSEMBLY__ */
diff -puN include/asm-xtensa/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh include/asm-xtensa/types.h
--- a/include/asm-xtensa/types.h~remove-strict-ansi-check-from-__u64-in-asm-typesh
+++ a/include/asm-xtensa/types.h
@@ -29,9 +29,9 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
-typedef __signed__ long long __s64;
-typedef unsigned long long __u64;
+#if defined(__GNUC__)
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
 #endif
 
 /*
_

Patches currently in -mm which might be from olh@suse.de are

git-ieee1394.patch
do-not-export-usr-include-scsi-in-make-headers_install.patch
remove-strict-ansi-check-from-__u64-in-asm-typesh.patch
