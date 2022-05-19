Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB3BC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245436AbiESWZj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245348AbiESWZf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E5166235
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C54DB61698
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B7DC385AA;
        Thu, 19 May 2022 22:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999133;
        bh=D1R1Q/rKV9lb8D0M5WjsduE5lNo/ZcsRiVF8aamTd98=;
        h=Date:To:From:Subject:From;
        b=oIgM0QZQyiiU5js4azeaHqI+mWoQS3oJukzm/mCwWYqRHpuXr3D4wMguyEbLkHY7o
         0Od9SRe+GJcGyR3ybTsxu1kri0J4jfly7mLABVioHjWHCCl6hXIdvNegqfxkmJfBSg
         VWia+kH7UBaMD9Xfk6gS+8VmtOkD8oqByfTWCmww=
Date:   Thu, 19 May 2022 15:25:32 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, songliubraving@fb.com,
        song@kernel.org, riel@surriel.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch removed from -mm tree
Message-Id: <20220519222533.21B7DC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: mmap: register suitable readonly file vmas for khugepaged
has been removed from the -mm tree.  Its filename was
     mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: mmap: register suitable readonly file vmas for khugepaged

The readonly FS THP relies on khugepaged to collapse THP for suitable
vmas.  But the behavior is inconsistent for "always" mode
(https://lore.kernel.org/linux-mm/00f195d4-d039-3cf2-d3a1-a2c88de397a0@suse.cz/).

The "always" mode means THP allocation should be tried all the time and
khugepaged should try to collapse THP all the time.  Of course the
allocation and collapse may fail due to other factors and conditions.

Currently file THP may not be collapsed by khugepaged even though all the
conditions are met.  That does break the semantics of "always" mode.

So make sure readonly FS vmas are registered to khugepaged to fix the
break.

Register suitable vmas in common mmap path, that could cover both readonly
FS vmas and shmem vmas, so remove the khugepaged calls in shmem.c.

Still need to keep the khugepaged call in vma_merge() since vma_merge() is
called in a lot of places, for example, madvise, mprotect, etc.

Link: https://lkml.kernel.org/r/20220510203222.24246-9-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastmil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Song Liu <song@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c  |    7 +++++++
 mm/shmem.c |    4 ----
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged
+++ a/mm/mmap.c
@@ -1847,6 +1847,13 @@ unsigned long mmap_region(struct file *f
 	}
 
 	vma_link(mm, vma, prev, rb_link, rb_parent);
+
+	/*
+	 * vma_merge() calls khugepaged_enter_vma() either, the below
+	 * call covers the non-merge case.
+	 */
+	khugepaged_enter_vma(vma, vma->vm_flags);
+
 	/* Once vma denies write, undo our temporary denial count */
 unmap_writable:
 	if (file && vm_flags & VM_SHARED)
--- a/mm/shmem.c~mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged
+++ a/mm/shmem.c
@@ -34,7 +34,6 @@
 #include <linux/export.h>
 #include <linux/swap.h>
 #include <linux/uio.h>
-#include <linux/khugepaged.h>
 #include <linux/hugetlb.h>
 #include <linux/fs_parser.h>
 #include <linux/swapfile.h>
@@ -2232,7 +2231,6 @@ static int shmem_mmap(struct file *file,
 
 	file_accessed(file);
 	vma->vm_ops = &shmem_vm_ops;
-	khugepaged_enter_vma(vma, vma->vm_flags);
 	return 0;
 }
 
@@ -4133,8 +4131,6 @@ int shmem_zero_setup(struct vm_area_stru
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
 
-	khugepaged_enter_vma(vma, vma->vm_flags);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-rmap-use-the-correct-parameter-name-for-define_page_vma_walk.patch
mm-pvmw-check-possible-huge-pmd-map-by-transhuge_vma_suitable.patch

