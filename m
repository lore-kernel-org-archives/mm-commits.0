From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:56 -0700
Message-ID: <533f0870.BZrOVQ6JIr5fBFf8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaDDTa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, rientjes@google.com

Subject: [merged] mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch removed from -mm tree
To: rientjes@google.com,mgorman@suse.de,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:56 -0700


The patch titled
     Subject: mm, compaction: ignore pageblock skip when manually invoking compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: ignore pageblock skip when manually invoking compaction

The cached pageblock hint should be ignored when triggering compaction
through /proc/sys/vm/compact_memory so all eligible memory is isolated. 
Manually invoking compaction is known to be expensive, there's no need to
skip pageblocks based on heuristics (mainly for debugging).

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/compaction.c~mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction
+++ a/mm/compaction.c
@@ -1186,6 +1186,7 @@ static void compact_node(int nid)
 	struct compact_control cc = {
 		.order = -1,
 		.sync = true,
+		.ignore_skip_hint = true,
 	};
 
 	__compact_pgdat(NODE_DATA(nid), &cc);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
mmnuma-reorganize-change_pmd_range.patch
mmnuma-reorganize-change_pmd_range-fix.patch
move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-compaction-determine-isolation-mode-only-once.patch
mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch
mm-utilc-add-kstrimdup.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch

