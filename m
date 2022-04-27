Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D92C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 22:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbiD0XAm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239451AbiD0W5y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 18:57:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E070C8E199
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 15:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96F68B82AEA
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 22:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5C9C385A7;
        Wed, 27 Apr 2022 22:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651100032;
        bh=MgSNiV2tp9In3E2vQ1KkAWAyWecg6Mk2ojff2aHwunI=;
        h=Date:To:From:Subject:From;
        b=k5ixdBPV3XQaTIRlUMp3JZNh8UyspUJDNVS9h6O+pQKwXOXXptwyywg2ss2EoJjoj
         Ewf37ZLNZP8hs1RYNalfUm8814J2W5oy06oEnrn2qEHYjbaJO1nOj+89Dd7Bm93wDn
         +jxIlZzoTDEVvJtrtgyHIxvo7itOG0qKIcTjaBRY=
Date:   Wed, 27 Apr 2022 15:53:51 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, song@kernel.org, riel@surriel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch removed from -mm tree
Message-Id: <20220427225352.3C5C9C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap: register suitable readonly file vmas for khugepaged
has been removed from the -mm tree.  Its filename was
     mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: mmap: register suitable readonly file vmas for khugepaged

The readonly FS THP relies on khugepaged to collapse THP for suitable
vmas.  But it is kind of "random luck" for khugepaged to see the readonly
FS vmas
(https://lore.kernel.org/linux-mm/00f195d4-d039-3cf2-d3a1-a2c88de397a0@suse.cz/)
since currently the vmas are registered to khugepaged when:

  - Anon huge pmd page fault
  - VMA merge
  - MADV_HUGEPAGE
  - Shmem mmap

If the above conditions are not met, even though khugepaged is enabled it
won't see readonly FS vmas at all.  MADV_HUGEPAGE could be specified
explicitly to tell khugepaged to collapse this area, but when khugepaged
mode is "always" it should scan suitable vmas as long as VM_NOHUGEPAGE is
not set.

So make sure readonly FS vmas are registered to khugepaged to make the
behavior more consistent.

Registering suitable vmas in common mmap path, that could cover both
readonly FS vmas and shmem vmas, so removed the khugepaged calls in
shmem.c.

Still need to keep the khugepaged call in vma_merge() since vma_merge() is
called in a lot of places, for example, madvise, mprotect, etc.

Link: https://lkml.kernel.org/r/20220404200250.321455-9-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <song@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c  |    6 ++++++
 mm/shmem.c |    4 ----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged
+++ a/mm/mmap.c
@@ -1846,6 +1846,12 @@ unsigned long mmap_region(struct file *f
 			goto free_vma;
 	}
 
+	/*
+	 * vma_merge() calls khugepaged_enter_vma() either, the below
+	 * call covers the non-merge case.
+	 */
+	khugepaged_enter_vma(vma, vma->vm_flags);
+
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	/* Once vma denies write, undo our temporary denial count */
 unmap_writable:
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
@@ -2240,7 +2239,6 @@ static int shmem_mmap(struct file *file,
 
 	file_accessed(file);
 	vma->vm_ops = &shmem_vm_ops;
-	khugepaged_enter_vma(vma, vma->vm_flags);
 	return 0;
 }
 
@@ -4139,8 +4137,6 @@ int shmem_zero_setup(struct vm_area_stru
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
 
-	khugepaged_enter_vma(vma, vma->vm_flags);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from shy828301@gmail.com are


