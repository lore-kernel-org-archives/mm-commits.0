From: akpm@linux-foundation.org
Subject: + watchdog-update-watchdog_tresh-properly-fix.patch added to -mm
 tree
Date: Mon, 05 Aug 2013 13:24:00 -0700
Message-ID: <520009e0.4gJ8Z9RhAmYYNR07%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3HEUYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 16:24:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, festevam@gmail.com, fengguang.wu@intel.com, mhocko@suse.cz

Subject: + watchdog-update-watchdog_tresh-properly-fix.patch added to -mm tree
To: mhocko@suse.cz,fengguang.wu@intel.com,festevam@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 13:24:00 -0700


The patch titled
     Subject: include/linux/smp.h: define __smp_call_function_single for !CONFIG_SMP
has been added to the -mm tree.  Its filename is
     watchdog-update-watchdog_tresh-properly-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-update-watchdog_tresh-properly-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-update-watchdog_tresh-properly-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: include/linux/smp.h: define __smp_call_function_single for !CONFIG_SMP

This function was not needed until (watchdog: update watchdog_tresh
properly) which cannot use on_each_cpu unfortunately as
watchdog_nmi_enable relies on perf_event_alloc which is might sleep.

Export it as an alias to on_each_cpu for !CONFIG_SMP.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/smp.h~watchdog-update-watchdog_tresh-properly-fix include/linux/smp.h
--- a/include/linux/smp.h~watchdog-update-watchdog_tresh-properly-fix
+++ a/include/linux/smp.h
@@ -151,6 +151,12 @@ static inline int on_each_cpu(smp_call_f
 	return 0;
 }
 
+static inline void __smp_call_function_single(int cpuid,
+		struct call_single_data *data, int wait)
+{
+	on_each_cpu(data->func, data->info, wait);
+}
+
 /*
  * Note we still need to test the mask even for UP
  * because we actually can get an empty mask from
_

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
watchdog-update-watchdog_tresh-properly-fix.patch
mm-fix-potential-null-pointer-dereference.patch
mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
memcg-trivial-cleanups.patch
linux-next.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

