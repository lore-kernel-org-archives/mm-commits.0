From: akpm@linux-foundation.org
Subject: [to-be-updated]
 huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch removed from -mm tree
Date: Thu, 21 Apr 2016 13:47:00 -0700
Message-ID: <57193c44.NXO4Eiq9ZNy28UIK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbcDUUrB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:47:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs recovery: debugfs stats to complete this phase
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch

This patch was dropped because an updated version will be merged

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

huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch

