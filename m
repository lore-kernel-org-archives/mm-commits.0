From: akpm@linux-foundation.org
Subject: [merged]
 slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:32 -0700
Message-ID: <56e9b9bc.JtVCEjUe9NFLW6lX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbcCPTxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: clean up code for kmem cgroup support to kmem_cache_free_bulk
has been removed from the -mm tree.  Its filename was
     slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slub: clean up code for kmem cgroup support to kmem_cache_free_bulk

This change is primarily an attempt to make it easier to realize the
optimizations the compiler performs in-case CONFIG_MEMCG_KMEM is not
enabled.

Performance wise, even when CONFIG_MEMCG_KMEM is compiled in, the overhead
is zero.  This is because, as long as no process have enabled kmem cgroups
accounting, the assignment is replaced by asm-NOP operations.  This is
possible because memcg_kmem_enabled() uses a static_key_false() construct.

It also helps readability as it avoid accessing the p[] array like: p[size
- 1] which "expose" that the array is processed backwards inside helper
function build_detached_freelist().

Lastly this also makes the code more robust, in error case like passing
NULL pointers in the array.  Which were previously handled before commit
033745189b1b ("slub: add missing kmem cgroup support to
kmem_cache_free_bulk").

Fixes: 033745189b1b ("slub: add missing kmem cgroup support to kmem_cache_free_bulk")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/slub.c~slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk mm/slub.c
--- a/mm/slub.c~slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk
+++ a/mm/slub.c
@@ -2815,6 +2815,7 @@ struct detached_freelist {
 	void *tail;
 	void *freelist;
 	int cnt;
+	struct kmem_cache *s;
 };
 
 /*
@@ -2829,8 +2830,9 @@ struct detached_freelist {
  * synchronization primitive.  Look ahead in the array is limited due
  * to performance reasons.
  */
-static int build_detached_freelist(struct kmem_cache *s, size_t size,
-				   void **p, struct detached_freelist *df)
+static inline
+int build_detached_freelist(struct kmem_cache *s, size_t size,
+			    void **p, struct detached_freelist *df)
 {
 	size_t first_skipped_index = 0;
 	int lookahead = 3;
@@ -2846,8 +2848,11 @@ static int build_detached_freelist(struc
 	if (!object)
 		return 0;
 
+	/* Support for memcg, compiler can optimize this out */
+	df->s = cache_from_obj(s, object);
+
 	/* Start new detached freelist */
-	set_freepointer(s, object, NULL);
+	set_freepointer(df->s, object, NULL);
 	df->page = virt_to_head_page(object);
 	df->tail = object;
 	df->freelist = object;
@@ -2862,7 +2867,7 @@ static int build_detached_freelist(struc
 		/* df->page is always set at this point */
 		if (df->page == virt_to_head_page(object)) {
 			/* Opportunity build freelist */
-			set_freepointer(s, object, df->freelist);
+			set_freepointer(df->s, object, df->freelist);
 			df->freelist = object;
 			df->cnt++;
 			p[size] = NULL; /* mark object processed */
@@ -2881,25 +2886,20 @@ static int build_detached_freelist(struc
 	return first_skipped_index;
 }
 
-
 /* Note that interrupts must be enabled when calling this function. */
-void kmem_cache_free_bulk(struct kmem_cache *orig_s, size_t size, void **p)
+void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 {
 	if (WARN_ON(!size))
 		return;
 
 	do {
 		struct detached_freelist df;
-		struct kmem_cache *s;
