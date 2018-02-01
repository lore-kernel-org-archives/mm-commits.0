From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-remove-redundant-assignments-for-slab_state.patch removed from -mm
 tree
Date: Thu, 01 Feb 2018 11:30:15 -0800
Message-ID: <20180201193015.SinWFhDhw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57170 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbeBATaR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:30:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, osalvador@techadventures.net, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: mm/slab.c: remove redundant assignments for slab_state
has been removed from the -mm tree.  Its filename was
     mm-slab-remove-redundant-assignments-for-slab_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@techadventures.net>
Subject: mm/slab.c: remove redundant assignments for slab_state

slab_state is being set to "UP" in create_kmalloc_caches(), and later on
we set it again in kmem_cache_init_late(), but slab_state does not change
in the meantime.

Remove the redundant assignment from kmem_cache_init_late().

And unless I overlooked anything, the same goes for "slab_state = FULL". 
slab_state is set to "FULL" in kmem_cache_init_late(), but it is later
being set again in cpucache_init(), which gets called from
do_initcall_level().  So remove the assignment from cpucache_init() as
well.

Link: http://lkml.kernel.org/r/20171215134452.GA1920@techadventures.net
Signed-off-by: Oscar Salvador <osalvador@techadventures.net>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/slab.c~mm-slab-remove-redundant-assignments-for-slab_state mm/slab.c
--- a/mm/slab.c~mm-slab-remove-redundant-assignments-for-slab_state
+++ a/mm/slab.c
@@ -1316,8 +1316,6 @@ void __init kmem_cache_init_late(void)
 {
 	struct kmem_cache *cachep;
 
-	slab_state = UP;
