From: akpm@linux-foundation.org
Subject: +
 mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch
 added to -mm tree
Date: Tue, 04 Mar 2014 14:31:56 -0800
Message-ID: <5316545c.J3rlIpILbuUEkwb0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbaCDWb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:31:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, minchan@kernel.org, hughd@google.com, hannes@cmpxchg.org

Subject: + mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch added to -mm tree
To: hannes@cmpxchg.org,hughd@google.com,minchan@kernel.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:31:56 -0800


The patch titled
     Subject: mm + fs: prepare for non-page entries in page cache radix trees fix
has been added to the -mm tree.  Its filename is
     mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm + fs: prepare for non-page entries in page cache radix trees fix

__pagevec_lookup() stores exceptional entries in the pagevec.  They must
be pruned before passing the pagevec along to pagevec_release() or the
kernel crashes when these non-page pointers reach the page allocator.

Add a missing pagevec_remove_exceptionals() in the truncate path.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/truncate.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix mm/truncate.c
--- a/mm/truncate.c~mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix
+++ a/mm/truncate.c
@@ -340,6 +340,7 @@ void truncate_inode_pages_range(struct a
 			continue;
 		}
 		if (index == start && indices[0] >= end) {
+			pagevec_remove_exceptionals(&pvec);
 			pagevec_release(&pvec);
 			break;
 		}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

swapoff-tmpfs-radix_tree-remember-to-rcu_read_unlock.patch
memcg-fix-endless-loop-in-__mem_cgroup_iter_next.patch
memcg-reparent-charges-of-children-before-processing-parent.patch
mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
lib-radix_tree-tree-node-interface-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
mm-fix-gfp_thisnode-callers-and-clarify.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

