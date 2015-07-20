From: akpm@linux-foundation.org
Subject: + mm-slub-allow-merging-when-slab_debug_free-is-set.patch added
 to -mm tree
Date: Mon, 20 Jul 2015 15:33:33 -0700
Message-ID: <55ad773d.WOlyKF5lhtAikSQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbbGTWde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 18:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
has been added to the -mm tree.  Its filename is
     mm-slub-allow-merging-when-slab_debug_free-is-set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-allow-merging-when-slab_debug_free-is-set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-allow-merging-when-slab_debug_free-is-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm/slub: allow merging when SLAB_DEBUG_FREE is set

This patch fixes creation of new kmem-caches after enabling sanity_checks
for existing mergeable kmem-caches in runtime: before that patch creation
fails because unique name in sysfs already taken by existing kmem-cache.

Unlike other debug options this doesn't change object layout and could be
enabled and disabled at any time.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slab_common.c~mm-slub-allow-merging-when-slab_debug_free-is-set mm/slab_common.c
--- a/mm/slab_common.c~mm-slub-allow-merging-when-slab_debug_free-is-set
+++ a/mm/slab_common.c
@@ -37,8 +37,7 @@ struct kmem_cache *kmem_cache;
 		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE | \
 		SLAB_FAILSLAB)
 
-#define SLAB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
-		SLAB_CACHE_DMA | SLAB_NOTRACK)
+#define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | SLAB_NOTRACK)
 
 /*
  * Merge control. If this is set then no merging of slab caches will occur.
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

mm-slub-allow-merging-when-slab_debug_free-is-set.patch
mm-slub-fix-slab-double-free-in-case-of-duplicate-sysfs-filename.patch
pagemap-check-permissions-and-capabilities-at-open-time.patch
pagemap-switch-to-the-new-format-and-do-some-cleanup.patch
pagemap-rework-hugetlb-and-thp-report.patch
pagemap-hide-physical-addresses-from-non-privileged-users.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation.patch
linux-next.patch

