Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F8BC64E7A
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 23:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC24D2083E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 23:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GtFjPv4Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbgKYXYX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:24:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729720AbgKYXYX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 18:24:23 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 319D6207BC;
        Wed, 25 Nov 2020 23:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606346662;
        bh=XqphMNAHxgu4Lw2UlE94W6SrZUA0tWhIHMWHuIJcl3c=;
        h=Date:From:To:Subject:From;
        b=GtFjPv4ZvHbId5o3egBMN4C2RxAoj1AV8s3rBL4kZLPi1wkwTdHltxE7HhXYH1FYc
         rtQEHwR/xXEoZssdpu8G4RSplDBGClkmnyq3sRTkNknCT2cDfMUxVXIVMAF+fOcwQ5
         C5tcvfg11kXdHxSOHAvht5dXoHIiJbzRf0jS7Qso=
Date:   Wed, 25 Nov 2020 15:24:21 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, riel@surriel.com,
        vbabka@suse.cz, willy@infradead.org, xuyu@linux.alibaba.com
Subject:  + mmthpshmem-make-khugepaged-obey-tmpfs-mount-flags.patch
 added to -mm tree
Message-ID: <20201125232421.tNr_HZrie%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp,shmem: make khugepaged obey tmpfs mount flags
has been added to the -mm tree.  Its filename is
     mmthpshmem-make-khugepaged-obey-tmpfs-mount-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmthpshmem-make-khugepaged-obey-tmpfs-mount-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmthpshmem-make-khugepaged-obey-tmpfs-mount-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mmthpshmem-limit-shmem-thp-alloc-gfp_mask.patch
mmthpshm-limit-gfp-mask-to-no-more-than-specified.patch
mmthpshmem-make-khugepaged-obey-tmpfs-mount-flags.patch

