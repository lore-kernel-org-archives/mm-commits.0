Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4615C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD4B960C3D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhGFTO5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhGFTO4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AFA561206;
        Tue,  6 Jul 2021 19:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598736;
        bh=nrSUpqJFP6M3TFUIyD3FVIOw+Jn7DpnAWdzyYennl/Q=;
        h=Date:From:To:Subject:From;
        b=G8QQOeThW0F9UO8hW166K1sdt1RwWLwAuMkM4/EhREpCoFCqg/nqHO8265LRDj6xO
         H6gihXFhx8xDUIyAb9bHp78Q2poPDL3WG2MiWTufiEnMQlCq+esnu6IaHdEiimqFa0
         SSdxPX406TiMntklq5pQ+SZun2gK6A9s8khBfPFw=
Date:   Tue, 06 Jul 2021 12:12:16 -0700
From:   akpm@linux-foundation.org
To:     dbueso@suse.de, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 mm-mmap-introduce-unlock_range-for-code-cleanup.patch removed from -mm tree
Message-ID: <20210706191216.2FMZbYcYc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: introduce unlock_range() for code cleanup
has been removed from the -mm tree.  Its filename was
     mm-mmap-introduce-unlock_range-for-code-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from liam.howlett@oracle.com are


