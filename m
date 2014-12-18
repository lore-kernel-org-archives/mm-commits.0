From: akpm@linux-foundation.org
Subject: + lib-remove-strnicmp.patch added to -mm tree
Date: Thu, 18 Dec 2014 14:48:25 -0800
Message-ID: <549359b9.6bOz2Tml2a3E2LGQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaLRWs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:48:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, dhowells@redhat.com, heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: remove strnicmp()
has been added to the -mm tree.  Its filename is
     lib-remove-strnicmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-remove-strnicmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-remove-strnicmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch
lib-bitmap-more-signed-unsigned-conversions.patch
linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
lib-bitmap-simplify-bitmap_pos_to_ord.patch
lib-bitmap-simplify-bitmap_ord_to_pos.patch
lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch
lib-remove-strnicmp.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch

