From: akpm@linux-foundation.org
Subject: [merged] mm-slab-noinline-__ac_put_obj.patch removed from -mm
 tree
Date: Mon, 13 Oct 2014 11:18:38 -0700
Message-ID: <543c177e.kEMApD7USNQuZ+D9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: noinline __ac_put_obj()
has been removed from the -mm tree.  Its filename was
     mm-slab-noinline-__ac_put_obj.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: noinline __ac_put_obj()

Our intention of __ac_put_obj() is that it doesn't affect anything if
sk_memalloc_socks() is disabled.  But, because __ac_put_obj() is too
small, compiler inline it to ac_put_obj() and affect code size of free
path.  This patch add noinline keyword for __ac_put_obj() not to distrupt
normal free path at all.

<Before>
nm -S slab-orig.o |
	grep -e "t cache_alloc_refill" -e "T kfree" -e "T kmem_cache_free"

0000000000001e80 00000000000002f5 t cache_alloc_refill
0000000000001230 0000000000000258 T kfree
0000000000000690 000000000000024c T kmem_cache_free

<After>
nm -S slab-patched.o |
	grep -e "t cache_alloc_refill" -e "T kfree" -e "T kmem_cache_free"

0000000000001e00 00000000000002e5 t cache_alloc_refill
00000000000011e0 0000000000000228 T kfree
0000000000000670 0000000000000216 T kmem_cache_free

cache_alloc_refill: 0x2f5->0x2e5
kfree: 0x256->0x228
kmem_cache_free: 0x24c->0x216

code size of each function is reduced slightly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~mm-slab-noinline-__ac_put_obj mm/slab.c
--- a/mm/slab.c~mm-slab-noinline-__ac_put_obj
+++ a/mm/slab.c
@@ -785,8 +785,8 @@ static inline void *ac_get_obj(struct km
 	return objp;
 }
 
-static void *__ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
-								void *objp)
+static noinline void *__ac_put_obj(struct kmem_cache *cachep,
+			struct array_cache *ac, void *objp)
 {
 	if (unlikely(pfmemalloc_active)) {
 		/* Some pfmemalloc slabs exist, check if this is one */
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
page-owners-correct-page-order-when-to-free-page.patch

