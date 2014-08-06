From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch removed from -mm tree
Date: Wed, 06 Aug 2014 15:46:51 -0700
Message-ID: <53e2b05b.5WoNV0B2OqfxNCyf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:57036 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaHFWqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:46:52 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so839937pab.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:46:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, edumazet@google.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmallocc-add-a-schedule-point-to-vmalloc-fix
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch

This patch was dropped because it was folded into mm-vmallocc-add-a-schedule-point-to-vmalloc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmallocc-add-a-schedule-point-to-vmalloc-fix

only do it for __GFP_WAIT, per David

Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmallocc-add-a-schedule-point-to-vmalloc-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-add-a-schedule-point-to-vmalloc-fix
+++ a/mm/vmalloc.c
@@ -1602,7 +1602,8 @@ static void *__vmalloc_area_node(struct
 			goto fail;
 		}
 		area->pages[i] = page;
-		cond_resched();
+		if (gfp_mask & __GFP_WAIT)
+			cond_resched();
 	}
 
 	if (map_vm_area(area, prot, &pages))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions.patch
kbuild-explain-stack-protector-strong-config-logic.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

