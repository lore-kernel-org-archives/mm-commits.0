From: akpm@linux-foundation.org
Subject: [folded-merged]
 slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch removed
 from -mm tree
Date: Fri, 20 Nov 2015 15:50:23 -0800
Message-ID: <564fb1bf.BM3qivSGCzTu4OhS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761280AbbKTXuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Nov 2015 18:50:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexander.h.duyck@redhat.com, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub-optimize-bulk-slowpath-free-by-detached-freelist-fix
has been removed from the -mm tree.  Its filename was
     slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch

This patch was dropped because it was folded into slub-optimize-bulk-slowpath-free-by-detached-freelist.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slub-optimize-bulk-slowpath-free-by-detached-freelist-fix

BUG_ON -> WARN_ON;return

Cc: Alexander Duyck <alexander.h.duyck@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-optimize-bulk-slowpath-free-by-detached-freelist-fix mm/slub.c
--- a/mm/slub.c~slub-optimize-bulk-slowpath-free-by-detached-freelist-fix
+++ a/mm/slub.c
@@ -2882,7 +2882,8 @@ static int build_detached_freelist(struc
 /* Note that interrupts must be enabled when calling this function. */
 void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 {
-	BUG_ON(!size);
+	if (WARN_ON(!size))
+		return;
 
 	do {
 		struct detached_freelist df;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
a.patch
b.patch

