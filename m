Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481E8C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10E506161F
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhEKBOT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 21:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhEKBOT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 21:14:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D377D61480;
        Tue, 11 May 2021 01:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620695594;
        bh=s+6j8pjlLi3j+nvzj/7i4AyVUIlcVZJQEHbzni/ZsYM=;
        h=Date:From:To:Subject:From;
        b=GtPvRcWOVVWsHc9VMOyfy8FQ1q995oliIPv6g8Dd+BnGdTwyx5BZnRwUpta0iiO2R
         QBAJv8JOyORRByUkxy87KcnBBerHMRjrAi2wD6v/1MevULPCp8JMbskW+lUb6ZquqJ
         o0etdWto//eSLbaTuyZjAkD3W9cU0OsjLETeR8Sc=
Date:   Mon, 10 May 2021 18:13:13 -0700
From:   akpm@linux-foundation.org
To:     Liam.Howlett@Oracle.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + mm-mmap-introduce-unlock_range-for-code-cleanup.patch
 added to -mm tree
Message-ID: <20210511011313.AfeIm1Fii%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: introduce unlock_range() for code cleanup
has been added to the -mm tree.  Its filename is
     mm-mmap-introduce-unlock_range-for-code-cleanup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-introduce-unlock_range-for-code-cleanup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-introduce-unlock_range-for-code-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: introduce unlock_range() for code cleanup

Both __do_munmap() and exit_mmap() unlock a range of VMAs using almost
identical code blocks.  Replace both blocks by a static inline function.

Link: https://lkml.kernel.org/r/20210510211021.2797427-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

--- a/mm/mmap.c~mm-mmap-introduce-unlock_range-for-code-cleanup
+++ a/mm/mmap.c
@@ -2802,6 +2802,22 @@ int split_vma(struct mm_struct *mm, stru
 	return __split_vma(mm, vma, addr, new_below);
 }
 
+static inline
+void unlock_range(struct vm_area_struct *start, unsigned long limit)
+{
+	struct mm_struct *mm = start->vm_mm;
+	struct vm_area_struct *tmp = start;
+
+	while (tmp && tmp->vm_start < limit) {
+		if (tmp->vm_flags & VM_LOCKED) {
+			mm->locked_vm -= vma_pages(tmp);
+			munlock_vma_pages_all(tmp);
+		}
+
+		tmp = tmp->vm_next;
+	}
+}
+
 /* Munmap is split into 2 main parts -- this part which finds
  * what needs doing, and the areas themselves, which do the
  * work.  This now handles partial unmappings.
@@ -2885,17 +2901,8 @@ int __do_munmap(struct mm_struct *mm, un
 	/*
 	 * unlock any mlock()ed ranges before detaching vmas
 	 */
-	if (mm->locked_vm) {
-		struct vm_area_struct *tmp = vma;
-		while (tmp && tmp->vm_start < end) {
-			if (tmp->vm_flags & VM_LOCKED) {
-				mm->locked_vm -= vma_pages(tmp);
-				munlock_vma_pages_all(tmp);
-			}
-
-			tmp = tmp->vm_next;
-		}
-	}
+	if (mm->locked_vm)
+		unlock_range(vma, end);
 
 	/* Detach vmas from rbtree */
 	if (!detach_vmas_to_be_unmapped(mm, vma, prev, end))
@@ -3180,14 +3187,8 @@ void exit_mmap(struct mm_struct *mm)
 		mmap_write_unlock(mm);
 	}
 
-	if (mm->locked_vm) {
-		vma = mm->mmap;
-		while (vma) {
-			if (vma->vm_flags & VM_LOCKED)
-				munlock_vma_pages_all(vma);
-			vma = vma->vm_next;
-		}
-	}
+	if (mm->locked_vm)
+		unlock_range(mm->mmap, ULONG_MAX);
 
 	arch_exit_mmap(mm);
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mm-mmap-introduce-unlock_range-for-code-cleanup.patch

