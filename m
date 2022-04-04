Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881E5C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiDDXkT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiDDXkS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EFE4C419
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 16:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12D28B81ACD
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 23:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B964FC340F3;
        Mon,  4 Apr 2022 23:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649115484;
        bh=7qze4SNQjIXt33qY6NHm/BIsXdYf8/3CsSBjDzk4NJg=;
        h=Date:To:From:Subject:From;
        b=qad4Toj1+oYx8m/XSfFXqmrngZFdgR9Y0Yaxw5i5NZEXcW49u1OVWJJmUrSodUvEH
         +QIq9FfIgn0qNcIc2UkzKUSGhaDqZEWzybt9dFEQ0f71cc3fahsKyCd5q8Z9yFsCQs
         4hh1iQTBEPka6NxDXLDappuW15FtjFDPnv+RrEHM=
Date:   Mon, 04 Apr 2022 16:38:04 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tytso@mit.edu, song@kernel.org, riel@surriel.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-only-regular-file-could-be-thp-eligible.patch added to -mm tree
Message-Id: <20220404233804.B964FC340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: only regular file could be THP eligible
has been added to the -mm tree.  Its filename is
     mm-thp-only-regular-file-could-be-thp-eligible.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-only-regular-file-could-be-thp-eligible.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-only-regular-file-could-be-thp-eligible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: thp: only regular file could be THP eligible

Since commit a4aeaa06d45e ("mm: khugepaged: skip huge page collapse for
special files"), khugepaged just collapses THP for regular file which is
the intended usecase for readonly fs THP.  Only show regular file as THP
eligible accordingly.

And make file_thp_enabled() available for khugepaged too in order to
remove duplicate code.

Link: https://lkml.kernel.org/r/20220404200250.321455-5-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Song Liu <song@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   14 ++++++++++++++
 mm/huge_memory.c        |   11 ++---------
 mm/khugepaged.c         |    9 ++-------
 3 files changed, 18 insertions(+), 16 deletions(-)

--- a/include/linux/huge_mm.h~mm-thp-only-regular-file-could-be-thp-eligible
+++ a/include/linux/huge_mm.h
@@ -173,6 +173,20 @@ static inline bool __transparent_hugepag
 	return false;
 }
 
+static inline bool file_thp_enabled(struct vm_area_struct *vma)
+{
+	struct inode *inode;
+
+	if (!vma->vm_file)
+		return false;
+
+	inode = vma->vm_file->f_inode;
+
+	return (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS)) &&
+	       (vma->vm_flags & VM_EXEC) &&
+	       !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
+}
+
 bool transparent_hugepage_active(struct vm_area_struct *vma);
 
 #define transparent_hugepage_use_zero_page()				\
--- a/mm/huge_memory.c~mm-thp-only-regular-file-could-be-thp-eligible
+++ a/mm/huge_memory.c
@@ -69,13 +69,6 @@ static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 
-static inline bool file_thp_enabled(struct vm_area_struct *vma)
-{
-	return transhuge_vma_enabled(vma, vma->vm_flags) && vma->vm_file &&
-	       !inode_is_open_for_write(vma->vm_file->f_inode) &&
-	       (vma->vm_flags & VM_EXEC);
-}
-
 bool transparent_hugepage_active(struct vm_area_struct *vma)
 {
 	/* The addr is used to check if the vma size fits */
@@ -87,8 +80,8 @@ bool transparent_hugepage_active(struct
 		return __transparent_hugepage_enabled(vma);
 	if (vma_is_shmem(vma))
 		return shmem_huge_enabled(vma);
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return file_thp_enabled(vma);
+	if (transhuge_vma_enabled(vma, vma->vm_flags) && file_thp_enabled(vma))
+		return true;
 
 	return false;
 }
--- a/mm/khugepaged.c~mm-thp-only-regular-file-could-be-thp-eligible
+++ a/mm/khugepaged.c
@@ -464,13 +464,8 @@ static bool hugepage_vma_check(struct vm
 		return false;
 
 	/* Only regular file is valid */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
-	    (vm_flags & VM_EXEC)) {
-		struct inode *inode = vma->vm_file->f_inode;
-
-		return !inode_is_open_for_write(inode) &&
-			S_ISREG(inode->i_mode);
-	}
+	if (file_thp_enabled(vma))
+		return true;
 
 	if (!vma->anon_vma || vma->vm_ops)
 		return false;
_

Patches currently in -mm which might be from shy828301@gmail.com are

sched-coredumph-clarify-the-use-of-mmf_vm_hugepage.patch
mm-khugepaged-remove-redundant-check-for-vm_no_khugepaged.patch
mm-khugepaged-skip-dax-vma.patch
mm-thp-only-regular-file-could-be-thp-eligible.patch
mm-khugepaged-make-khugepaged_enter-void-function.patch
mm-khugepaged-move-some-khugepaged_-functions-to-khugepagedc.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper.patch
mm-mmap-register-suitable-readonly-file-vmas-for-khugepaged.patch

