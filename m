From: akpm@linux-foundation.org
Subject: + mm-kmemcheck-skip-object-if-slab-allocation-failed.patch added
 to -mm tree
Date: Tue, 26 Jan 2016 19:29:09 -0800
Message-ID: <56a83985.wsZy4iokgvlBXnLA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbcA0D3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 22:29:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemcheck skip object if slab allocation failed
has been added to the -mm tree.  Its filename is
     mm-kmemcheck-skip-object-if-slab-allocation-failed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemcheck-skip-object-if-slab-allocation-failed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemcheck-skip-object-if-slab-allocation-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch
mm-slab-move-slub-alloc-hooks-to-common-mm-slabh.patch
mm-fault-inject-take-over-bootstrap-kmem_cache-check.patch
slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch
mm-kmemcheck-skip-object-if-slab-allocation-failed.patch
slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch
slab-implement-bulk-alloc-in-slab-allocator.patch
slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch
slab-implement-bulk-free-in-slab-allocator.patch
mm-new-api-kfree_bulk-for-slabslub-allocators.patch
mm-fix-some-spelling.patch

