From: akpm@linux-foundation.org
Subject: +
 mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch added to
 -mm tree
Date: Wed, 17 Jun 2020 20:31:44 -0700
Message-ID: <20200618033144.K8zpt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726854AbgFRDbp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 23:31:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, guro@fb.com, dennis@kernel.org, cl@linux.com, akpm@linux-foundation.org


The patch titled
     Subject: mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix
has been added to the -mm tree.  Its filename is
     mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix

fix CONFIG_MEMCG_KMEM=n build errors and warning

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/percpu.c~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix
+++ a/mm/percpu.c
@@ -1438,7 +1438,9 @@ static struct pcpu_chunk *pcpu_alloc_chu
 
 	return chunk;
 
+#ifdef CONFIG_MEMCG_KMEM
 objcg_fail:
+#endif
 	pcpu_mem_free(chunk->md_blocks);
 md_blocks_fail:
 	pcpu_mem_free(chunk->bound_map);
@@ -1630,13 +1632,13 @@ static void pcpu_memcg_free_hook(struct
 }
 
 #else /* CONFIG_MEMCG_KMEM */
-static enum pcpu_chunk_type pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
-						     struct mem_cgroup **memcgp)
+static enum pcpu_chunk_type
+pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp, struct obj_cgroup **objcgp)
 {
 	return PCPU_CHUNK_ROOT;
 }
 
-static void pcpu_memcg_post_alloc_hook(struct mem_cgroup *memcg,
+static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg, 
 				       struct pcpu_chunk *chunk, int off,
 				       size_t size)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
