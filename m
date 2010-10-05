From: akpm@linux-foundation.org
Subject: + bitops-remove-duplicated-extern-declarations.patch added to -mm tree
Date: Tue, 05 Oct 2010 15:11:11 -0700
Message-ID: <201010052211.o95MBBgs023085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756653Ab0JEWLo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 18:11:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arnd@arndb.de


The patch titled
     bitops: remove duplicated extern declarations
has been added to the -mm tree.  Its filename is
     bitops-remove-duplicated-extern-declarations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitops: remove duplicated extern declarations
From: Akinobu Mita <akinobu.mita@gmail.com>

If CONFIG_GENERIC_FIND_NEXT_BIT is enabled, find_next_bit() and
find_next_zero_bit() are doubly declared in asm-generic/bitops/find.h and
linux/bitops.h.

asm/bitops.h includes asm-generic/bitops/find.h if and only if the
architecture enables CONFIG_GENERIC_FIND_NEXT_BIT.  And asm/bitops.h is
included by linux/bitops.h

So we can just remove the extern declarations of find_next_bit() and
find_next_zero_bit() in linux/bitops.h.

Also we can remove unneeded #ifndef CONFIG_GENERIC_FIND_NEXT_BIT in
asm-generic/bitops/find.h.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/find.h |   14 ++++++++++++--
 include/linux/bitops.h            |   23 -----------------------
 2 files changed, 12 insertions(+), 25 deletions(-)

diff -puN include/asm-generic/bitops/find.h~bitops-remove-duplicated-extern-declarations include/asm-generic/bitops/find.h
--- a/include/asm-generic/bitops/find.h~bitops-remove-duplicated-extern-declarations
+++ a/include/asm-generic/bitops/find.h
@@ -1,13 +1,23 @@
 #ifndef _ASM_GENERIC_BITOPS_FIND_H_
 #define _ASM_GENERIC_BITOPS_FIND_H_
 
-#ifndef CONFIG_GENERIC_FIND_NEXT_BIT
+/**
+ * find_next_bit - find the next set bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ */
 extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
 		size, unsigned long offset);
 
+/**
+ * find_next_zero_bit - find the next cleared bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ */
 extern unsigned long find_next_zero_bit(const unsigned long *addr, unsigned
 		long size, unsigned long offset);
-#endif
 
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 
diff -puN include/linux/bitops.h~bitops-remove-duplicated-extern-declarations include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-remove-duplicated-extern-declarations
+++ a/include/linux/bitops.h
@@ -149,28 +149,5 @@ extern unsigned long find_last_bit(const
 				   unsigned long size);
 #endif /* CONFIG_GENERIC_FIND_LAST_BIT */
 
-#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
-
-/**
- * find_next_bit - find the next set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The bitmap size in bits
- */
-extern unsigned long find_next_bit(const unsigned long *addr,
-				   unsigned long size, unsigned long offset);
-
-/**
- * find_next_zero_bit - find the next cleared bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The bitmap size in bits
- */
-
-extern unsigned long find_next_zero_bit(const unsigned long *addr,
-					unsigned long size,
-					unsigned long offset);
