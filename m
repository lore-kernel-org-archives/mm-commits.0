From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
 removed from -mm tree
Date: Thu, 09 Oct 2014 13:30:10 -0700
Message-ID: <5436f052.8sauk1fLpdAZDRWt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaJIUaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix kmemcheck.c build errors
has been removed from the -mm tree.  Its filename was
     mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch

This patch was dropped because it was folded into mm-slab_common-move-kmem_cache-definition-to-internal-header.patch

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: fix kmemcheck.c build errors

Add header files to fix kmemcheck.c build errors:

../mm/kmemcheck.c:70:7: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:83:15: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:95:8: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:95:21: error: dereferencing pointer to incomplete type

../mm/slab.h: In function 'cache_from_obj':
../mm/slab.h:283:2: error: implicit declaration of function 'memcg_kmem_enabled' [-Werror=implicit-function-declaration]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemcheck.c |    1 +
 mm/slab.h      |    2 ++
 2 files changed, 3 insertions(+)

diff -puN mm/kmemcheck.c~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2 mm/kmemcheck.c
--- a/mm/kmemcheck.c~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2
+++ a/mm/kmemcheck.c
@@ -2,6 +2,7 @@
 #include <linux/mm_types.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include "slab.h"
 #include <linux/kmemcheck.h>
 
 void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
diff -puN mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2 mm/slab.h
--- a/mm/slab.h~mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2
+++ a/mm/slab.h
@@ -268,6 +268,8 @@ static inline void memcg_uncharge_slab(s
 }
 #endif
 
+#include <linux/memcontrol.h>
+
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 {
 	struct kmem_cache *cachep;
_

Patches currently in -mm which might be from rdunlap@infradead.org are

origin.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix.patch
mm-slab_common-commonize-slab-merge-logic.patch
mm-slab_common-commonize-slab-merge-logic-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch

