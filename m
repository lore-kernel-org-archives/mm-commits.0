From: akpm@linux-foundation.org
Subject: [patch 022/126] slab: make GFP_SLAB_BUG_MASK information more
 human readable
Date: Tue, 26 Jul 2016 15:22:02 -0700
Message-ID: <5797e28a.bBRVSjkCxAaBXYe+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758AbcGZWWE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:22:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, sergey.senozhatsky.work@gmail.com

From: Michal Hocko <mhocko@suse.com>
Subject: slab: make GFP_SLAB_BUG_MASK information more human readable

printk offers %pGg for quite some time so let's use it to get a human
readable list of invalid flags.

The original output would be
[  429.191962] gfp: 2

after the change
[  429.191962] Unexpected gfp: 0x2 (__GFP_HIGHMEM)

Link: http://lkml.kernel.org/r/1465548200-11384-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 ++-
 mm/slub.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-make-gfp_slab_bug_mask-information-more-human-readable mm/slab.c
--- a/mm/slab.c~slab-make-gfp_slab_bug_mask-information-more-human-readable
+++ a/mm/slab.c
@@ -2686,7 +2686,8 @@ static struct page *cache_grow_begin(str
 	 * critical path in kmem_cache_alloc().
 	 */
 	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
-		pr_emerg("gfp: %u\n", flags & GFP_SLAB_BUG_MASK);
+		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
+		pr_emerg("Unexpected gfp: %#x (%pGg)\n", invalid_mask, &invalid_mask);
 		BUG();
 	}
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
diff -puN mm/slub.c~slab-make-gfp_slab_bug_mask-information-more-human-readable mm/slub.c
--- a/mm/slub.c~slab-make-gfp_slab_bug_mask-information-more-human-readable
+++ a/mm/slub.c
@@ -1612,7 +1612,8 @@ out:
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	if (unlikely(flags & GFP_SLAB_BUG_MASK)) {
-		pr_emerg("gfp: %u\n", flags & GFP_SLAB_BUG_MASK);
+		gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
+		pr_emerg("Unexpected gfp: %#x (%pGg)\n", invalid_mask, &invalid_mask);
 		BUG();
 	}
 
_
