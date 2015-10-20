From: akpm@linux-foundation.org
Subject: + mm-initialize-kmem_cache-pointer-to-null.patch added to -mm
 tree
Date: Tue, 20 Oct 2015 15:23:11 -0700
Message-ID: <5626becf.+b0OkxsSI0rsmWRE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbbJTWXM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Oct 2015 18:23:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 00moses.alexander00@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: initialize kmem_cache pointer to NULL
has been added to the -mm tree.  Its filename is
     mm-initialize-kmem_cache-pointer-to-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-initialize-kmem_cache-pointer-to-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-initialize-kmem_cache-pointer-to-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: David Rientjes <rientjes@google.com>
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

mm-initialize-kmem_cache-pointer-to-null.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable.patch

