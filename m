From: akpm@linux-foundation.org
Subject: + huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 16:16:35 -0700
Message-ID: <57044753.i0M8VNsGFBgWss+g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094AbcDEXQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs recovery: debugfs stats to complete this phase
has been added to the -mm tree.  Its filename is
     huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs recovery: debugfs stats to complete this phase

Implement the shr_stats(name) macro that has been inserted all over, to
make the success of recovery visible in debugfs.  After a little testing,
"cd /sys/kernel/debug/shmem_huge_recovery; grep . *" showed:

huge_alloced:15872
huge_failed:0
huge_too_late:0
page_created:0
page_migrate:1298014
page_off_lru:300
page_raced:0
page_teamed:6831300
page_unmigrated:3243
recov_completed:15484
recov_failed:0
recov_partial:696
recov_retried:2463
remap_another:0
remap_faulter:15484
remap_untried:0
resume_tagged:279
resume_teamed:68
swap_cached:699229
swap_entry:7530549
swap_gone:20
swap_read:6831300
work_already:43218374
work_queued:16221
work_too_late:2
work_too_many:0

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.txt |    2 
 mm/shmem.c                          |   91 ++++++++++++++++++++++++--
 2 files changed, 88 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/tmpfs.txt~huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt~huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase
+++ a/Documentation/filesystems/tmpfs.txt
@@ -224,6 +224,8 @@ shmem_pmdmapped 12582912   bytes tmpfs h
 Note: the individual pages of a huge team might be charged to different
 memcgs, but these counts assume that they are all charged to the same as head.
 
+/sys/kernel/debug/shmem_huge_recovery: recovery stats to assist development.
+
 Author:
    Christoph Rohland <cr@sap.com>, 1.12.01
 Updated:
diff -puN mm/shmem.c~huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase
+++ a/mm/shmem.c
@@ -6,8 +6,8 @@
  *		 2000-2001 Christoph Rohland
  *		 2000-2001 SAP AG
  *		 2002 Red Hat Inc.
- * Copyright (C) 2002-2011 Hugh Dickins.
- * Copyright (C) 2011 Google Inc.
+ * Copyright (C) 2002-2016 Hugh Dickins.
+ * Copyright (C) 2011-2016 Google Inc.
  * Copyright (C) 2002-2005 VERITAS Software Corporation.
  * Copyright (C) 2004 Andi Kleen, SuSE Labs
  *
@@ -788,9 +788,90 @@ struct recovery {
 	bool exposed_team;
 };
 
-#define shr_stats(x)	do {} while (0)
-#define shr_stats_add(x, n) do {} while (0)
-/* Stats implemented in a later patch */
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+
+static struct dentry *shr_debugfs_root;
+static struct {
+	/*
+	 * Just stats: no need to use atomics; and although many of these
+	 * u32s can soon overflow, debugging doesn't need them to be u64s.
+	 */
+	u32 huge_alloced;
+	u32 huge_failed;
+	u32 huge_too_late;
+	u32 page_created;
+	u32 page_migrate;
+	u32 page_off_lru;
+	u32 page_raced;
+	u32 page_teamed;
+	u32 page_unmigrated;
+	u32 recov_completed;
+	u32 recov_failed;
+	u32 recov_partial;
+	u32 recov_retried;
+	u32 remap_another;
+	u32 remap_faulter;
+	u32 remap_untried;
+	u32 resume_tagged;
+	u32 resume_teamed;
+	u32 swap_cached;
+	u32 swap_entry;
+	u32 swap_gone;
+	u32 swap_read;
+	u32 work_already;
+	u32 work_queued;
+	u32 work_too_late;
+	u32 work_too_many;
+} shmem_huge_recovery_stats;
+
+#define shr_create(x)	debugfs_create_u32(#x, S_IRUGO, shr_debugfs_root, \
+					   &shmem_huge_recovery_stats.x)
+static int __init shmem_debugfs_init(void)
+{
+	if (!debugfs_initialized())
+		return -ENODEV;
+	shr_debugfs_root = debugfs_create_dir("shmem_huge_recovery", NULL);
+	if (!shr_debugfs_root)
+		return -ENOMEM;
+
+	shr_create(huge_alloced);
+	shr_create(huge_failed);
+	shr_create(huge_too_late);
+	shr_create(page_created);
+	shr_create(page_migrate);
+	shr_create(page_off_lru);
+	shr_create(page_raced);
+	shr_create(page_teamed);
+	shr_create(page_unmigrated);
+	shr_create(recov_completed);
+	shr_create(recov_failed);
+	shr_create(recov_partial);
+	shr_create(recov_retried);
+	shr_create(remap_another);
+	shr_create(remap_faulter);
+	shr_create(remap_untried);
+	shr_create(resume_tagged);
+	shr_create(resume_teamed);
+	shr_create(swap_cached);
+	shr_create(swap_entry);
+	shr_create(swap_gone);
+	shr_create(swap_read);
+	shr_create(work_already);
+	shr_create(work_queued);
+	shr_create(work_too_late);
+	shr_create(work_too_many);
+	return 0;
+}
+fs_initcall(shmem_debugfs_init);
+
+#undef  shr_create
+#define shr_stats(x)		(shmem_huge_recovery_stats.x++)
+#define shr_stats_add(x, n)	(shmem_huge_recovery_stats.x += n)
+#else
+#define shr_stats(x)		do {} while (0)
+#define shr_stats_add(x, n)	do {} while (0)
+#endif /* CONFIG_DEBUG_FS */
 
 static bool shmem_work_still_useful(struct recovery *recovery)
 {
_

Patches currently in -mm which might be from hughd@google.com are

mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
arch-fix-has_transparent_hugepage.patch
huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m.patch
huge-tmpfs-include-shmem-freeholes-in-available-memory.patch
huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge.patch
huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team.patch
huge-tmpfs-avoid-team-pages-in-a-few-places.patch
huge-tmpfs-shrinker-to-migrate-and-free-underused-holes.patch
huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page.patch
huge-tmpfs-try_to_unmap_one-use-page_check_address_transhuge.patch
huge-tmpfs-avoid-premature-exposure-of-new-pagetable.patch
huge-tmpfs-map-shmem-by-huge-page-pmd-or-by-page-team-ptes.patch
huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure.patch
huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd.patch
huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch
huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch
huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch
huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch
huge-tmpfs-proc-pid-smaps-show-shmemhugepages.patch
huge-tmpfs-recovery-framework-for-reconstituting-huge-pages.patch
huge-tmpfs-recovery-shmem_recovery_populate-to-fill-huge-page.patch
huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch
huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch
huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch
huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask.patch

