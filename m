From: akpm@linux-foundation.org
Subject: - slob-do-not-pass-the-slab-flags-as-gfp-in-kmem_cache_create.patch removed from -mm tree
Date: Tue, 16 Dec 2008 12:30:14 -0800
Message-ID: <200812162030.mBGKUEf2006395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312AbYLPUbQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 15:31:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, cl@linux-foundation.org, gorcunov@gmail.com, mpm@selenic.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slob: do not pass the SLAB flags as GFP in kmem_cache_create()
has been removed from the -mm tree.  Its filename was
     slob-do-not-pass-the-slab-flags-as-gfp-in-kmem_cache_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slob: do not pass the SLAB flags as GFP in kmem_cache_create()
From: Catalin Marinas <catalin.marinas@arm.com>

The kmem_cache_create() function in the slob allocator passes the SLAB
flags as GFP flags to the slob_alloc() function.  The patch changes this
call to pass GFP_KERNEL as the other allocators seem to do.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slob.c~slob-do-not-pass-the-slab-flags-as-gfp-in-kmem_cache_create mm/slob.c
--- a/mm/slob.c~slob-do-not-pass-the-slab-flags-as-gfp-in-kmem_cache_create
+++ a/mm/slob.c
@@ -535,7 +535,7 @@ struct kmem_cache *kmem_cache_create(con
 	struct kmem_cache *c;
 
 	c = slob_alloc(sizeof(struct kmem_cache),
-		flags, ARCH_KMALLOC_MINALIGN, -1);
+		GFP_KERNEL, ARCH_KMALLOC_MINALIGN, -1);
 
 	if (c) {
 		c->name = name;
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch

