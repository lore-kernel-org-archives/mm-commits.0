From: akpm@linux-foundation.org
Subject: + memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch added to -mm tree
Date: Mon, 23 Apr 2012 15:01:05 -0700
Message-ID: <20120423224546.ABD855C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:63850 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab2DWWpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Apr 2012 18:45:49 -0400
Received: by wibhj13 with SMTP id hj13so1833wib.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Apr 2012 15:45:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix
has been added to the -mm tree.  Its filename is
     memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix

fix CONFIG_MEM_RES_CTLR_HUGETLB=n warnings

include/linux/memcontrol.h:504: warning: 'struct cgroup' declared inside parameter list
include/linux/memcontrol.h:504: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/memcontrol.h:509: warning: 'struct cgroup' declared inside parameter list

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h    |    6 +-----
 include/linux/memcontrol.h |   11 -----------
 2 files changed, 1 insertion(+), 16 deletions(-)

diff -puN include/linux/hugetlb.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix
+++ a/include/linux/hugetlb.h
@@ -337,10 +337,6 @@ static inline unsigned int pages_per_hug
 
 #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
 extern int hugetlb_force_memcg_empty(struct cgroup *cgroup);
-#else
-static inline int hugetlb_force_memcg_empty(struct cgroup *cgroup)
-{
-	return 0;
-}
 #endif
+
 #endif /* _LINUX_HUGETLB_H */
diff -puN include/linux/memcontrol.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix
+++ a/include/linux/memcontrol.h
@@ -499,17 +499,6 @@ static inline int mem_cgroup_hugetlb_fil
 	return 0;
 }
 
-static inline int
-mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
-			       struct page *page)
-{
-	return 0;
-}
-
-static inline bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup)
-{
-	return 0;
-}
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif /* _LINUX_MEMCONTROL_H */
 
_
Subject: Subject: memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

