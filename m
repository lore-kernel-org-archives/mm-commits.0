Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2AFEB64DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 18:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjGLSZ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 14:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjGLSZ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 14:25:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB781FEC
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 11:25:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79E0D61898
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 18:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21ACC433C7;
        Wed, 12 Jul 2023 18:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689186322;
        bh=drgFwaek/UgnRKflX3gjh2Wr/6+wu+L5DgL0Z3IDiOw=;
        h=Date:To:From:Subject:From;
        b=u/1zvBrw/v9F5xSZPtJLoTj5a9EXTV3GICHbeFCDvLlaG/rUvLNCQ8weWOwJVV+bj
         pjGtIy5S3+uSZ9Ak6HK9+ju0HYPW7qUqBPT5S7gbbaC8fMUp0qklwEshK1n7HkmAbD
         ZmBfCcF7/XcfsbCkna/Sxi108IvL962/VBRhePiY=
Date:   Wed, 12 Jul 2023 11:25:22 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-vma_is_stack-and-vma_is_heap.patch added to mm-unstable branch
Message-Id: <20230712182522.D21ACC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vma_is_stack() and vma_is_heap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-vma_is_stack-and-vma_is_heap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-vma_is_stack-and-vma_is_heap.patch

This patch will later appear in the mm-unstable branch at
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use vma_is_stack() and vma_is_heap()
Date: Wed, 12 Jul 2023 22:38:28 +0800

Use the helpers to simplify code.

Link: https://lkml.kernel.org/r/20230712143831.120701-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c   |   24 ++++--------------------
 fs/proc/task_nommu.c |   15 +--------------
 2 files changed, 5 insertions(+), 34 deletions(-)

--- a/fs/proc/task_mmu.c~mm-use-vma_is_stack-and-vma_is_heap
+++ a/fs/proc/task_mmu.c
@@ -236,21 +236,6 @@ static int do_maps_open(struct inode *in
 				sizeof(struct proc_maps_private));
 }
 
-/*
- * Indicate if the VMA is a stack for the given task; for
- * /proc/PID/maps that is the stack of the main task.
- */
-static int is_stack(struct vm_area_struct *vma)
-{
-	/*
-	 * We make no effort to guess what a given thread considers to be
-	 * its "stack".  It's not even well-defined for programs written
-	 * languages like Go.
-	 */
-	return vma->vm_start <= vma->vm_mm->start_stack &&
-		vma->vm_end >= vma->vm_mm->start_stack;
-}
-
 static void show_vma_header_prefix(struct seq_file *m,
 				   unsigned long start, unsigned long end,
 				   vm_flags_t flags, unsigned long long pgoff,
@@ -327,13 +312,12 @@ show_map_vma(struct seq_file *m, struct
 			goto done;
 		}
 
-		if (vma->vm_start <= mm->brk &&
-		    vma->vm_end >= mm->start_brk) {
+		if (vma_is_heap(vma)) {
 			name = "[heap]";
 			goto done;
 		}
 
-		if (is_stack(vma)) {
+		if (vma_is_stack(vma)) {
 			name = "[stack]";
 			goto done;
 		}
@@ -1971,9 +1955,9 @@ static int show_numa_map(struct seq_file
 	if (file) {
 		seq_puts(m, " file=");
 		seq_file_path(m, file, "\n\t= ");
-	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
+	} else if (vma_is_heap(vma)) {
 		seq_puts(m, " heap");
-	} else if (is_stack(vma)) {
+	} else if (vma_is_stack(vma)) {
 		seq_puts(m, " stack");
 	}
 
--- a/fs/proc/task_nommu.c~mm-use-vma_is_stack-and-vma_is_heap
+++ a/fs/proc/task_nommu.c
@@ -121,19 +121,6 @@ unsigned long task_statm(struct mm_struc
 	return size;
 }
 
-static int is_stack(struct vm_area_struct *vma)
-{
-	struct mm_struct *mm = vma->vm_mm;
-
-	/*
-	 * We make no effort to guess what a given thread considers to be
-	 * its "stack".  It's not even well-defined for programs written
-	 * languages like Go.
-	 */
-	return vma->vm_start <= mm->start_stack &&
-		vma->vm_end >= mm->start_stack;
-}
-
 /*
  * display a single VMA to a sequenced file
  */
@@ -171,7 +158,7 @@ static int nommu_vma_show(struct seq_fil
 	if (file) {
 		seq_pad(m, ' ');
 		seq_file_path(m, file, "");
-	} else if (mm && is_stack(vma)) {
+	} else if (mm && vma_is_stack(vma)) {
 		seq_pad(m, ' ');
 		seq_puts(m, "[stack]");
 	}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-arguments-of-show_mem.patch
mm-make-show_free_areas-static.patch
mm-introduce-vma_is_stack-and-vma_is_heap.patch
mm-use-vma_is_stack-and-vma_is_heap.patch
drm-amdkfd-use-vma_is_stack-and-vma_is_heap.patch
selinux-use-vma_is_stack-and-vma_is_heap.patch
perf-core-use-vma_is_stack-and-vma_is_heap.patch

