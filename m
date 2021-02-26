Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A789C433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D096564EE4
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhBZBRV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229841AbhBZBRK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 721A464F24;
        Fri, 26 Feb 2021 01:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302187;
        bh=6janH+JFU3/c3MqipCB/XbY+/sd0HhrgkwsYOrNg5bA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q/UgFOLvMEQOqDKdPh2Pt9zsyvTGCMwo1UJ3mkv+U3Q6+32klQI0P2uyN0DHZVrql
         gQix+AhjsGevzZjwGBVFPvhU9YgTGgP0Y8qdm/o/WY3SjprSt2TEfBUhyUGvmV5T1p
         ls3kIxB62x8M9CjUrCkSfZvpNXiSTMTwazUDD9Uc=
Date:   Thu, 25 Feb 2021 17:16:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        linux-mm@kvack.org, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, riel@surriel.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org,
        xuyu@linux.alibaba.com
Subject:  [patch 017/118] mm,thp,shmem: make khugepaged obey tmpfs
 mount flags
Message-ID: <20210226011625.94M80NzHY%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
