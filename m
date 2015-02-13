From: akpm@linux-foundation.org
Subject: [merged] lib-remove-strnicmp.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:22:30 -0800
Message-ID: <54de5d06.DAwv2iPshKoazfpn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbbBMUWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, dhowells@redhat.com, heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: remove strnicmp()
has been removed from the -mm tree.  Its filename was
     lib-remove-strnicmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/string.c: remove strnicmp()

Now that all in-tree users of strnicmp have been converted to
strncasecmp, the wrapper can be removed.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: David Howells <dhowells@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/string.h  |    1 -
 arch/s390/include/asm/string.h |    1 -
 include/linux/string.h         |    3 ---
 lib/string.c                   |    8 --------
 4 files changed, 13 deletions(-)

diff -puN arch/frv/include/asm/string.h~lib-remove-strnicmp arch/frv/include/asm/string.h
--- a/arch/frv/include/asm/string.h~lib-remove-strnicmp
+++ a/arch/frv/include/asm/string.h
@@ -33,7 +33,6 @@ extern void *memcpy(void *, const void *
 #define __HAVE_ARCH_STRNCAT 1
 #define __HAVE_ARCH_STRCMP 1
 #define __HAVE_ARCH_STRNCMP 1
-#define __HAVE_ARCH_STRNICMP 1
 #define __HAVE_ARCH_STRCHR 1
 #define __HAVE_ARCH_STRRCHR 1
 #define __HAVE_ARCH_STRSTR 1
diff -puN arch/s390/include/asm/string.h~lib-remove-strnicmp arch/s390/include/asm/string.h
--- a/arch/s390/include/asm/string.h~lib-remove-strnicmp
+++ a/arch/s390/include/asm/string.h
@@ -44,7 +44,6 @@ extern char *strstr(const char *, const
 #undef __HAVE_ARCH_STRCHR
 #undef __HAVE_ARCH_STRNCHR
 #undef __HAVE_ARCH_STRNCMP
-#undef __HAVE_ARCH_STRNICMP
 #undef __HAVE_ARCH_STRPBRK
 #undef __HAVE_ARCH_STRSEP
 #undef __HAVE_ARCH_STRSPN
diff -puN include/linux/string.h~lib-remove-strnicmp include/linux/string.h
--- a/include/linux/string.h~lib-remove-strnicmp
+++ a/include/linux/string.h
@@ -40,9 +40,6 @@ extern int strcmp(const char *,const cha
 #ifndef __HAVE_ARCH_STRNCMP
 extern int strncmp(const char *,const char *,__kernel_size_t);
 #endif
-#ifndef __HAVE_ARCH_STRNICMP
-#define strnicmp strncasecmp
-#endif
 #ifndef __HAVE_ARCH_STRCASECMP
 extern int strcasecmp(const char *s1, const char *s2);
 #endif
diff -puN lib/string.c~lib-remove-strnicmp lib/string.c
--- a/lib/string.c~lib-remove-strnicmp
+++ a/lib/string.c
@@ -58,14 +58,6 @@ int strncasecmp(const char *s1, const ch
 }
 EXPORT_SYMBOL(strncasecmp);
 #endif
-#ifndef __HAVE_ARCH_STRNICMP
-#undef strnicmp
-int strnicmp(const char *s1, const char *s2, size_t len)
-{
-	return strncasecmp(s1, s2, len);
-}
-EXPORT_SYMBOL(strnicmp);
-#endif
 
 #ifndef __HAVE_ARCH_STRCASECMP
 int strcasecmp(const char *s1, const char *s2)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

