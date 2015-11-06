From: akpm@linux-foundation.org
Subject: [merged] mm-initialize-kmem_cache-pointer-to-null.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:07:00 -0800
Message-ID: <563d0864.Pr+t5+nP4paSDOS5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162138AbbKFUHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:07:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 00moses.alexander00@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: initialize kmem_cache pointer to NULL
has been removed from the -mm tree.  Its filename was
     mm-initialize-kmem_cache-pointer-to-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandru Moise <00moses.alexander00@gmail.com>
Subject: mm/slab_common.c: initialize kmem_cache pointer to NULL

The assignment to NULL within the error condition was written in a 2014
patch to suppress a compiler warning.  However it would be cleaner to just
initialize the kmem_cache to NULL and just return it in case of an error
condition.

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slab_common.c~mm-initialize-kmem_cache-pointer-to-null mm/slab_common.c
--- a/mm/slab_common.c~mm-initialize-kmem_cache-pointer-to-null
+++ a/mm/slab_common.c
@@ -384,7 +384,7 @@ struct kmem_cache *
 kmem_cache_create(const char *name, size_t size, size_t align,
 		  unsigned long flags, void (*ctor)(void *))
 {
-	struct kmem_cache *s;
+	struct kmem_cache *s = NULL;
 	const char *cache_name;
 	int err;
 
@@ -396,7 +396,6 @@ kmem_cache_create(const char *name, size
 
 	err = kmem_cache_sanity_check(name, size);
 	if (err) {
-		s = NULL;	/* suppress uninit var warning */
 		goto out_unlock;
 	}
 
_

Patches currently in -mm which might be from 00moses.alexander00@gmail.com are


