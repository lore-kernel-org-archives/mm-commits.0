From: akpm@linux-foundation.org
Subject: [merged] mm-slab-convert-slab_is_available-to-boolean.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:28 -0800
Message-ID: <563d0844.viYqAgT1SChfj8Gw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033447AbbKFUG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kda@linux-powerpc.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: convert slab_is_available() to boolean
has been removed from the -mm tree.  Its filename was
     mm-slab-convert-slab_is_available-to-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Denis Kirjanov <kda@linux-powerpc.org>
Subject: slab: convert slab_is_available() to boolean

A good candidate to return a boolean result.

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
Cc: Christoph Lameter <cl@linux.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 mm/slab_common.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/slab.h~mm-slab-convert-slab_is_available-to-boolean include/linux/slab.h
--- a/include/linux/slab.h~mm-slab-convert-slab_is_available-to-boolean
+++ a/include/linux/slab.h
@@ -111,7 +111,7 @@ struct mem_cgroup;
  * struct kmem_cache related prototypes
  */
 void __init kmem_cache_init(void);
-int slab_is_available(void);
+bool slab_is_available(void);
 
 struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
 			unsigned long,
diff -puN mm/slab_common.c~mm-slab-convert-slab_is_available-to-boolean mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-convert-slab_is_available-to-boolean
+++ a/mm/slab_common.c
@@ -692,7 +692,7 @@ int kmem_cache_shrink(struct kmem_cache
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
-int slab_is_available(void)
+bool slab_is_available(void)
 {
 	return slab_state >= UP;
 }
_

Patches currently in -mm which might be from kda@linux-powerpc.org are


