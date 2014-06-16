From: akpm@linux-foundation.org
Subject: [withdrawn] memcg-mm-introduce-lowlimit-reclaim-fix2patch.patch
 removed from -mm tree
Date: Mon, 16 Jun 2014 15:35:01 -0700
Message-ID: <539f7115.JpbfN4YfG9LgqU7u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaFPWfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 18:35:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, hughd@google.com


The patch titled
     Subject: memcg-mm-introduce-lowlimit-reclaim-fix2.patch
has been removed from the -mm tree.  Its filename was
     memcg-mm-introduce-lowlimit-reclaim-fix2patch.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg-mm-introduce-lowlimit-reclaim-fix2.patch

mem_cgroup_within_guarantee() oopses in _raw_spin_lock_irqsave() when
booted with cgroup_disable=memory.  Fix that in the obvious inelegant way
for now - though I hope we are moving towards a world in which almost all
of the mem_cgroup_disabled() tests will vanish, with a root_mem_cgroup
which can handle the basics even when disabled.

I bet there's a neater way of doing this, rearranging the loop (and we
shall want to avoid spinlocking on root_mem_cgroup when we reach that new
world), but that's the kind of thing I'd get wrong in a hurry!

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memcontrol.c~memcg-mm-introduce-lowlimit-reclaim-fix2patch mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mm-introduce-lowlimit-reclaim-fix2patch
+++ a/mm/memcontrol.c
@@ -2792,6 +2792,9 @@ static struct mem_cgroup *mem_cgroup_loo
 bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 		struct mem_cgroup *root)
 {
+	if (mem_cgroup_disabled())
+		return false;
+
 	do {
 		if (!res_counter_low_limit_excess(&memcg->res))
 			return true;
_

Patches currently in -mm which might be from hughd@google.com are

mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
madvise-cleanup-swapin_walk_pmd_entry.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mincore-apply-page-table-walker-on-do_mincore.patch
list-use-argument-hlist_add_after-names-from-rcu-variant.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
klist-use-same-naming-scheme-as-hlist-for-klist_add_after.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

