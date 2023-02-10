Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2473C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjBJAx5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjBJAxY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA746D8FD
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFD84B82399
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6833C4339C;
        Fri, 10 Feb 2023 00:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990378;
        bh=4iYkwGF+W3THC5UmiVc2r/1TFLVULOr2Xmeq+V4zSl4=;
        h=Date:To:From:Subject:From;
        b=YKTUwC+dgjvzW39rgQ/3wHgfjxxCgO1+oXTmUmoTP0ObH8Gf2THOl6bv9fOwaF36q
         /Rsk9V1K+kj1qcdJfCYRp2oBZrjs1bE5ubpSRoWIpWy1jvJ2VvieUpq99khSHRMpLv
         Q/9T+eh6QwYoUapivmtTzkEetyOoUDSP6xlmg1Pc=
Date:   Thu, 09 Feb 2023 16:52:58 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmap-use-vmi-version-of-vma_merge.patch removed from -mm tree
Message-Id: <20230210005258.A6833C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: use vmi version of vma_merge()
has been removed from the -mm tree.  Its filename was
     mmap-use-vmi-version-of-vma_merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mmap: use vmi version of vma_merge()
Date: Fri, 20 Jan 2023 11:26:26 -0500

Use the vma iterator so that the iterator can be invalidated or updated to
avoid each caller doing so.

Link: https://lkml.kernel.org/r/20230120162650.984577-26-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mmap-use-vmi-version-of-vma_merge
+++ a/mm/mmap.c
@@ -2690,8 +2690,9 @@ cannot_expand:
 		 * vma again as we may succeed this time.
 		 */
 		if (unlikely(vm_flags != vma->vm_flags && prev)) {
-			merge = vma_merge(mm, prev, vma->vm_start, vma->vm_end, vma->vm_flags,
-				NULL, vma->vm_file, vma->vm_pgoff, NULL, NULL_VM_UFFD_CTX, NULL);
+			merge = vmi_vma_merge(&vmi, mm, prev, vma->vm_start,
+				vma->vm_end, vma->vm_flags, NULL, vma->vm_file,
+				vma->vm_pgoff, NULL, NULL_VM_UFFD_CTX, NULL);
 			if (merge) {
 				/*
 				 * ->mmap() can change vma->vm_file and fput
@@ -3232,6 +3233,7 @@ struct vm_area_struct *copy_vma(struct v
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma, *prev;
 	bool faulted_in_anon_vma = true;
+	VMA_ITERATOR(vmi, mm, addr);
 
 	validate_mm_mt(mm);
 	/*
@@ -3247,7 +3249,7 @@ struct vm_area_struct *copy_vma(struct v
 	if (new_vma && new_vma->vm_start < addr + len)
 		return NULL;	/* should never get here */
 
-	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
+	new_vma = vmi_vma_merge(&vmi, mm, prev, addr, addr + len, vma->vm_flags,
 			    vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
 			    vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 	if (new_vma) {
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


