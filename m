From: akpm@linux-foundation.org
Subject: [folded-merged]
 writeback-initialize-m_dirty-to-avoid-compile-warning-fix.patch removed
 from -mm tree
Date: Fri, 20 Nov 2015 15:49:37 -0800
Message-ID: <564fb191.pmcK6LGVyr9hNJaI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760588AbbKTXti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Nov 2015 18:49:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tj@kernel.org, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: writeback-initialize-m_dirty-to-avoid-compile-warning-fix
has been removed from the -mm tree.  Its filename was
     writeback-initialize-m_dirty-to-avoid-compile-warning-fix.patch

This patch was dropped because it was folded into writeback-initialize-m_dirty-to-avoid-compile-warning.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: writeback-initialize-m_dirty-to-avoid-compile-warning-fix

add comment

Cc: Tejun Heo <tj@kernel.org>
Cc: Yang Shi <yang.shi@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-initialize-m_dirty-to-avoid-compile-warning-fix mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-initialize-m_dirty-to-avoid-compile-warning-fix
+++ a/mm/page-writeback.c
@@ -1542,7 +1542,9 @@ static void balance_dirty_pages(struct a
 	for (;;) {
 		unsigned long now = jiffies;
 		unsigned long dirty, thresh, bg_thresh;
-		unsigned long m_dirty = 0, m_thresh = 0, m_bg_thresh = 0;
+		unsigned long m_dirty = 0;	/* stop bogus uninit warnings */
+		unsigned long m_thresh = 0;
+		unsigned long m_bg_thresh = 0;
 
 		/*
 		 * Unstable writes are a feature of certain networked
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
writeback-initialize-m_dirty-to-avoid-compile-warning.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
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

