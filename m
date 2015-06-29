From: akpm@linux-foundation.org
Subject: [merged] mm-only-define-hashdist-variable-when-needed.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:37:41 -0700
Message-ID: <5591ac95.Z8k7BgX+djJxDUWd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbbF2Uhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:37:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: only define hashdist variable when needed
has been removed from the -mm tree.  Its filename was
     mm-only-define-hashdist-variable-when-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm: only define hashdist variable when needed

For !CONFIG_NUMA, hashdist will always be 0, since it's setter is
otherwise compiled out.  So we can save 4 bytes of data and some .text
(although mostly in __init functions) by only defining it for CONFIG_NUMA.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
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
@@ -6013,9 +6013,9 @@ out:
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

origin.patch
linux-next.patch

