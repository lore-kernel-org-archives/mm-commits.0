Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB956C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjBJAyi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjBJAxx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897CE6F8E4
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2792F61BF3
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8FAC433EF;
        Fri, 10 Feb 2023 00:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990396;
        bh=97wCfWRBhKl4BcqvHuvP8IDDo0hbcc4KpXndrAINaps=;
        h=Date:To:From:Subject:From;
        b=OgMwMtl3/gfAr/QVCnhLCa+XYsahU0AvAhL2VTp/Za3wJRHtnZlp6iwG+oLjkrLyx
         yMct5Uf4Ds17R4fULysiNlWRB87bMZSwpMnUuDUoBDNGM11UnAX/SBqO2ozQmZpvti
         8Q3VOKc9dqWcPLd57KOyMxa4D8qEsl2qUQ9sSrBg=
Date:   Thu, 09 Feb 2023 16:53:16 -0800
To:     mm-commits@vger.kernel.org, lizetao1@huawei.com,
        Liam.Howlett@oracle.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmap-clean-up-mmap_region-unrolling.patch removed from -mm tree
Message-Id: <20230210005316.7F8FAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: clean up mmap_region() unrolling
has been removed from the -mm tree.  Its filename was
     mmap-clean-up-mmap_region-unrolling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mmap: clean up mmap_region() unrolling
Date: Fri, 20 Jan 2023 11:26:38 -0500

Move logic of unrolling to the error path as apposed to duplicating it
within the function body.  This reduces the potential of missing an update
to one path when making changes.

Link: https://lkml.kernel.org/r/20230120162650.984577-38-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Li Zetao <lizetao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   47 +++++++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

--- a/mm/mmap.c~mmap-clean-up-mmap_region-unrolling
+++ a/mm/mmap.c
@@ -2601,12 +2601,11 @@ cannot_expand:
 		 * Expansion is handled above, merging is handled below.
 		 * Drivers should not alter the address of the VMA.
 		 */
-		if (WARN_ON((addr != vma->vm_start))) {
-			error = -EINVAL;
+		error = -EINVAL;
+		if (WARN_ON((addr != vma->vm_start)))
 			goto close_and_free_vma;
-		}
-		vma_iter_set(&vmi, addr);
 
+		vma_iter_set(&vmi, addr);
 		/*
 		 * If vm_flags changed after call_mmap(), we should try merge
 		 * vma again as we may succeed this time.
@@ -2653,25 +2652,13 @@ cannot_expand:
 	}
 
 	/* Allow architectures to sanity-check the vm_flags */
-	if (!arch_validate_flags(vma->vm_flags)) {
-		error = -EINVAL;
-		if (file)
-			goto close_and_free_vma;
-		else if (vma->vm_file)
-			goto unmap_and_free_vma;
-		else
-			goto free_vma;
-	}
-
-	if (vma_iter_prealloc(&vmi)) {
-		error = -ENOMEM;
-		if (file)
-			goto close_and_free_vma;
-		else if (vma->vm_file)
-			goto unmap_and_free_vma;
-		else
-			goto free_vma;
-	}
+	error = -EINVAL;
+	if (!arch_validate_flags(vma->vm_flags))
+		goto close_and_free_vma;
+
+	error = -ENOMEM;
+	if (vma_iter_prealloc(&vmi))
+		goto close_and_free_vma;
 
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
@@ -2730,14 +2717,18 @@ expanded:
 	return addr;
 
 close_and_free_vma:
-	if (vma->vm_ops && vma->vm_ops->close)
+	if (file && vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
+
+	if (file || vma->vm_file) {
 unmap_and_free_vma:
-	fput(vma->vm_file);
-	vma->vm_file = NULL;
+		fput(vma->vm_file);
+		vma->vm_file = NULL;
 
-	/* Undo any partial mapping done by a device driver. */
-	unmap_region(mm, &mm->mm_mt, vma, prev, next, vma->vm_start, vma->vm_end);
+		/* Undo any partial mapping done by a device driver. */
+		unmap_region(mm, &mm->mm_mt, vma, prev, next, vma->vm_start,
+			     vma->vm_end);
+	}
 	if (file && (vm_flags & VM_SHARED))
 		mapping_unmap_writable(file->f_mapping);
 free_vma:
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


