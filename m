From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch removed from -mm tree
Date: Tue, 10 Feb 2015 14:00:45 -0800
Message-ID: <54da7f8d.gbbNPWrWR5Q8Blg3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbbBJWAq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Feb 2015 17:00:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: optimize alloc/free fastpath by removing preemption on/off
has been removed from the -mm tree.  Its filename was
     mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch

This patch was dropped because it was folded into mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slub: optimize alloc/free fastpath by removing preemption on/off

Change from v2:
- use raw_cpu_ptr() rather than this_cpu_ptr() to avoid warning from
 preemption debug check since this is intended behaviour
- fix typo alogorithm -> algorithm

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3 mm/slub.c
--- a/mm/slub.c~mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3
+++ a/mm/slub.c
@@ -2404,11 +2404,11 @@ redo:
 	 */
 	do {
 		tid = this_cpu_read(s->cpu_slab->tid);
-		c = this_cpu_ptr(s->cpu_slab);
+		c = raw_cpu_ptr(s->cpu_slab);
 	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
 
 	/*
-	 * Irqless object alloc/free alogorithm used here depends on sequence
+	 * Irqless object alloc/free algorithm used here depends on sequence
 	 * of fetching cpu_slab's data. tid should be fetched before anything
 	 * on c to guarantee that object and page associated with previous tid
 	 * won't be used with current tid. If we fetch tid first, object and
@@ -2670,7 +2670,7 @@ redo:
 	 */
 	do {
 		tid = this_cpu_read(s->cpu_slab->tid);
-		c = this_cpu_ptr(s->cpu_slab);
+		c = raw_cpu_ptr(s->cpu_slab);
 	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
 
 	/* Same with comment on barrier() in slab_alloc_node() */
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
mm-dont-use-compound_head-in-virt_to_head_page.patch
mm-dont-use-compound_head-in-virt_to_head_page-v3.patch
mm-slab_common-use-kmem_cache_free.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-vmstatc-fix-cleanup-ifdefs-fix-2.patch

