From: akpm@linux-foundation.org
Subject: [merged] slab-document-kmalloc_order.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:49:29 -0700
Message-ID: <5390c9c9.sbEmNtPnvjIPwJfn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFETt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, cl@linux.com, vdavydov@parallels.com

Subject: [merged] slab-document-kmalloc_order.patch removed from -mm tree
To: vdavydov@parallels.com,cl@linux.com,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:29 -0700


The patch titled
     Subject: slab: document kmalloc_order
has been removed from the -mm tree.  Its filename was
     slab-document-kmalloc_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: document kmalloc_order

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/slab_common.c~slab-document-kmalloc_order mm/slab_common.c
--- a/mm/slab_common.c~slab-document-kmalloc_order
+++ a/mm/slab_common.c
@@ -582,6 +582,11 @@ void __init create_kmalloc_caches(unsign
 }
 #endif /* !CONFIG_SLOB */
 
+/*
+ * To avoid unnecessary overhead, we pass through large allocation requests
+ * directly to the page allocator. We use __GFP_COMP, because we will need to
+ * know the allocation order to free the pages properly in kfree.
+ */
 void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
 {
 	void *ret;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

