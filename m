Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CC8C432C3
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E8A02074A
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbhANAAT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jan 2021 19:00:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729695AbhANAAJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Jan 2021 19:00:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26A2E2336F;
        Wed, 13 Jan 2021 23:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610581846;
        bh=1XQOmkUfUb5fVNtNpITBriPzac7g8rHzUE9zfAaveVI=;
        h=Date:From:To:Subject:From;
        b=bC7/UlvBs7M9xoUaqjEy5iDzreegQ54mswMqthGRjNk4P73dsyluCyqOHj+2T0Eso
         VR36ZB5EpIkTDYH3J7N9+jTM3I96UBN+4dLgbWzdM0JOQC2Z+ZNdhvFmGij3zPtMlG
         8Y5OZzx2OeqHbCtmFmqXMyNMdFJ6WQWOuio9kAGo=
Date:   Wed, 13 Jan 2021 15:50:45 -0800
From:   akpm@linux-foundation.org
To:     cai@redhat.com, cl@linux.com, david@redhat.com,
        iamjoonsoo.kim@lge.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vdavydov.dev@gmail.com
Subject:  +
 mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline.patch added
 to -mm tree
Message-ID: <20210113235045.SrbiXrb8R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: stop freeing kmem_cache_node structures on node offline
has been added to the -mm tree.  Its filename is
     mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: stop freeing kmem_cache_node structures on node offline

Patch series "mm, slab, slub: remove cpu and memory hotplug locks".

Some related work caused me to look at how we use get/put_mems_online()
and get/put_online_cpus() during kmem cache
creation/descruction/shrinking, and realize that it should be actually
safe to remove all of that with rather small effort (as e.g.  Michal Hocko
suspected in some of the past discussions already).  This has the benefit
to avoid rather heavy locks that have caused locking order issues already
in the past.  So this is the result, Patches 2 and 3 remove memory hotplug
and cpu hotplug locking, respectively.  Patch 1 is due to realization that
in fact some races exist despite the locks (even if not removed), but the
most sane solution is not to introduce more of them, but rather accept
some wasted memory in scenarios that should be rare anyway (full memory
hot remove), as we do the same in other contexts already.


This patch (of 3):

Commit e4f8e513c3d3 ("mm/slub: fix a deadlock in show_slab_objects()") has
fixed a problematic locking order by removing the memory hotplug lock
get/put_online_mems() from show_slab_objects().  During the discussion, it
was argued [1] that this is OK, because existing slabs on the node would
prevent a hotremove to proceed.

That's true, but per-node kmem_cache_node structures are not necessarily
allocated on the same node and may exist even without actual slab pages on
the same node.  Any path that uses get_node() directly or via
for_each_kmem_cache_node() (such as show_slab_objects()) can race with
freeing of kmem_cache_node even with the !NULL check, resulting in
use-after-free.

To that end, commit e4f8e513c3d3 argues in a comment that:

 * We don't really need mem_hotplug_lock (to hold off
 * slab_mem_going_offline_callback) here because slab's memory hot
 * unplug code doesn't destroy the kmem_cache->node[] data.

While it's true that slab_mem_going_offline_callback() doesn't free the
kmem_cache_node, the later callback slab_mem_offline_callback() actually
does, so the race and use-after-free exists.  Not just for
show_slab_objects() after commit e4f8e513c3d3, but also many other places
that are not under slab_mutex.  And adding slab_mutex locking or other
synchronization to SLUB paths such as get_any_partial() would be bad for
performance and error-prone.

The easiest solution is therefore to make the abovementioned comment true
and stop freeing the kmem_cache_node structures, accepting some wasted
memory in the full memory node removal scenario.  Analogically we also
don't free hotremoved pgdat as mentioned in [1], nor the similar per-node
structures in SLAB.  Importantly this approach will not block the
hotremove, as generally such nodes should be movable in order to succeed
hotremove in the first place, and thus the GFP_KERNEL allocated
kmem_cache_node will come from elsewhere.

[1] https://lore.kernel.org/linux-mm/20190924151147.GB23050@dhcp22.suse.cz/

Link: https://lkml.kernel.org/r/20210113131634.3671-1-vbabka@suse.cz
Link: https://lkml.kernel.org/r/20210113131634.3671-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Qian Cai <cai@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/mm/slub.c~mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline
+++ a/mm/slub.c
@@ -4221,8 +4221,6 @@ static int slab_mem_going_offline_callba
 
 static void slab_mem_offline_callback(void *arg)
 {
-	struct kmem_cache_node *n;
-	struct kmem_cache *s;
 	struct memory_notify *marg = arg;
 	int offline_node;
 
@@ -4236,21 +4234,11 @@ static void slab_mem_offline_callback(vo
 		return;
 
 	mutex_lock(&slab_mutex);
-	list_for_each_entry(s, &slab_caches, list) {
-		n = get_node(s, offline_node);
-		if (n) {
-			/*
-			 * if n->nr_slabs > 0, slabs still exist on the node
-			 * that is going down. We were unable to free them,
-			 * and offline_pages() function shouldn't call this
-			 * callback. So, we must fail.
-			 */
-			BUG_ON(slabs_node(s, offline_node));
-
-			s->node[offline_node] = NULL;
-			kmem_cache_free(kmem_cache_node, n);
-		}
-	}
+	/*
+	 * We no longer free kmem_cache_node structures here, as it would be
+	 * racy with all get_node() users, and infeasible to protect them with
+	 * slab_mutex.
+	 */
 	mutex_unlock(&slab_mutex);
 }
 
@@ -4277,6 +4265,12 @@ static int slab_mem_going_online_callbac
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
 		/*
+		 * The structure may already exist if the node was previously
+		 * onlined and offlined.
+		 */
+		if (get_node(s, nid))
+			continue;
+		/*
 		 * XXX: kmem_cache_alloc_node will fallback to other nodes
 		 *      since memory is not yet available from the node that
 		 *      is brought up.
_

Patches currently in -mm which might be from vbabka@suse.cz are

maintainers-add-myself-as-slab-allocators-maintainer.patch
mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline.patch
mm-slab-slub-stop-taking-memory-hotplug-lock.patch
mm-slab-slub-stop-taking-cpu-hotplug-lock.patch

