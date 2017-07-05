From: akpm@linux-foundation.org
Subject: +
 mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack.patch
 added to -mm tree
Date: Wed, 05 Jul 2017 14:19:37 -0700
Message-ID: <595d57e9.r6TB55HzZdYHnuMm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751744AbdGEVTi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 17:19:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, ben@decadent.org.uk, hughd@google.com, oleg@redhat.com, riel@redhat.com, torvalds@linux-foundation.org, vbabka@suse.cz, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: do not blow on PROT_NONE MAP_FIXED holes in the stack
has been added to the -mm tree.  Its filename is
     mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm/mmap.c: do not blow on PROT_NONE MAP_FIXED holes in the stack

"mm: enlarge stack guard gap" has introduced a regression in some rust and
Java environments which are trying to implement their own stack guard
page.  They are punching a new MAP_FIXED mapping inside the existing stack
Vma.

This will confuse expand_{downwards,upwards} into thinking that the stack
expansion would in fact get us too close to an existing non-stack vma
which is a correct behavior wrt.  safety.  It is a real regression on the
other hand.  Let's work around the problem by considering PROT_NONE
mapping as a part of the stack.  This is a gros hack but overflowing to
such a mapping would trap anyway an we only can hope that usespace knows
what it is doing and handle it propely.

Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
Link: http://lkml.kernel.org/r/20170705182849.GA18027@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Debugged-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack mm/mmap.c
--- a/mm/mmap.c~mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack
+++ a/mm/mmap.c
@@ -2244,7 +2244,8 @@ int expand_upwards(struct vm_area_struct
 		gap_addr = TASK_SIZE;
 
 	next = vma->vm_next;
-	if (next && next->vm_start < gap_addr) {
+	if (next && next->vm_start < gap_addr &&
+			(next->vm_flags & (VM_WRITE|VM_READ|VM_EXEC))) {
 		if (!(next->vm_flags & VM_GROWSUP))
 			return -ENOMEM;
 		/* Check that both stack segments have the same anon_vma? */
@@ -2328,7 +2329,8 @@ int expand_downwards(struct vm_area_stru
 	if (gap_addr > address)
 		return -ENOMEM;
 	prev = vma->vm_prev;
-	if (prev && prev->vm_end > gap_addr) {
+	if (prev && prev->vm_end > gap_addr &&
+			(prev->vm_flags & (VM_WRITE|VM_READ|VM_EXEC))) {
 		if (!(prev->vm_flags & VM_GROWSDOWN))
 			return -ENOMEM;
 		/* Check that both stack segments have the same anon_vma? */
_

Patches currently in -mm which might be from mhocko@suse.com are

fs-file-replace-alloc_fdmem-with-kvmalloc-alternative.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes-fix.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-fix-mmop_online_keep-behavior.patch
mm-memory_hotplug-do-not-assume-zone_normal-is-default-kernel-zone.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-adaptive-hash-table-scaling-fix.patch
mm-memory_hotplug-drop-artificial-restriction-on-online-offline.patch
mm-memory_hotplug-drop-config_movable_node.patch
mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch
mm-make-pr_set_thp_disable-immediately-active.patch
mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration.patch
mm-unify-new_node_page-and-alloc_migrate_target.patch
mm-memcg-fix-potential-undefined-behavior-in-mem_cgroup_event_ratelimit.patch
mm-hugetlb-unclutter-hugetlb-allocation-layers.patch
hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch
mm-hugetlb-soft_offline-use-new_page_nodemask-for-soft-offline-migration.patch
mm-document-highmem_is_dirtyable-sysctl.patch
mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack.patch
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch
mips-do-not-use-__gfp_repeat-for-order-0-request.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

