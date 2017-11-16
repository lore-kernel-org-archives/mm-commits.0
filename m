From: akpm@linux-foundation.org
Subject: [folded-merged]
 slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch removed from -mm
 tree
Date: Wed, 15 Nov 2017 16:50:37 -0800
Message-ID: <5a0ce0dd.c4TkmKw0vQRpx6H0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934016AbdKPAuj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 19:50:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab-slub-slob-convert-slab_flags_t-to-32-bit-fix
has been removed from the -mm tree.  Its filename was
     slab-slub-slob-convert-slab_flags_t-to-32-bit-fix.patch

This patch was dropped because it was folded into slab-slub-slob-convert-slab_flags_t-to-32-bit.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slab-slub-slob-convert-slab_flags_t-to-32-bit-fix

fix printk warning

mm/slub.c:3660: warning: format '%lx' expects type 'long unsigned int', but argument 7 has type 'slab_flags_t'

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slab-slub-slob-convert-slab_flags_t-to-32-bit-fix mm/slub.c
--- a/mm/slub.c~slab-slub-slob-convert-slab_flags_t-to-32-bit-fix
+++ a/mm/slub.c
@@ -3657,7 +3657,7 @@ error:
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slab %s size=%lu realsize=%u order=%u offset=%u flags=%lx\n",
 		      s->name, (unsigned long)s->size, s->size,
-		      oo_order(s->oo), s->offset, flags);
+		      oo_order(s->oo), s->offset, (unsigned long)flags);
 	return -EINVAL;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slab-slub-slob-convert-slab_flags_t-to-32-bit.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
mm-simplify-nodemask-printing-fix.patch
mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix.patch

