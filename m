From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch removed from
 -mm tree
Date: Wed, 31 Jan 2018 14:51:36 -0800
Message-ID: <5a724878.y5gRTxi/O+9qInsu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751650AbeAaWvh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 17:51:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@kernel.org, sergey.senozhatsky.work@gmail.com, surenb@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-terminate-shrink_slab-loop-if-signal-is-pending-fix
has been removed from the -mm tree.  Its filename was
     mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch

This patch was dropped because it was folded into mm-terminate-shrink_slab-loop-if-signal-is-pending.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-terminate-shrink_slab-loop-if-signal-is-pending-fix

fix build, per Sergey

Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-terminate-shrink_slab-loop-if-signal-is-pending-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-terminate-shrink_slab-loop-if-signal-is-pending-fix
+++ a/mm/vmscan.c
@@ -493,7 +493,7 @@ static unsigned long shrink_slab(gfp_t g
 		 * We are about to die and free our memory.
 		 * Stop shrinking which might delay signal handling.
 		 */
-		if (unlikely(fatal_signal_pending(current))
+		if (unlikely(fatal_signal_pending(current)))
 			break;
 
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ocfs2-try-to-reuse-extent-block-in-dealloc-without-meta_alloc-fix-fix.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
tools-vm-new-option-to-specify-kpageflags-file-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch

