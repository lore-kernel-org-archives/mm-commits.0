Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B7BC433E9
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2CC864F32
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhB0Cai (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhB0CaI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DAD164F13;
        Sat, 27 Feb 2021 02:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392929;
        bh=3bFTxZB+6SKkBJ25Q6FL6mfcy+NtrdlKb9Bj+J9bRkk=;
        h=Date:From:To:Subject:From;
        b=NrQ+NCsm1WDTc+pPRGEW5zQN+iBXDwM5Is0pbxUMtaYDMZLFkrzyeCBrNQxE0V64E
         m6QGy+b32RrrmeDMVO+bYvbIWjSMUL6fvGuM1QjOb0QFXPtP0vQHd1eCsXzTN2sDXa
         x30F7Rpo9AF1sB4cKY03aFjWOsse1HLcWrW9eQic=
Date:   Fri, 26 Feb 2021 18:28:49 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        vbabka@suse.cz, willy@infradead.org, xuyu@linux.alibaba.com
Subject:  [merged]
 mmthpshmem-make-khugepaged-obey-tmpfs-mount-flags.patch removed from -mm
 tree
Message-ID: <20210227022849.E0FQGgwOr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp,shmem: make khugepaged obey tmpfs mount flags
has been removed from the -mm tree.  Its filename was
     mmthpshmem-make-khugepaged-obey-tmpfs-mount-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm,thp,shmem: make khugepaged obey tmpfs mount flags

Currently if thp enabled=[madvise], mounting a tmpfs filesystem with
huge=always and mmapping files from that tmpfs does not result in
khugepaged collapsing those mappings, despite the mount flag indicating
that it should.

Fix that by breaking up the blocks of tests in hugepage_vma_check a little
bit, and testing things in the correct order.

Link: https://lkml.kernel.org/r/20201124194925.623931-4-riel@surriel.com
Fixes: c2231020ea7b ("mm: thp: register mm for khugepaged when merging vma for shmem")
Signed-off-by: Rik van Riel <riel@surriel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/khugepaged.h |    2 ++
 mm/khugepaged.c            |   22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

--- a/include/linux/khugepaged.h~mmthpshmem-make-khugepaged-obey-tmpfs-mount-flags
+++ a/include/linux/khugepaged.h
@@ -3,6 +3,7 @@
 #define _LINUX_KHUGEPAGED_H
 
 #include <linux/sched/coredump.h> /* MMF_VM_HUGEPAGE */
+#include <linux/shmem_fs.h>
 
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -57,6 +58,7 @@ static inline int khugepaged_enter(struc
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
 		if ((khugepaged_always() ||
+		     (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) ||
 		     (khugepaged_req_madv() && (vm_flags & VM_HUGEPAGE))) &&
 		    !(vm_flags & VM_NOHUGEPAGE) &&
 		    !test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
--- a/mm/khugepaged.c~mmthpshmem-make-khugepaged-obey-tmpfs-mount-flags
+++ a/mm/khugepaged.c
@@ -442,18 +442,28 @@ static inline int khugepaged_test_exit(s
 static bool hugepage_vma_check(struct vm_area_struct *vma,
 			       unsigned long vm_flags)
 {
-	if ((!(vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
-	    (vm_flags & VM_NOHUGEPAGE) ||
+	/* Explicitly disabled through madvise. */
+	if ((vm_flags & VM_NOHUGEPAGE) ||
 	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
 		return false;
 
-	if (shmem_file(vma->vm_file) ||
-	    (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	     vma->vm_file &&
-	     (vm_flags & VM_DENYWRITE))) {
+	/* Enabled via shmem mount options or sysfs settings. */
+	if (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) {
 		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
 				HPAGE_PMD_NR);
 	}
+
+	/* THP settings require madvise. */
+	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
+		return false;
+
+	/* Read-only file mappings need to be aligned for THP to work. */
+	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
+	    (vm_flags & VM_DENYWRITE)) {
+		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
+				HPAGE_PMD_NR);
+	}
+
 	if (!vma->anon_vma || vma->vm_ops)
 		return false;
 	if (vma_is_temporary_stack(vma))
_

Patches currently in -mm which might be from riel@surriel.com are


