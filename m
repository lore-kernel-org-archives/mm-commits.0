From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb_cgroup-use-lockdep_assert_held-rather-than-spin_is_locked.patch
 removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:31 -0700
Message-ID: <5407568b.uVn4PuWe4pEdKfhY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbaICR5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: use lockdep_assert_held rather than spin_is_locked
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-use-lockdep_assert_held-rather-than-spin_is_locked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: hugetlb_cgroup: use lockdep_assert_held rather than spin_is_locked

spin_lock may be an empty struct for !SMP configurations and so
arch_spin_is_locked may return unconditional 0 and trigger the VM_BUG_ON
even when the lock is held.

Replace spin_is_locked by lockdep_assert_held.  We will not BUG anymore
but it is questionable whether crashing makes a lot of sense in the
uncharge path.  Uncharge happens after the last page reference was
released so nobody should touch the page and the function doesn't update
any shared state except for res counter which uses synchronization of its
own.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb_cgroup.c~hugetlb_cgroup-use-lockdep_assert_held-rather-than-spin_is_locked mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-use-lockdep_assert_held-rather-than-spin_is_locked
+++ a/mm/hugetlb_cgroup.c
@@ -217,7 +217,7 @@ void hugetlb_cgroup_uncharge_page(int id
 
 	if (hugetlb_cgroup_disabled())
 		return;
-	VM_BUG_ON(!spin_is_locked(&hugetlb_lock));
+	lockdep_assert_held(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(page);
 	if (unlikely(!h_cg))
 		return;
_

Patches currently in -mm which might be from mhocko@suse.cz are

introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch

