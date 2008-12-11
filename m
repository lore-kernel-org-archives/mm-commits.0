From: akpm@linux-foundation.org
Subject: + slob-do-not-pass-the-slab-flags-as-gfp-in-kmem_cache_create.patch added to -mm tree
Date: Thu, 11 Dec 2008 14:11:34 -0800
Message-ID: <200812112211.mBBMBYUQ027613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756778AbYLKWMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 17:12:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, cl@linux-foundation.org, gorcunov@gmail.com, mpm@selenic.com, penberg@cs.helsinki.fi


The patch titled
     slob: do not pass the SLAB flags as GFP in kmem_cache_create()
has been added to the -mm tree.  Its filename is
     slob-do-not-pass-the-slab-flags-as-gfp-in-kmem_cache_create.patch

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
@@ -549,7 +549,7 @@ struct kmem_cache *kmem_cache_create(con
 	struct kmem_cache *c;
 
 	c = slob_alloc(sizeof(struct kmem_cache),
-		flags, ARCH_KMALLOC_MINALIGN, -1);
+		GFP_KERNEL, ARCH_KMALLOC_MINALIGN, -1);
 
 	if (c) {
 		c->name = name;
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

slob-do-not-pass-the-slab-flags-as-gfp-in-kmem_cache_create.patch
linux-next.patch

