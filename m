Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12729BE6C
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803807; cv=none; b=Zib9RzhvPAbOfkNmJOXN+9Ej1ZRcAg+DGn9DlsVomQ0kxh2/gjNu3tLJtyiJyIk3d3zmfIL73wstgIBrj3CatvvdohnoPnveCOCmVfTNtjpd7bVHWiWagJ/30LDm5ycIYOeBXsQlg5M7F+LLSxQHXiKjhxGSQ+ZghG1xEMTknCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803807; c=relaxed/simple;
	bh=eBkiWYdEl6V4dNKjmOj0hC4Hl5iMHPpNi11aiOReC6c=;
	h=Date:To:From:Subject:Message-Id; b=OhlnYDqhDC932mQLfbXZPNHV8Z2elKbL+xve42cIZWSQ/uWPmyyWgsyq/gKQa+jDUzFIEAa+jrHqTkpjDZJmYhzAv+F7/1hPGA7JUcNvjr23nJTJe6yeze0uSx/BYhgZKuR4URA8WNq9FO5l99NoiShKVEkQh5wpGPStJSZGSow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QSvNiO1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QSvNiO1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3D1C4AF51;
	Wed, 28 Aug 2024 00:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803806;
	bh=eBkiWYdEl6V4dNKjmOj0hC4Hl5iMHPpNi11aiOReC6c=;
	h=Date:To:From:Subject:From;
	b=QSvNiO1PgALH0upQiSzv5GIjfkJJUwfPBg+ePoIk0IQS/xYd4eIYcdZR5ZfC6pOJB
	 tWd8HLGgQoi8CvV3VLEyOhEau+T5CrDi80KtCMVav12A4RbJpirTXPQaenEYi1SoH9
	 RNG0Nxn4o+pjCWk8rZd8RyIH6saxgCNYhnKDygEI=
Date: Tue, 27 Aug 2024 17:10:06 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-remove-sc_timer_task.patch added to mm-nonmm-unstable branch
Message-Id: <20240828001006.DA3D1C4AF51@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: remove sc_timer_task
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-remove-sc_timer_task.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-remove-sc_timer_task.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: remove sc_timer_task
Date: Tue, 27 Aug 2024 02:41:14 +0900

After commit f5d4e04634c9 ("nilfs2: fix use-after-free of timer for log
writer thread") is applied, nilfs_construct_timeout(), which is called by
a timer and wakes up the log writer thread, is never called after the log
writer thread has terminated.

As a result, the member variable "sc_timer_task" of the "nilfs_sc_info"
structure, which was added when timer_setup() was adopted to retain a
reference to the log writer thread's task even after it had terminated, is
no longer needed, as it should be; we can simply use "sc_task" instead,
which holds a reference to the log writer thread's task for its lifetime. 
So, eliminate "sc_timer_task" by this means.

Link: https://lkml.kernel.org/r/20240826174116.5008-7-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    3 +--
 fs/nilfs2/segment.h |    2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-remove-sc_timer_task
+++ a/fs/nilfs2/segment.c
@@ -2504,7 +2504,7 @@ static void nilfs_construction_timeout(s
 {
 	struct nilfs_sc_info *sci = from_timer(sci, t, sc_timer);
 
-	wake_up_process(sci->sc_timer_task);
+	wake_up_process(sci->sc_task);
 }
 
 static void
@@ -2642,7 +2642,6 @@ static int nilfs_segctor_thread(void *ar
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int timeout = 0;
 
-	sci->sc_timer_task = current;
 	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
 	/* start sync. */
--- a/fs/nilfs2/segment.h~nilfs2-remove-sc_timer_task
+++ a/fs/nilfs2/segment.h
@@ -115,7 +115,6 @@ struct nilfs_segsum_pointer {
  * @sc_lseg_stime: Start time of the latest logical segment
  * @sc_watermark: Watermark for the number of dirty buffers
  * @sc_timer: Timer for segctord
- * @sc_timer_task: Thread woken up by @sc_timer
  * @sc_task: current thread of segctord
  */
 struct nilfs_sc_info {
@@ -172,7 +171,6 @@ struct nilfs_sc_info {
 	unsigned long		sc_watermark;
 
 	struct timer_list	sc_timer;
-	struct task_struct     *sc_timer_task;
 	struct task_struct     *sc_task;
 };
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch
nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch
nilfs2-add-missing-argument-description-for-__nilfs_error.patch
nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch
nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch
nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch
nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch
nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch
nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch
nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch
nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch
nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch
nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch
nilfs2-use-the-bits_per_long-macro.patch
nilfs2-separate-inode-type-information-from-i_state-field.patch
nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch
nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch
nilfs2-remove-sc_timer_task.patch
nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread.patch
nilfs2-refactor-nilfs_segctor_thread.patch

