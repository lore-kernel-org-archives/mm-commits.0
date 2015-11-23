From: akpm@linux-foundation.org
Subject: [merged]
 slub-add-missing-kmem-cgroup-support-to-kmem_cache_free_bulk.patch removed
 from -mm tree
Date: Mon, 23 Nov 2015 12:15:44 -0800
Message-ID: <565373f0.oaJUftTuoqyV52OG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbbKWUPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: add missing kmem cgroup support to kmem_cache_free_bulk
has been removed from the -mm tree.  Its filename was
     slub-add-missing-kmem-cgroup-support-to-kmem_cache_free_bulk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slub: add missing kmem cgroup support to kmem_cache_free_bulk

Initial implementation missed support for kmem cgroup support in
kmem_cache_free_bulk() call, add this.

If CONFIG_MEMCG_KMEM is not enabled, the compiler should be smart enough
to not add any asm code.

Incoming bulk free objects can belong to different kmem cgroups, and
object free call can happen at a later point outside memcg context.  Thus,
we need to keep the orig kmem_cache, to correctly verify if a memcg object
match against its "root_cache" (s->memcg_params.root_cache).

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-add-missing-kmem-cgroup-support-to-kmem_cache_free_bulk mm/slub.c
--- a/mm/slub.c~slub-add-missing-kmem-cgroup-support-to-kmem_cache_free_bulk
+++ a/mm/slub.c
@@ -2887,13 +2887,17 @@ static int build_detached_freelist(struc
 
 
 /* Note that interrupts must be enabled when calling this function. */
-void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
+void kmem_cache_free_bulk(struct kmem_cache *orig_s, size_t size, void **p)
 {
 	if (WARN_ON(!size))
 		return;
 
 	do {
 		struct detached_freelist df;
+		struct kmem_cache *s;
+
+		/* Support for memcg */
+		s = cache_from_obj(orig_s, p[size - 1]);
 
 		size = build_detached_freelist(s, size, p, &df);
 		if (unlikely(!df.page))
_

Patches currently in -mm which might be from brouer@redhat.com are


