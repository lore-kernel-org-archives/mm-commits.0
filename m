From: akpm@linux-foundation.org
Subject: [merged] kmalloc-return-null-instead-of-link-failure.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:37:07 -0800
Message-ID: <200902021937.n12Jb7hR013741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753244AbZBBTiP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:38:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, cl@linux-foundation.org, heiko.carstens@de.ibm.com, mpm@selenic.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, schwidefsky@de.ibm.com, stable@kernel.org, mm-com


The patch titled
     kmalloc: return NULL instead of link failure
has been removed from the -mm tree.  Its filename was
     kmalloc-return-null-instead-of-link-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmalloc: return NULL instead of link failure
From: Jeff Mahoney <jeffm@suse.com>

The SLAB kmalloc with a constant value isn't consistent with the other
implementations because it bails out with __you_cannot_kmalloc_that_much
rather than returning NULL and properly allowing the caller to fall back
to vmalloc or take other action.  This doesn't happen with a non-constant
value or with SLOB or SLUB.

Starting with 2.6.28, I've been seeing build failures on s390x.  This is
due to init_section_page_cgroup trying to allocate 2.5MB when the max size
for a kmalloc on s390x is 2MB.

It's failing because the value is constant.  The workarounds at the call
size are ugly and the caller shouldn't have to change behavior depending
on what the backend of the API is.

So, this patch eliminates the link failure and returns NULL like the other
implementations.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab_def.h |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN include/linux/slab_def.h~kmalloc-return-null-instead-of-link-failure include/linux/slab_def.h
--- a/include/linux/slab_def.h~kmalloc-return-null-instead-of-link-failure
+++ a/include/linux/slab_def.h
@@ -43,10 +43,7 @@ static inline void *kmalloc(size_t size,
 			i++;
 #include <linux/kmalloc_sizes.h>
 #undef CACHE
-		{
-			extern void __you_cannot_kmalloc_that_much(void);
-			__you_cannot_kmalloc_that_much();
-		}
+		return NULL;
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
@@ -77,10 +74,7 @@ static inline void *kmalloc_node(size_t 
 			i++;
 #include <linux/kmalloc_sizes.h>
 #undef CACHE
-		{
-			extern void __you_cannot_kmalloc_that_much(void);
-			__you_cannot_kmalloc_that_much();
-		}
+		return NULL;
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
_

Patches currently in -mm which might be from jeffm@suse.com are

linux-next.patch
x86-define-arch_want_frame_pointers.patch
x86-define-arch_want_frame_pointers-fix.patch

