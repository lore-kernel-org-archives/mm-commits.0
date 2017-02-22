From: akpm@linux-foundation.org
Subject: [patch 025/142] slub: do not merge cache if slub_debug contains a never-merge flag
Date: Wed, 22 Feb 2017 15:40:59 -0800
Message-ID: <58ae218b.pDxOWuhgEIc2G4hE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934504AbdBVXmC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, grygoriimkd@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com

From: Grygorii Maistrenko <grygoriimkd@gmail.com>
Subject: slub: do not merge cache if slub_debug contains a never-merge flag

In case CONFIG_SLUB_DEBUG_ON=n, find_mergeable() gets debug features from
commandline but never checks if there are features from the
SLAB_NEVER_MERGE set.

As a result selected by slub_debug caches are always mergeable if they
have been created without a custom constructor set or without one of the
SLAB_* debug features on.

This moves the SLAB_NEVER_MERGE check below the flags update from
commandline to make sure it won't merge the slab cache if one of the debug
features is on.

Link: http://lkml.kernel.org/r/20170101124451.GA4740@lp-laptop-d
Signed-off-by: Grygorii Maistrenko <grygoriimkd@gmail.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/slab_common.c~slub-do-not-merge-cache-if-slub_debug-contains-a-never-merge-flag mm/slab_common.c
--- a/mm/slab_common.c~slub-do-not-merge-cache-if-slub_debug-contains-a-never-merge-flag
+++ a/mm/slab_common.c
@@ -255,7 +255,7 @@ struct kmem_cache *find_mergeable(size_t
 {
 	struct kmem_cache *s;
 
-	if (slab_nomerge || (flags & SLAB_NEVER_MERGE))
+	if (slab_nomerge)
 		return NULL;
 
 	if (ctor)
@@ -266,6 +266,9 @@ struct kmem_cache *find_mergeable(size_t
 	size = ALIGN(size, align);
 	flags = kmem_cache_flags(size, flags, name, NULL);
 
+	if (flags & SLAB_NEVER_MERGE)
+		return NULL;
+
 	list_for_each_entry_reverse(s, &slab_caches, list) {
 		if (slab_unmergeable(s))
 			continue;
_
