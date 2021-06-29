Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B3CC11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39B0A61D0E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhF2ClJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231799AbhF2ClI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4106861D0C;
        Tue, 29 Jun 2021 02:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934322;
        bh=Umd1ZCB/WtJvlcANLzbutnuP9MbWieimlFgAKsB7+8c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s/y7YiSeBAMJohqRML3I/bmZkMuuRPsITLn+XbT7AlJPVdHGC5ow9f/8XqBsB6Zk7
         uKKl81pdt2MaKJ2R2/QXPrvBkvLX/hqHB1eI6KKm4tfFgPPCaJ6g8H9jJ8z9AdGBKQ
         Qrv2aiEw/L1TN/fg3N1TvxCut+TLktcIb1jnEAEU=
Date:   Mon, 28 Jun 2021 19:38:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dbueso@suse.de, Liam.Howlett@Oracle.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 102/192] mm/mmap: introduce unlock_range() for
 code cleanup
Message-ID: <20210629023841.dhCGefCXY%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: introduce unlock_range() for code cleanup

Both __do_munmap() and exit_mmap() unlock a range of VMAs using almost
identical code blocks.  Replace both blocks by a static inline function.

[akpm@linux-foundation.org: tweak code layout]
Link: https://lkml.kernel.org/r/20210510211021.2797427-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

--- a/mm/mmap.c~mm-mmap-introduce-unlock_range-for-code-cleanup
+++ a/mm/mmap.c
@@ -2802,6 +2802,22 @@ int split_vma(struct mm_struct *mm, stru
 	return __split_vma(mm, vma, addr, new_below);
 }
 
+static inline void
+unlock_range(struct vm_area_struct *start, unsigned long limit)
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
