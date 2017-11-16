From: akpm@linux-foundation.org
Subject: [merged] mm-add-kmalloc_array_node-and-kcalloc_node.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 11:59:39 -0800
Message-ID: <20171116195939.eemArSCet%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934028AbdKPT7l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 14:59:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, cl@linux.com, damien.lemoal@wdc.com, davem@davemloft.net, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, iamjoonsoo.kim@lge.com, infinipath@intel.com, jthumshirn@suse.de, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, santosh.shilimkar@oracle.com, sean.hefty@intel.com, vbabka@suse.cz


The patch titled
     Subject: include/linux/slab.h: add kmalloc_array_node() and kcalloc_node()
has been removed from the -mm tree.  Its filename was
     mm-add-kmalloc_array_node-and-kcalloc_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: include/linux/slab.h: add kmalloc_array_node() and kcalloc_node()

Patch series "Add kmalloc_array_node() and kcalloc_node()".

Our current memeory allocation routines suffer form an API imbalance,
for one we have kmalloc_array() and kcalloc() which check for
overflows in size multiplication and we have kmalloc_node() and
kzalloc_node() which allow for memory allocation on a certain NUMA
node but don't check for eventual overflows.


This patch (of 6):

We have kmalloc_array() and kcalloc() wrappers on top of kmalloc() which
ensure us overflow free multiplication for the size of a memory allocation
but these implementations are not NUMA-aware.

Likewise we have kmalloc_node() which is a NUMA-aware version of kmalloc()
but the implementation is not aware of any possible overflows in eventual
size calculations.

Introduce a combination of the two above cases to have a NUMA-node aware
version of kmalloc_array() and kcalloc().

Link: http://lkml.kernel.org/r/20170927082038.3782-2-jthumshirn@suse.de
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Marciniszyn <infinipath@intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN include/linux/slab.h~mm-add-kmalloc_array_node-and-kcalloc_node include/linux/slab.h
--- a/include/linux/slab.h~mm-add-kmalloc_array_node-and-kcalloc_node
+++ a/include/linux/slab.h
@@ -650,6 +650,22 @@ extern void *__kmalloc_track_caller(size
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, _RET_IP_)
 
+static inline void *kmalloc_array_node(size_t n, size_t size, gfp_t flags,
+				       int node)
+{
+	if (size != 0 && n > SIZE_MAX / size)
+		return NULL;
+	if (__builtin_constant_p(n) && __builtin_constant_p(size))
+		return kmalloc_node(n * size, flags, node);
+	return __kmalloc_node(n * size, flags, node);
+}
+
+static inline void *kcalloc_node(size_t n, size_t size, gfp_t flags, int node)
+{
+	return kmalloc_array_node(n, size, flags | __GFP_ZERO, node);
+}
+
+
 #ifdef CONFIG_NUMA
 extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 #define kmalloc_node_track_caller(size, flags, node) \
_

Patches currently in -mm which might be from jthumshirn@suse.de are


