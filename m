From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:13 -0700
Message-ID: <20120611211013.5336AA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:58378 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2FKVKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:17 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so250067bkt.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix
has been removed from the -mm tree.  Its filename was
     memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/hugetlb.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix
+++ a/include/linux/hugetlb.h
@@ -348,8 +348,15 @@ static inline unsigned int pages_per_hug
 #define hstate_index(h) 0
 #endif
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
 extern int hugetlb_force_memcg_empty(struct cgroup *cgroup);
+#else
+static inline int hugetlb_force_memcg_empty(struct cgroup *cgroup)
+{
+	return 0;
+}
+#endif
 #endif
 
 #endif /* _LINUX_HUGETLB_H */
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

