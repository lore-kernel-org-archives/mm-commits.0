Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FA4C636D7
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjBJAwt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjBJAwn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB556E984
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE19BB82272
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607A0C433EF;
        Fri, 10 Feb 2023 00:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990359;
        bh=Mr9dArjYAZLGhNdcXkCvayxmbfxqSOgKkqOZf5DI2Y8=;
        h=Date:To:From:Subject:From;
        b=GvbniYVaF5FgPVnSDojsa9ZUUKBsw8dfsKJJA3p/tWpn2hEPNGKJB2Da8MPlVw4GE
         gNLCw8olMPrn0FKnMw9YlkBpb+EyR8ZxGa8OPE0X7Xbs80I02NYoOr4U+k04P14XHi
         Bzn8yyOn78TO2gvgYJFjM0QlL/WWh0f/xmDKNEjY=
Date:   Thu, 09 Feb 2023 16:52:38 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmap-convert-vma_expand-to-use-vma-iterator.patch removed from -mm tree
Message-Id: <20230210005239.607A0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: convert vma_expand() to use vma iterator
has been removed from the -mm tree.  Its filename was
     mmap-convert-vma_expand-to-use-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mmap: convert vma_expand() to use vma iterator
Date: Fri, 20 Jan 2023 11:26:14 -0500

Use the vma iterator instead of the maple state for type safety and for
consistency through the mm code.

Link: https://lkml.kernel.org/r/20230120162650.984577-14-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mmap-convert-vma_expand-to-use-vma-iterator
+++ a/mm/mmap.c
@@ -527,7 +527,7 @@ static int vma_link(struct mm_struct *mm
  *
  * Returns: 0 on success
  */
-inline int vma_expand(struct ma_state *mas, struct vm_area_struct *vma,
+inline int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		      unsigned long start, unsigned long end, pgoff_t pgoff,
 		      struct vm_area_struct *next)
 {
@@ -556,7 +556,7 @@ inline int vma_expand(struct ma_state *m
 	/* Only handles expanding */
 	VM_BUG_ON(vma->vm_start < start || vma->vm_end > end);
 
-	if (mas_preallocate(mas, GFP_KERNEL))
+	if (vma_iter_prealloc(vmi))
 		goto nomem;
 
 	vma_adjust_trans_huge(vma, start, end, 0);
@@ -581,8 +581,7 @@ inline int vma_expand(struct ma_state *m
 	vma->vm_start = start;
 	vma->vm_end = end;
 	vma->vm_pgoff = pgoff;
-	/* Note: mas must be pointing to the expanding VMA */
-	vma_mas_store(vma, mas);
+	vma_iter_store(vmi, vma);
 
 	if (file) {
 		vma_interval_tree_insert(vma, root);
@@ -2600,7 +2599,7 @@ unsigned long mmap_region(struct file *f
 
 	/* Actually expand, if possible */
 	if (vma &&
-	    !vma_expand(&vmi.mas, vma, merge_start, merge_end, vm_pgoff, next)) {
+	    !vma_expand(&vmi, vma, merge_start, merge_end, vm_pgoff, next)) {
 		khugepaged_enter_vma(vma, vm_flags);
 		goto expanded;
 	}
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


