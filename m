Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9B0C04FE2
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbjHKXNh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbjHKXNO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830874694
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A3BE63F1F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7596CC433C7;
        Fri, 11 Aug 2023 23:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794967;
        bh=/WtDQNTaD9OLb1FT09vLMKAUG3tI0j1hlwGIPr4nLz4=;
        h=Date:To:From:Subject:From;
        b=MVmAFZlT5c5eAhLNzzUU4vK2Lk03OoXN9bWUBGgiJO4/NpB4wFKHOwV2ZnXwxuR6Y
         YPEgKRYduN027xOLqsqUfZy00f0nbmfUpDer+OcA47HFGbrDfQTlZV8x7Y4x3KzV9J
         VTyBinN4EBBbGrX07nuG1996BzQ9hFYUQmRoNQg0=
Date:   Fri, 11 Aug 2023 16:02:46 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-vma_iter_clear_gfp-in-nommu.patch removed from -mm tree
Message-Id: <20230811230247.7596CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use vma_iter_clear_gfp() in nommu
has been removed from the -mm tree.  Its filename was
     mm-use-vma_iter_clear_gfp-in-nommu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: use vma_iter_clear_gfp() in nommu
Date: Mon, 24 Jul 2023 14:31:51 -0400

Move the definition of vma_iter_clear_gfp() from mmap.c to internal.h so
it can be used in the nommu code.  This will reduce node preallocations
in nommu.

Link: https://lkml.kernel.org/r/20230724183157.3939892-10-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   12 ++++++++++++
 mm/mmap.c     |   12 ------------
 mm/nommu.c    |   12 ++++--------
 3 files changed, 16 insertions(+), 20 deletions(-)

--- a/mm/internal.h~mm-use-vma_iter_clear_gfp-in-nommu
+++ a/mm/internal.h
@@ -1064,6 +1064,18 @@ static inline void vma_iter_clear(struct
 	mas_store_prealloc(&vmi->mas, NULL);
 }
 
+static inline int vma_iter_clear_gfp(struct vma_iterator *vmi,
+			unsigned long start, unsigned long end, gfp_t gfp)
+{
+	vmi->mas.index = start;
+	vmi->mas.last = end - 1;
+	mas_store_gfp(&vmi->mas, NULL, gfp);
+	if (unlikely(mas_is_err(&vmi->mas)))
+		return -ENOMEM;
+
+	return 0;
+}
+
 static inline struct vm_area_struct *vma_iter_load(struct vma_iterator *vmi)
 {
 	return mas_walk(&vmi->mas);
--- a/mm/mmap.c~mm-use-vma_iter_clear_gfp-in-nommu
+++ a/mm/mmap.c
@@ -154,18 +154,6 @@ static inline struct vm_area_struct *vma
 	return mas_prev(&vmi->mas, min);
 }
 
-static inline int vma_iter_clear_gfp(struct vma_iterator *vmi,
-			unsigned long start, unsigned long end, gfp_t gfp)
-{
-	vmi->mas.index = start;
-	vmi->mas.last = end - 1;
-	mas_store_gfp(&vmi->mas, NULL, gfp);
-	if (unlikely(mas_is_err(&vmi->mas)))
-		return -ENOMEM;
-
-	return 0;
-}
-
 /*
  * check_brk_limits() - Use platform specific check of range & verify mlock
  * limits.
--- a/mm/nommu.c~mm-use-vma_iter_clear_gfp-in-nommu
+++ a/mm/nommu.c
@@ -1396,17 +1396,13 @@ static int vmi_shrink_vma(struct vma_ite
 
 	/* adjust the VMA's pointers, which may reposition it in the MM's tree
 	 * and list */
-	if (vma_iter_prealloc(vmi)) {
-		pr_warn("Allocation of vma tree for process %d failed\n",
-		       current->pid);
-		return -ENOMEM;
-	}
-
 	if (from > vma->vm_start) {
-		vma_iter_clear(vmi, from, vma->vm_end);
+		if (vma_iter_clear_gfp(vmi, from, vma->vm_end, GFP_KERNEL))
+			return -ENOMEM;
 		vma->vm_end = from;
 	} else {
-		vma_iter_clear(vmi, vma->vm_start, to);
+		if (vma_iter_clear_gfp(vmi, vma->vm_start, to, GFP_KERNEL))
+			return -ENOMEM;
 		vma->vm_start = to;
 	}
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

