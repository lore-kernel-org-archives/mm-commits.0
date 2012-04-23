From: akpm@linux-foundation.org
Subject: [obsolete] kvm-dont-call-mmu_shrinker-w-o-used_mmu_pages.patch removed from -mm tree
Date: Mon, 23 Apr 2012 14:36:16 -0700
Message-ID: <20120423213616.32F3CA018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:41095 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2DWVgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Apr 2012 17:36:18 -0400
Received: by wejx9 with SMTP id x9so74wej.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Apr 2012 14:36:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, avi@redhat.com, dan.magenheimer@oracle.com, dhillf@gmail.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, mtosatti@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kvm: don't call mmu_shrinker w/o used_mmu_pages
has been removed from the -mm tree.  Its filename was
     kvm-dont-call-mmu_shrinker-w-o-used_mmu_pages.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ying Han <yinghan@google.com>
Subject: kvm: don't call mmu_shrinker w/o used_mmu_pages

mmu_shrink() is heavy by itself by iterating all kvms and holding the
kvm_lock.  spotted the code w/ Rik during LSF, and it turns out we don't
need to call the shrinker if nothing to shrink.

Signed-off-by: Ying Han <yinghan@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: xAvi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN arch/x86/kvm/mmu.c~kvm-dont-call-mmu_shrinker-w-o-used_mmu_pages arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~kvm-dont-call-mmu_shrinker-w-o-used_mmu_pages
+++ a/arch/x86/kvm/mmu.c
@@ -189,6 +189,11 @@ static u64 __read_mostly shadow_mmio_mas
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
 
+static inline int get_kvm_total_used_mmu_pages()
+{
+	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
+}
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask)
 {
 	shadow_mmio_mask = mmio_mask;
@@ -3964,6 +3969,9 @@ static int mmu_shrink(struct shrinker *s
 	if (nr_to_scan == 0)
 		goto out;
 
+	if (!get_kvm_total_used_mmu_pages())
+		return 0;
+
 	raw_spin_lock(&kvm_lock);
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
@@ -3990,7 +3998,7 @@ static int mmu_shrink(struct shrinker *s
 	raw_spin_unlock(&kvm_lock);
 
 out:
-	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
+	return get_kvm_total_used_mmu_pages();
 }
 
 static struct shrinker mmu_shrinker = {
_

Patches currently in -mm which might be from yinghan@google.com are

mm-fix-up-the-vmscan-stat-in-vmstat.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch

