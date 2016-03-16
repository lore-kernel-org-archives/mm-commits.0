From: akpm@linux-foundation.org
Subject: [merged] mm-kmemcheck-skip-object-if-slab-allocation-failed.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:44 -0700
Message-ID: <56e9b9c8.NR9SVMz3/PUHVSsc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbcCPTxp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemcheck skip object if slab allocation failed
has been removed from the -mm tree.  Its filename was
     mm-kmemcheck-skip-object-if-slab-allocation-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: mm: kmemcheck skip object if slab allocation failed

In the SLAB allocator kmemcheck_slab_alloc() is guarded against being
called in case the object is NULL.  In SLUB allocator this NULL pointer
invocation can happen, which seems like an oversight.

Move the NULL pointer check into kmemcheck code (kmemcheck_slab_alloc) so
the check gets moved out of the fastpath, when not compiled with
CONFIG_KMEMCHECK.

This is a step towards sharing post_alloc_hook between SLUB and SLAB,
because slab_post_alloc_hook() does not perform this check before calling
kmemcheck_slab_alloc().

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemcheck.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/kmemcheck.c~mm-kmemcheck-skip-object-if-slab-allocation-failed mm/kmemcheck.c
--- a/mm/kmemcheck.c~mm-kmemcheck-skip-object-if-slab-allocation-failed
+++ a/mm/kmemcheck.c
@@ -60,6 +60,9 @@ void kmemcheck_free_shadow(struct page *
 void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
 			  size_t size)
 {
+	if (unlikely(!object)) /* Skip object if allocation failed */
+		return;
+
 	/*
 	 * Has already been memset(), which initializes the shadow for us
 	 * as well.
_

Patches currently in -mm which might be from brouer@redhat.com are


