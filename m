From: akpm@linux-foundation.org
Subject: + mm-slab-remove-redundant-assignments-for-slab_state.patch added to -mm tree
Date: Fri, 15 Dec 2017 14:20:01 -0800
Message-ID: <5a344a91.U+qA+hTxXG87oGz7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58280 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756733AbdLOWUE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Dec 2017 17:20:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osalvador@techadventures.net, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: remove redundant assignments for slab_state
has been added to the -mm tree.  Its filename is
     mm-slab-remove-redundant-assignments-for-slab_state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-remove-redundant-assignments-for-slab_state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-remove-redundant-assignments-for-slab_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
