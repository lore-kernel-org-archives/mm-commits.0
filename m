From: akpm@linux-foundation.org
Subject: + slub-consider-pfmemalloc_match-in-get_partial_node.patch added to -mm tree
Date: Tue, 04 Sep 2012 13:44:43 -0700
Message-ID: <20120904204444.51E141E0066@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37913 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab2IDUop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 16:44:45 -0400
Received: by qafl39 with SMTP id l39so589048qaf.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 13:44:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, chuck.lever@oracle.com, davem@davemloft.net, mgorman@suse.de, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: slub: consider pfmemalloc_match() in get_partial_node()
has been added to the -mm tree.  Its filename is
     slub-consider-pfmemalloc_match-in-get_partial_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: slub: consider pfmemalloc_match() in get_partial_node()

get_partial() is currently not checking pfmemalloc_match() meaning that it
is possible for pfmemalloc pages to leak to non-pfmemalloc users.  This is
a problem in the following situation.  Assume that there is a request from
normal allocation and there are no objects in the per-cpu cache and no
node-partial slab.

In this case, slab_alloc enters the slow path and new_slab_objects() is
called which may return a PFMEMALLOC page.  As the current user is not
allowed to access PFMEMALLOC page, deactivate_slab() is called ([5091b74a:
mm: slub: optimise the SLUB fast path to avoid pfmemalloc checks]) and
returns an object from PFMEMALLOC page.

Next time, when we get another request from normal allocation,
slab_alloc() enters the slow-path and calls new_slab_objects().  In
new_slab_objects(), we call get_partial() and get a partial slab which was
just deactivated but is a pfmemalloc page.  We extract one object from it
and re-deactivate.

"deactivate -> re-get in get_partial -> re-deactivate" occures repeatedly.

As a result, access to PFMEMALLOC page is not properly restricted and it
can cause a performance degradation due to frequent deactivation. 
deactivation frequently.

This patch changes get_partial_node() to take pfmemalloc_match() into
account and prevents the "deactivate -> re-get in get_partial() scenario. 
Instead, new_slab() is called.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN mm/slub.c~slub-consider-pfmemalloc_match-in-get_partial_node mm/slub.c
--- a/mm/slub.c~slub-consider-pfmemalloc_match-in-get_partial_node
+++ a/mm/slub.c
@@ -1524,12 +1524,13 @@ static inline void *acquire_slab(struct 
 }
 
 static int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain);
+static inline bool pfmemalloc_match(struct page *page, gfp_t gfpflags);
 
 /*
  * Try to allocate a partial slab from a specific node.
  */
-static void *get_partial_node(struct kmem_cache *s,
-		struct kmem_cache_node *n, struct kmem_cache_cpu *c)
+static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
+				struct kmem_cache_cpu *c, gfp_t flags)
 {
 	struct page *page, *page2;
 	void *object = NULL;
@@ -1545,9 +1546,13 @@ static void *get_partial_node(struct kme
 
 	spin_lock(&n->list_lock);
 	list_for_each_entry_safe(page, page2, &n->partial, lru) {
-		void *t = acquire_slab(s, n, page, object == NULL);
+		void *t;
 		int available;
 
+		if (!pfmemalloc_match(page, flags))
+			continue;
+
+		t = acquire_slab(s, n, page, object == NULL);
 		if (!t)
 			break;
 
@@ -1614,7 +1619,7 @@ static void *get_any_partial(struct kmem
 
 			if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
 					n->nr_partial > s->min_partial) {
-				object = get_partial_node(s, n, c);
+				object = get_partial_node(s, n, c, flags);
 				if (object) {
 					/*
 					 * Return the object even if
@@ -1643,7 +1648,7 @@ static void *get_partial(struct kmem_cac
 	void *object;
 	int searchnode = (node == NUMA_NO_NODE) ? numa_node_id() : node;
 
-	object = get_partial_node(s, get_node(s, searchnode), c);
+	object = get_partial_node(s, get_node(s, searchnode), c, flags);
 	if (object || node != NUMA_NO_NODE)
 		return object;
 
_

Patches currently in -mm which might be from js1304@gmail.com are

slab-do-clearslabpfmemalloc-for-all-pages-of-slab.patch
slab-fix-starting-index-for-finding-another-object.patch
slub-consider-pfmemalloc_match-in-get_partial_node.patch
include-net-sockh-squelch-compiler-warning-in-sk_rmem_schedule.patch
linux-next.patch

