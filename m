Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3040FC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjBJAy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjBJAxr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9939C6F8D2
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34DA961BA2
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A883C433D2;
        Fri, 10 Feb 2023 00:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990393;
        bh=4pOiLySwW/Bt0p/URCgIwZfo4739QskldPqsMmtCu84=;
        h=Date:To:From:Subject:From;
        b=dVgYSTFw9LQQuNDAY6+nY7/5HBlMLTxuI42P1Iharak5wcU8LA02UwGvX5uI2x2Up
         UTHGJqsw0Z2sg9yd4rlG5DTfdH66ApxzhUMFHUY0GAf7qrPlNeXJBxWXx6h7pezYye
         G7ne4xrtCdnsgcXYWkQTLHXsG+1ZCwzR2kGEoSlo=
Date:   Thu, 09 Feb 2023 16:53:13 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pass-vma-iterator-through-to-__vma_adjust.patch removed from -mm tree
Message-Id: <20230210005313.8A883C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: pass vma iterator through to __vma_adjust()
has been removed from the -mm tree.  Its filename was
     mm-pass-vma-iterator-through-to-__vma_adjust.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: pass vma iterator through to __vma_adjust()
Date: Fri, 20 Jan 2023 11:26:36 -0500

Pass the iterator through to be used in __vma_adjust().  The state of the
iterator needs to be correct for the operation that will occur so make the
adjustments.

Link: https://lkml.kernel.org/r/20230120162650.984577-36-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-pass-vma-iterator-through-to-__vma_adjust
+++ a/mm/mmap.c
@@ -525,6 +525,10 @@ inline int vma_expand(struct vma_iterato
 		vma_interval_tree_remove(vma, root);
 	}
 
+	/* VMA iterator points to previous, so set to start if necessary */
+	if (vma_iter_addr(vmi) != start)
+		vma_iter_set(vmi, start);
+
 	vma->vm_start = start;
 	vma->vm_end = end;
 	vma->vm_pgoff = pgoff;
@@ -2164,13 +2168,13 @@ static void unmap_region(struct mm_struc
 /*
  * __split_vma() bypasses sysctl_max_map_count checking.  We use this where it
  * has already been checked or doesn't make sense to fail.
+ * VMA Iterator will point to the end VMA.
  */
 int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		unsigned long addr, int new_below)
 {
 	struct vm_area_struct *new;
 	int err;
-	unsigned long end = vma->vm_end;
 
 	validate_mm_mt(vma->vm_mm);
 
@@ -2206,14 +2210,17 @@ int __split_vma(struct vma_iterator *vmi
 		new->vm_ops->open(new);
 
 	if (new_below)
-		err = vma_adjust(vma, addr, vma->vm_end, vma->vm_pgoff +
-			((addr - new->vm_start) >> PAGE_SHIFT), new);
+		err = __vma_adjust(vmi, vma, addr, vma->vm_end,
+		   vma->vm_pgoff + ((addr - new->vm_start) >> PAGE_SHIFT),
+		   new, NULL);
 	else
-		err = vma_adjust(vma, vma->vm_start, addr, vma->vm_pgoff, new);
+		err = __vma_adjust(vmi, vma, vma->vm_start, addr, vma->vm_pgoff,
+				 new, NULL);
 
 	/* Success. */
 	if (!err) {
-		vma_iter_set(vmi, end);
+		if (new_below)
+			vma_next(vmi);
 		return 0;
 	}
 
@@ -2308,8 +2315,7 @@ do_vmi_align_munmap(struct vma_iterator
 		if (error)
 			goto start_split_failed;
 
-		vma_iter_set(vmi, start);
-		vma = vma_find(vmi, end);
+		vma = vma_iter_load(vmi);
 	}
 
 	prev = vma_prev(vmi);
@@ -2329,7 +2335,6 @@ do_vmi_align_munmap(struct vma_iterator
 			if (error)
 				goto end_split_failed;
 
-			vma_iter_set(vmi, end);
 			split = vma_prev(vmi);
 			error = munmap_sidetree(split, &mas_detach);
 			if (error)
@@ -2573,6 +2578,7 @@ cannot_expand:
 		goto unacct_error;
 	}
 
+	vma_iter_set(&vmi, addr);
 	vma->vm_start = addr;
 	vma->vm_end = end;
 	vma->vm_flags = vm_flags;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


