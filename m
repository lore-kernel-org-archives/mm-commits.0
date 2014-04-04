From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-avoid-isolating-pinned-pages.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:31:37 -0700
Message-ID: <533f0899.AlOyNjtIQ50EBHy0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaDDTbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, hughd@google.com, gthelen@google.com, rientjes@google.com

Subject: [merged] mm-compaction-avoid-isolating-pinned-pages.patch removed from -mm tree
To: rientjes@google.com,gthelen@google.com,hughd@google.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:37 -0700


The patch titled
     Subject: mm, compaction: avoid isolating pinned pages
has been removed from the -mm tree.  Its filename was
     mm-compaction-avoid-isolating-pinned-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: avoid isolating pinned pages

Page migration will fail for memory that is pinned in memory with, for
example, get_user_pages().  In this case, it is unnecessary to take
zone->lru_lock or isolating the page and passing it to page migration
which will ultimately fail.

This is a racy check, the page can still change from under us, but in
that case we'll just fail later when attempting to move the page.

This avoids very expensive memory compaction when faulting transparent
hugepages after pinning a lot of memory with a Mellanox driver.

On a 128GB machine and pinning ~120GB of memory, before this patch we
see the enormous disparity in the number of page migration failures
because of the pinning (from /proc/vmstat):

	compact_pages_moved 8450
	compact_pagemigrate_failed 15614415

0.05% of pages isolated are successfully migrated and explicitly
triggering memory compaction takes 102 seconds.  After the patch:

	compact_pages_moved 9197
	compact_pagemigrate_failed 7

99.9% of pages isolated are now successfully migrated in this
configuration and memory compaction takes less than one second.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/compaction.c~mm-compaction-avoid-isolating-pinned-pages mm/compaction.c
--- a/mm/compaction.c~mm-compaction-avoid-isolating-pinned-pages
+++ a/mm/compaction.c
@@ -584,6 +584,15 @@ isolate_migratepages_range(struct zone *
 			continue;
 		}
 
+		/*
+		 * Migration will fail if an anonymous page is pinned in memory,
+		 * so avoid taking lru_lock and isolating it unnecessarily in an
+		 * admittedly racy check.
+		 */
+		if (!page_mapping(page) &&
+		    page_count(page) > page_mapcount(page))
+			continue;
+
 		/* Check if it is ok to still hold the lock */
 		locked = compact_checklock_irqsave(&zone->lru_lock, &flags,
 								locked, cc);
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

