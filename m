Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A03E728D6
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 18:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbjI2SpW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 14:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbjI2SpW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 14:45:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AE2199
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 11:45:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7F4C433C8;
        Fri, 29 Sep 2023 18:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696013120;
        bh=4AP1kSNBhxJB//OiriGHuxeiVsVSc9vePqeqXa1ij90=;
        h=Date:To:From:Subject:From;
        b=i5aFdTwI1Tj4xhZ6jx75j5CKIZP/iPhQV/AvZG4tFRJvkX0cC03ABYSnSQa4Retyw
         +Aa4sp+PXkCJSDn1AhIqc3BbKAbNL9NID3yLvZW9PMSE9FPwCT011SqIgp7p6vFwjo
         GcxbuWQis5ZkuVk10KuXUALb/cJtE2y9RYbp2OF4=
Date:   Fri, 29 Sep 2023 11:45:19 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-use-initializer-for-clearing-some-buffers.patch added to mm-nonmm-unstable branch
Message-Id: <20230929184519.EF7F4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: use initializer for clearing some buffers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-use-initializer-for-clearing-some-buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-use-initializer-for-clearing-some-buffers.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: use initializer for clearing some buffers
Date: Fri, 29 Sep 2023 19:30:18 +0300

Save LOC by using dark magic of initialisation instead of memset().

Those buffer aren't passed to userspace directly so padding is not
an issue.

Link: https://lkml.kernel.org/r/3821d3a2-6e10-4629-b0d5-9519d828ab72@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |   16 ++++++----------
 fs/proc/task_mmu.c |   11 +++--------
 2 files changed, 9 insertions(+), 18 deletions(-)

--- a/fs/proc/base.c~proc-use-initializer-for-clearing-some-buffers
+++ a/fs/proc/base.c
@@ -1153,11 +1153,10 @@ err_unlock:
 static ssize_t oom_adj_write(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
-	char buffer[PROC_NUMBUF];
+	char buffer[PROC_NUMBUF] = {};
 	int oom_adj;
 	int err;
 
-	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count)) {
@@ -1213,11 +1212,10 @@ static ssize_t oom_score_adj_read(struct
 static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 					size_t count, loff_t *ppos)
 {
-	char buffer[PROC_NUMBUF];
+	char buffer[PROC_NUMBUF] = {};
 	int oom_score_adj;
 	int err;
 
-	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count)) {
@@ -1358,13 +1356,13 @@ static ssize_t proc_fault_inject_write(s
 			const char __user * buf, size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
-	char buffer[PROC_NUMBUF];
+	char buffer[PROC_NUMBUF] = {};
 	int make_it_fail;
 	int rv;
 
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	memset(buffer, 0, sizeof(buffer));
+
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
@@ -1509,11 +1507,10 @@ sched_autogroup_write(struct file *file,
 {
 	struct inode *inode = file_inode(file);
 	struct task_struct *p;
-	char buffer[PROC_NUMBUF];
+	char buffer[PROC_NUMBUF] = {};
 	int nice;
 	int err;
 
-	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
@@ -1666,10 +1663,9 @@ static ssize_t comm_write(struct file *f
 {
 	struct inode *inode = file_inode(file);
 	struct task_struct *p;
-	char buffer[TASK_COMM_LEN];
+	char buffer[TASK_COMM_LEN] = {};
 	const size_t maxlen = sizeof(buffer) - 1;
 
-	memset(buffer, 0, sizeof(buffer));
 	if (copy_from_user(buffer, buf, count > maxlen ? maxlen : count))
 		return -EFAULT;
 
--- a/fs/proc/task_mmu.c~proc-use-initializer-for-clearing-some-buffers
+++ a/fs/proc/task_mmu.c
@@ -851,9 +851,7 @@ static void __show_smap(struct seq_file
 static int show_smap(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
-	struct mem_size_stats mss;
-
-	memset(&mss, 0, sizeof(mss));
+	struct mem_size_stats mss = {};
 
 	smap_gather_stats(vma, &mss, 0);
 
@@ -879,7 +877,7 @@ static int show_smap(struct seq_file *m,
 static int show_smaps_rollup(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct mem_size_stats mss;
+	struct mem_size_stats mss = {};
 	struct mm_struct *mm = priv->mm;
 	struct vm_area_struct *vma;
 	unsigned long vma_start = 0, last_vma_end = 0;
@@ -895,8 +893,6 @@ static int show_smaps_rollup(struct seq_
 		goto out_put_task;
 	}
 
-	memset(&mss, 0, sizeof(mss));
-
 	ret = mmap_read_lock_killable(mm);
 	if (ret)
 		goto out_put_mm;
@@ -1248,14 +1244,13 @@ static ssize_t clear_refs_write(struct f
 				size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
-	char buffer[PROC_NUMBUF];
+	char buffer[PROC_NUMBUF] = {};
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	enum clear_refs_types type;
 	int itype;
 	int rv;
 
-	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
_

Patches currently in -mm which might be from adobriyan@gmail.com are

extract-and-use-file_line-macro.patch
proc-use-initializer-for-clearing-some-buffers.patch
proc-save-loc-by-using-while-loop.patch

