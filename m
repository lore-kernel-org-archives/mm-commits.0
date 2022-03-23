Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4717DC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345490AbiCWXJL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345489AbiCWXIz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3499B90FDE
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:07:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAC0CB82185
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADD9C340E8;
        Wed, 23 Mar 2022 23:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076836;
        bh=mLuUglu30kCbj/nPXm3H+U9Z+JX2+IyOSWJcR3pVOtQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Thaz+0npG/vT80pIycGFv/pBzDZvB8y8O+YAAptYT4zMu8InZd3DX/ZyQDLs/RyYk
         pdgKyIJ1CeWND0sb96SGTRYYG+uLFTJDQkLiS2mmSGrR+4yBdeakID+X04CfYCQNYs
         aUinfjVNGdiFuTQMFK4YKUf597hOf2wlXFg4Bk3Y=
Date:   Wed, 23 Mar 2022 16:07:15 -0700
To:     tarasmadan@google.com, glider@google.com, elver@google.com,
        dvyukov@google.com, bigeasy@linutronix.de, andreyknvl@gmail.com,
        nogikh@google.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 39/41] kcov: properly handle subsequent mmap calls
Message-Id: <20220323230716.4ADD9C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>
Subject: kcov: properly handle subsequent mmap calls

Allocate the kcov buffer during KCOV_MODE_INIT in order to untie mmapping
of a kcov instance and the actual coverage collection process. Modify
kcov_mmap, so that it can be reliably used any number of times once
KCOV_MODE_INIT has succeeded.

These changes to the user-facing interface of the tool only weaken the
preconditions, so all existing user space code should remain compatible
with the new version.

Link: https://lkml.kernel.org/r/20220117153634.150357-3-nogikh@google.com
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Taras Madan <tarasmadan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- a/kernel/kcov.c~kcov-properly-handle-subsequent-mmap-calls
+++ a/kernel/kcov.c
@@ -459,37 +459,28 @@ void kcov_task_exit(struct task_struct *
 static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	int res = 0;
-	void *area;
 	struct kcov *kcov = vma->vm_file->private_data;
 	unsigned long size, off;
 	struct page *page;
 	unsigned long flags;
 
-	area = vmalloc_user(vma->vm_end - vma->vm_start);
-	if (!area)
-		return -ENOMEM;
-
 	spin_lock_irqsave(&kcov->lock, flags);
 	size = kcov->size * sizeof(unsigned long);
-	if (kcov->mode != KCOV_MODE_INIT || vma->vm_pgoff != 0 ||
+	if (kcov->area == NULL || vma->vm_pgoff != 0 ||
 	    vma->vm_end - vma->vm_start != size) {
 		res = -EINVAL;
 		goto exit;
 	}
-	if (!kcov->area) {
-		kcov->area = area;
-		vma->vm_flags |= VM_DONTEXPAND;
-		spin_unlock_irqrestore(&kcov->lock, flags);
-		for (off = 0; off < size; off += PAGE_SIZE) {
-			page = vmalloc_to_page(kcov->area + off);
-			if (vm_insert_page(vma, vma->vm_start + off, page))
-				WARN_ONCE(1, "vm_insert_page() failed");
-		}
-		return 0;
+	spin_unlock_irqrestore(&kcov->lock, flags);
+	vma->vm_flags |= VM_DONTEXPAND;
+	for (off = 0; off < size; off += PAGE_SIZE) {
+		page = vmalloc_to_page(kcov->area + off);
+		if (vm_insert_page(vma, vma->vm_start + off, page))
+			WARN_ONCE(1, "vm_insert_page() failed");
 	}
+	return 0;
 exit:
 	spin_unlock_irqrestore(&kcov->lock, flags);
-	vfree(area);
 	return res;
 }
 
@@ -674,6 +665,7 @@ static long kcov_ioctl(struct file *file
 	unsigned int remote_num_handles;
 	unsigned long remote_arg_size;
 	unsigned long size, flags;
+	void *area;
 
 	kcov = filep->private_data;
 	switch (cmd) {
@@ -683,17 +675,21 @@ static long kcov_ioctl(struct file *file
 		 * Must happen before anything else.
 		 *
 		 * First check the size argument - it must be at least 2
-		 * to hold the current position and one PC. Later we allocate
-		 * size * sizeof(unsigned long) memory, that must not overflow.
+		 * to hold the current position and one PC.
 		 */
 		size = arg;
 		if (size < 2 || size > INT_MAX / sizeof(unsigned long))
 			return -EINVAL;
+		area = vmalloc_user(size * sizeof(unsigned long));
+		if (area == NULL)
+			return -ENOMEM;
 		spin_lock_irqsave(&kcov->lock, flags);
 		if (kcov->mode != KCOV_MODE_DISABLED) {
 			spin_unlock_irqrestore(&kcov->lock, flags);
+			vfree(area);
 			return -EBUSY;
 		}
+		kcov->area = area;
 		kcov->size = size;
 		kcov->mode = KCOV_MODE_INIT;
 		spin_unlock_irqrestore(&kcov->lock, flags);
_
