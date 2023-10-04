Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5EBE7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbjJDURv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjJDURt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C018E93
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D60BC433C7;
        Wed,  4 Oct 2023 20:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450665;
        bh=f1FLx9Afb6qHbz80LBgUiKZr6sLepDhNQefHgatdenM=;
        h=Date:To:From:Subject:From;
        b=v2MPyLp35TnYrrQspVgy4JOZf3dnWk1gAJbDgrEdLLcIFf6dnhjKoH5HDaDPbI1ep
         bLoXW+XPKIUJk+ddRc/KwMDspU1I5LmQQOc1KhtQF7sKoc+WeOB4th9ocoHVAhqJ94
         eXAAnDyC0ruFz0geRWWFkMuVt0EgNwuYUPr2d6Nk=
Date:   Wed, 04 Oct 2023 13:17:43 -0700
To:     mm-commits@vger.kernel.org, bgeffon@google.com,
        anthony.yznaga@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-fix-unaccount-of-memory-on-vma_merge-failure.patch removed from -mm tree
Message-Id: <20231004201745.2D60BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mremap: fix unaccount of memory on vma_merge() failure
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-unaccount-of-memory-on-vma_merge-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm/mremap: fix unaccount of memory on vma_merge() failure
Date: Tue, 29 Aug 2023 17:45:49 -0700

Fix mremap so that only accounted memory is unaccounted if the mapping is
expandable but vma_merge() fails.

Link: https://lkml.kernel.org/r/20230830004549.16131-1-anthony.yznaga@oracle.com
Fixes: fdbef6149135 ("mm/mremap: don't account pages in vma_to_resize()")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-fix-unaccount-of-memory-on-vma_merge-failure
+++ a/mm/mremap.c
@@ -1037,12 +1037,14 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			pgoff_t extension_pgoff = vma->vm_pgoff +
 				((extension_start - vma->vm_start) >> PAGE_SHIFT);
 			VMA_ITERATOR(vmi, mm, extension_start);
+			long charged = 0;
 
 			if (vma->vm_flags & VM_ACCOUNT) {
 				if (security_vm_enough_memory_mm(mm, pages)) {
 					ret = -ENOMEM;
 					goto out;
 				}
+				charged = pages;
 			}
 
 			/*
@@ -1058,7 +1060,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 				vma->vm_file, extension_pgoff, vma_policy(vma),
 				vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 			if (!vma) {
-				vm_unacct_memory(pages);
+				vm_unacct_memory(charged);
 				ret = -ENOMEM;
 				goto out;
 			}
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are


