From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:11 -0700
Message-ID: <20120611211011.6ACB3A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:58378 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2FKVKO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:14 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so250067bkt.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix
has been removed from the -mm tree.  Its filename was
     memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -350,10 +350,6 @@ static inline unsigned int pages_per_hug
 
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
@@ -468,17 +468,6 @@ static inline int mem_cgroup_hugetlb_fil
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

