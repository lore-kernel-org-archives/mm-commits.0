From: akpm@linux-foundation.org
Subject: + mm-only-define-hashdist-variable-when-needed.patch added to -mm tree
Date: Mon, 04 May 2015 16:28:19 -0700
Message-ID: <55480093.mc03y0O2I8v9BvOi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbEDX2U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2015 19:28:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: only define hashdist variable when needed
has been added to the -mm tree.  Its filename is
     mm-only-define-hashdist-variable-when-needed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-only-define-hashdist-variable-when-needed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-only-define-hashdist-variable-when-needed.patch

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
Subject: mm: only define hashdist variable when needed

For !CONFIG_NUMA, hashdist will always be 0, since it's setter is
otherwise compiled out.  So we can save 4 bytes of data and some .text
(although mostly in __init functions) by only defining it for CONFIG_NUMA.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    8 ++++----
 mm/page_alloc.c         |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/bootmem.h~mm-only-define-hashdist-variable-when-needed include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-only-define-hashdist-variable-when-needed
+++ a/include/linux/bootmem.h
@@ -357,12 +357,12 @@ extern void *alloc_large_system_hash(con
 /* Only NUMA needs hash distribution. 64bit NUMA architectures have
  * sufficient vmalloc space.
  */
-#if defined(CONFIG_NUMA) && defined(CONFIG_64BIT)
-#define HASHDIST_DEFAULT 1
+#ifdef CONFIG_NUMA
+#define HASHDIST_DEFAULT IS_ENABLED(CONFIG_64BIT)
+extern int hashdist;		/* Distribute hashes across NUMA nodes? */
 #else
-#define HASHDIST_DEFAULT 0
+#define hashdist (0)
 #endif
-extern int hashdist;		/* Distribute hashes across NUMA nodes? */
 
 
 #endif /* _LINUX_BOOTMEM_H */
diff -puN mm/page_alloc.c~mm-only-define-hashdist-variable-when-needed mm/page_alloc.c
--- a/mm/page_alloc.c~mm-only-define-hashdist-variable-when-needed
+++ a/mm/page_alloc.c
@@ -6317,9 +6317,9 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_NUMA
 int hashdist = HASHDIST_DEFAULT;
 
-#ifdef CONFIG_NUMA
 static int __init set_hashdist(char *str)
 {
 	if (!str)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-slabh-fix-three-off-by-one-typos-in-comment.patch
mm-only-define-hashdist-variable-when-needed.patch
__bitmap_parselist-fix-bug-in-empty-string-handling.patch
lib-sort-add-64-bit-swap-function.patch

