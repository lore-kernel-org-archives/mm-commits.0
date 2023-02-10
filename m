Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B08C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjBJAxp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjBJAw4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3C26E998
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 036A1B82395
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967FBC4339C;
        Fri, 10 Feb 2023 00:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990372;
        bh=CZvy8J6LGKrHOSkJvTtHBFqRsm4j8A5/Kk/pifQ+eyE=;
        h=Date:To:From:Subject:From;
        b=SAdhJ1UuNK3vCK0TnTvPXyvDxuh3aqUy4zcLiRAuGHQmZziebBOda0p421yS63Kn9
         VgckwEdB1spxTYwepiKhv7UAIceK6+Q8P6cxuf4U/e6/xiPAMBZUSjvQI4+n0b0acW
         3prdRW6FZiQcAKp7xCA5S0OxYZyibTc0bsXOWkrY=
Date:   Thu, 09 Feb 2023 16:52:52 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] task_mmu-convert-to-vma-iterator.patch removed from -mm tree
Message-Id: <20230210005252.967FBC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: task_mmu: convert to vma iterator
has been removed from the -mm tree.  Its filename was
     task_mmu-convert-to-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: task_mmu: convert to vma iterator
Date: Fri, 20 Jan 2023 11:26:22 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Update the comments to how the vma iterator works.  The vma iterator will
keep track of the last vm_end and start the search from vm_end + 1.

Link: https://lkml.kernel.org/r/20230120162650.984577-22-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/fs/proc/task_mmu.c~task_mmu-convert-to-vma-iterator
+++ a/fs/proc/task_mmu.c
@@ -890,7 +890,7 @@ static int show_smaps_rollup(struct seq_
 	struct vm_area_struct *vma;
 	unsigned long vma_start = 0, last_vma_end = 0;
 	int ret = 0;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
 	priv->task = get_proc_task(priv->inode);
 	if (!priv->task)
@@ -908,7 +908,7 @@ static int show_smaps_rollup(struct seq_
 		goto out_put_mm;
 
 	hold_task_mempolicy(priv);
-	vma = mas_find(&mas, ULONG_MAX);
+	vma = vma_next(&vmi);
 
 	if (unlikely(!vma))
 		goto empty_set;
@@ -923,7 +923,7 @@ static int show_smaps_rollup(struct seq_
 		 * access it for write request.
 		 */
 		if (mmap_lock_is_contended(mm)) {
-			mas_pause(&mas);
+			vma_iter_invalidate(&vmi);
 			mmap_read_unlock(mm);
 			ret = mmap_read_lock_killable(mm);
 			if (ret) {
@@ -948,31 +948,31 @@ static int show_smaps_rollup(struct seq_
 			 *
 			 * 1) VMA2 is freed, but VMA3 exists:
 			 *
-			 *    find_vma(mm, 16k - 1) will return VMA3.
+			 *    vma_next(vmi) will return VMA3.
 			 *    In this case, just continue from VMA3.
 			 *
 			 * 2) VMA2 still exists:
 			 *
-			 *    find_vma(mm, 16k - 1) will return VMA2.
-			 *    Iterate the loop like the original one.
+			 *    vma_next(vmi) will return VMA3.
+			 *    In this case, just continue from VMA3.
 			 *
 			 * 3) No more VMAs can be found:
 			 *
-			 *    find_vma(mm, 16k - 1) will return NULL.
+			 *    vma_next(vmi) will return NULL.
 			 *    No more things to do, just break.
 			 *
 			 * 4) (last_vma_end - 1) is the middle of a vma (VMA'):
 			 *
-			 *    find_vma(mm, 16k - 1) will return VMA' whose range
+			 *    vma_next(vmi) will return VMA' whose range
 			 *    contains last_vma_end.
 			 *    Iterate VMA' from last_vma_end.
 			 */
-			vma = mas_find(&mas, ULONG_MAX);
+			vma = vma_next(&vmi);
 			/* Case 3 above */
 			if (!vma)
 				break;
 
-			/* Case 1 above */
+			/* Case 1 and 2 above */
 			if (vma->vm_start >= last_vma_end)
 				continue;
 
@@ -980,8 +980,7 @@ static int show_smaps_rollup(struct seq_
 			if (vma->vm_end > last_vma_end)
 				smap_gather_stats(vma, &mss, last_vma_end);
 		}
-		/* Case 2 above */
-	} while ((vma = mas_find(&mas, ULONG_MAX)) != NULL);
+	} for_each_vma(vmi, vma);
 
 empty_set:
 	show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
@@ -1277,7 +1276,7 @@ static ssize_t clear_refs_write(struct f
 		return -ESRCH;
 	mm = get_task_mm(task);
 	if (mm) {
-		MA_STATE(mas, &mm->mm_mt, 0, 0);
+		VMA_ITERATOR(vmi, mm, 0);
 		struct mmu_notifier_range range;
 		struct clear_refs_private cp = {
 			.type = type,
@@ -1297,7 +1296,7 @@ static ssize_t clear_refs_write(struct f
 		}
 
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
-			mas_for_each(&mas, vma, ULONG_MAX) {
+			for_each_vma(vmi, vma) {
 				if (!(vma->vm_flags & VM_SOFTDIRTY))
 					continue;
 				vma->vm_flags &= ~VM_SOFTDIRTY;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


