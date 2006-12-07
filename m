From: akpm@osdl.org
Subject: - slab-debug-and-arch_slab_minalign-dont-get-along.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:37 -0800
Message-ID: <200612072256.kB7MubnV029216@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50535 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163602AbWLGW5A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khilman@mvista.com, clameter@engr.sgi.com, manfred@colorfullife.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slab debug and ARCH_SLAB_MINALIGN don't get along
has been removed from the -mm tree.  Its filename was
     slab-debug-and-arch_slab_minalign-dont-get-along.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab debug and ARCH_SLAB_MINALIGN don't get along
From: Kevin Hilman <khilman@mvista.com>

When CONFIG_SLAB_DEBUG is used in combination with ARCH_SLAB_MINALIGN, some
debug flags should be disabled which depend on BYTES_PER_WORD alignment.

The disabling of these debug flags is not properly handled when
BYTES_PER_WORD < ARCH_SLAB_MEMALIGN < cache_line_size()

This patch fixes that and also adds an alignment check to
cache_alloc_debugcheck_after() when ARCH_SLAB_MINALIGN is used.

Signed-off-by: Kevin Hilman <khilman@mvista.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/slab.c~slab-debug-and-arch_slab_minalign-dont-get-along mm/slab.c
--- a/mm/slab.c~slab-debug-and-arch_slab_minalign-dont-get-along
+++ a/mm/slab.c
@@ -2197,18 +2197,17 @@ kmem_cache_create (const char *name, siz
 	if (flags & SLAB_RED_ZONE || flags & SLAB_STORE_USER)
 		ralign = BYTES_PER_WORD;
 
-	/* 2) arch mandated alignment: disables debug if necessary */
+	/* 2) arch mandated alignment */
 	if (ralign < ARCH_SLAB_MINALIGN) {
 		ralign = ARCH_SLAB_MINALIGN;
-		if (ralign > BYTES_PER_WORD)
-			flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
 	}
-	/* 3) caller mandated alignment: disables debug if necessary */
+	/* 3) caller mandated alignment */
 	if (ralign < align) {
 		ralign = align;
-		if (ralign > BYTES_PER_WORD)
-			flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
 	}
+	/* disable debug if necessary */
+	if (ralign > BYTES_PER_WORD)
+		flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
 	/*
 	 * 4) Store it.
 	 */
@@ -3063,6 +3062,12 @@ static void *cache_alloc_debugcheck_afte
 
 		cachep->ctor(objp, cachep, ctor_flags);
 	}
+#if ARCH_SLAB_MINALIGN
+	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
+		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
+		       objp, ARCH_SLAB_MINALIGN);
+	}
+#endif
 	return objp;
 }
 #else
_

Patches currently in -mm which might be from khilman@mvista.com are

origin.patch

