From: akpm@linux-foundation.org
Subject: + slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch added to -mm tree
Date: Mon, 14 May 2007 21:47:28 -0700
Message-ID: <200705150447.l4F4lRoO001677@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756016AbXEOErc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 00:47:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLAB: Move two remaining SLAB specific definitions to slab_def.h
has been added to the -mm tree.  Its filename is
     slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLAB: Move two remaining SLAB specific definitions to slab_def.h
From: Christoph Lameter <clameter@sgi.com>

Two definitions remained in slab.h that are particular to the SLAB allocator.
Move to slab_def.h

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h     |    3 ---
 include/linux/slab_def.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/slab_def.h~slab-move-two-remaining-slab-specific-definitions-to-slab_defh include/linux/slab_def.h
--- a/include/linux/slab_def.h~slab-move-two-remaining-slab-specific-definitions-to-slab_defh
+++ a/include/linux/slab_def.h
@@ -109,4 +109,7 @@ found:
 
 #endif	/* CONFIG_NUMA */
 
+extern const struct seq_operations slabinfo_op;
+ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
+
 #endif	/* _LINUX_SLAB_DEF_H */
diff -puN include/linux/slab.h~slab-move-two-remaining-slab-specific-definitions-to-slab_defh include/linux/slab.h
--- a/include/linux/slab.h~slab-move-two-remaining-slab-specific-definitions-to-slab_defh
+++ a/include/linux/slab.h
@@ -230,9 +230,6 @@ extern void *__kmalloc_node_track_caller
 
 #endif /* DEBUG_SLAB */
 
-extern const struct seq_operations slabinfo_op;
-ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
-
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SLAB_H */
 
_

Patches currently in -mm which might be from clameter@sgi.com are

slub-config_large_allocs-must-consider-max_order-limit.patch
slub-config_large_allocs-must-consider-max_order-limit-fix.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
