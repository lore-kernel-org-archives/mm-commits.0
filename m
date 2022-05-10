Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF0BC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 21:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiEJVKy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 17:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiEJVKx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 17:10:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623903CA4C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 14:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF91D61783
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 21:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA2BC385CA;
        Tue, 10 May 2022 21:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652217042;
        bh=jQM7engwByQb3IUfIpngIBWyJdLHCx3zIlLcSqxxePs=;
        h=Date:To:From:Subject:From;
        b=LNCxUq2VkMs4jYQSDqW9Ej/dmtFl1vsjrwbJox2c2JnjICT6mqjPCXlRIvHyT746U
         LpTXsu2Q/lxT6/IWuWv7V7MLOhTA4MzoPniaEuK3Tm6CSeTKWMYQMooFIApSlQWNnh
         aX2U8nDlGdXghQv1woFWLjO4oIM7p7K1rBgrbXXI=
Date:   Tue, 10 May 2022 14:10:41 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, songliubraving@fb.com,
        song@kernel.org, riel@surriel.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch added to mm-unstable branch
Message-Id: <20220510211042.4FA2BC385CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap: register suitable readonly file vmas for khugepaged
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

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

 mm/mmap.c  |    6 ++++++
 mm/shmem.c |    4 ----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged
+++ a/mm/mmap.c
@@ -2745,6 +2745,12 @@ cannot_expand:
 		i_mmap_unlock_write(vma->vm_file->f_mapping);
 	}
 
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

sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-make-hugepage_vma_check-non-static.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

