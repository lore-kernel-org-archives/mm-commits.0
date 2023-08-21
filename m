Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 237A1EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjHUUjd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjHUUjX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA6110D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23B3D6462E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74062C433C8;
        Mon, 21 Aug 2023 20:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650360;
        bh=Q8cSwt4NnAOEXiJmUl5DzmN9Z0hR/wvIgiN0BDB7HCc=;
        h=Date:To:From:Subject:From;
        b=NOeN06hb2oM1nvuO3wU/s3wR4iqsXy/D0m40ULoZEWVCMNJ0PXVgkybYXYBNkSlrA
         0FbHOyNsbaqc1wxzeiEcZNztm9b41dCNUfR27MFL0ONews8/3Yw8rbQpNerEnk3zk3
         esZoBtKB9hcBHUhT5+3OGT5OneGYzcGrM88KgXII=
Date:   Mon, 21 Aug 2023 13:39:19 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        stephen.smalley.work@gmail.com, peterz@infradead.org,
        paul@paul-moore.com, felix.kuehling@amd.com, eparis@parisplace.org,
        david@redhat.com, daniel@ffwll.ch, christian.koenig@amd.com,
        cgzones@googlemail.com, alexander.deucher@amd.com,
        airlied@gmail.com, acme@kernel.org, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-factor-out-vma-stack-and-heap-checks.patch removed from -mm tree
Message-Id: <20230821203920.74062C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: factor out VMA stack and heap checks
has been removed from the -mm tree.  Its filename was
     mm-factor-out-vma-stack-and-heap-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: factor out VMA stack and heap checks
Date: Fri, 28 Jul 2023 13:00:40 +0800

Patch series "mm: convert to vma_is_initial_heap/stack()", v3.

Add vma_is_initial_stack() and vma_is_initial_heap() helpers and use them
to simplify code.


This patch (of 4):

Factor out VMA stack and heap checks and name them vma_is_initial_stack()
and vma_is_initial_heap() for general use.

Link: https://lkml.kernel.org/r/20230728050043.59880-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20230728050043.59880-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Christian Göttsche <cgzones@googlemail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Christian Göttsche <cgzones@googlemail.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c   |   24 ++++--------------------
 fs/proc/task_nommu.c |   15 +--------------
 include/linux/mm.h   |   25 +++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 34 deletions(-)

--- a/fs/proc/task_mmu.c~mm-factor-out-vma-stack-and-heap-checks
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
+		if (vma_is_initial_heap(vma)) {
 			name = "[heap]";
 			goto done;
 		}
 
-		if (is_stack(vma)) {
+		if (vma_is_initial_stack(vma)) {
 			name = "[stack]";
 			goto done;
 		}
@@ -1971,9 +1955,9 @@ static int show_numa_map(struct seq_file
 	if (file) {
 		seq_puts(m, " file=");
 		seq_file_path(m, file, "\n\t= ");
-	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
+	} else if (vma_is_initial_heap(vma)) {
 		seq_puts(m, " heap");
-	} else if (is_stack(vma)) {
+	} else if (vma_is_initial_stack(vma)) {
 		seq_puts(m, " stack");
 	}
 
--- a/fs/proc/task_nommu.c~mm-factor-out-vma-stack-and-heap-checks
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
+	} else if (mm && vma_is_initial_stack(vma)) {
 		seq_pad(m, ' ');
 		seq_puts(m, "[stack]");
 	}
--- a/include/linux/mm.h~mm-factor-out-vma-stack-and-heap-checks
+++ a/include/linux/mm.h
@@ -833,6 +833,31 @@ static inline bool vma_is_anonymous(stru
 	return !vma->vm_ops;
 }
 
+/*
+ * Indicate if the VMA is a heap for the given task; for
+ * /proc/PID/maps that is the heap of the main task.
+ */
+static inline bool vma_is_initial_heap(const struct vm_area_struct *vma)
+{
+       return vma->vm_start <= vma->vm_mm->brk &&
+		vma->vm_end >= vma->vm_mm->start_brk;
+}
+
+/*
+ * Indicate if the VMA is a stack for the given task; for
+ * /proc/PID/maps that is the stack of the main task.
+ */
+static inline bool vma_is_initial_stack(const struct vm_area_struct *vma)
+{
+	/*
+	 * We make no effort to guess what a given thread considers to be
+	 * its "stack".  It's not even well-defined for programs written
+	 * languages like Go.
+	 */
+       return vma->vm_start <= vma->vm_mm->start_stack &&
+	       vma->vm_end >= vma->vm_mm->start_stack;
+}
+
 static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
 {
 	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


