Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B00C6FD18
	for <mm-commits@archiver.kernel.org>; Wed, 19 Apr 2023 21:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjDSVYn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Apr 2023 17:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjDSVYm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Apr 2023 17:24:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5687ED8
        for <mm-commits@vger.kernel.org>; Wed, 19 Apr 2023 14:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9DB9642E8
        for <mm-commits@vger.kernel.org>; Wed, 19 Apr 2023 21:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F27BC433D2;
        Wed, 19 Apr 2023 21:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681939382;
        bh=eNpfJYoYQuEjtyDkvP4BSBEGwFHLW7dYa/grVfloK7s=;
        h=Date:To:From:Subject:From;
        b=ID3J6wCbaB6FCFOeTo/rjK4yaq97XcNP+CKnWLJjwJqBapLiMqI82134Fta9p7IlF
         piOrELNPSMAzDkGi/2Qnx7nnokkER3q8znllxDeE4ZvgEP6MKS4Ay3htkYJHRUsbMP
         BG0JA3b6KFARrmQpy0UHfFvWhaPgUys35OKZzgOc=
Date:   Wed, 19 Apr 2023 14:23:01 -0700
To:     mm-commits@vger.kernel.org, linux@armlinux.org.uk,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-mmap_min_addr-logic-from-callers-into-vm_unmapped_area.patch added to mm-unstable branch
Message-Id: <20230419212302.2F27BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move 'mmap_min_addr' logic from callers into vm_unmapped_area()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-mmap_min_addr-logic-from-callers-into-vm_unmapped_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-mmap_min_addr-logic-from-callers-into-vm_unmapped_area.patch

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
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: mm: move 'mmap_min_addr' logic from callers into vm_unmapped_area()
Date: Tue, 18 Apr 2023 17:40:09 -0400

Instead of having callers care about the mmap_min_addr logic for the
lowest valid mapping address (and some of them getting it wrong), just
move the logic into vm_unmapped_area() itself.  One less thing for various
architecture cases (and generic helpers) to worry about.

We should really try to make much more of this be common code, but baby
steps..

Without this, vm_unmapped_area() could return an address below
mmap_min_addr (because some caller forgot about that).  That then causes
the mmap machinery to think it has found a workable address, but then
later security_mmap_addr(addr) is unhappy about it and the mmap() returns
with a nonsensical error (EPERM).

The proper action is to either return ENOMEM (if the virtual address space
is exhausted), or try to find another address (ie do a bottom-up search
for free addresses after the top-down one failed).

See commit 2afc745f3e30 ("mm: ensure get_unmapped_area() returns higher
address than mmap_min_addr"), which fixed this for one call site (the
generic arch_get_unmapped_area_topdown() fallback) but left other cases
alone.

Link: https://lkml.kernel.org/r/20230418214009.1142926-1-Liam.Howlett@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/hugetlbpage.c |    2 +-
 arch/s390/mm/mmap.c        |    2 +-
 fs/hugetlbfs/inode.c       |    2 +-
 mm/mmap.c                  |   19 +++++++++++++------
 4 files changed, 16 insertions(+), 9 deletions(-)

--- a/arch/s390/mm/hugetlbpage.c~mm-move-mmap_min_addr-logic-from-callers-into-vm_unmapped_area
+++ a/arch/s390/mm/hugetlbpage.c
@@ -273,7 +273,7 @@ static unsigned long hugetlb_get_unmappe
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = current->mm->mmap_base;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
--- a/arch/s390/mm/mmap.c~mm-move-mmap_min_addr-logic-from-callers-into-vm_unmapped_area
+++ a/arch/s390/mm/mmap.c
@@ -136,7 +136,7 @@ unsigned long arch_get_unmapped_area_top
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
 	if (filp || (flags & MAP_SHARED))
 		info.align_mask = MMAP_ALIGN_MASK << PAGE_SHIFT;
--- a/fs/hugetlbfs/inode.c~mm-move-mmap_min_addr-logic-from-callers-into-vm_unmapped_area
+++ a/fs/hugetlbfs/inode.c
@@ -208,7 +208,7 @@ hugetlb_get_unmapped_area_topdown(struct
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
--- a/mm/mmap.c~mm-move-mmap_min_addr-logic-from-callers-into-vm_unmapped_area
+++ a/mm/mmap.c
@@ -1548,7 +1548,8 @@ static inline int accountable_mapping(st
  */
 static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap, low_limit;
+	unsigned long length, gap;
+	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
@@ -1559,8 +1560,11 @@ static unsigned long unmapped_area(struc
 		return -ENOMEM;
 
 	low_limit = info->low_limit;
+	if (low_limit < mmap_min_addr)
+		low_limit = mmap_min_addr;
+	high_limit = info->high_limit;
 retry:
-	if (mas_empty_area(&mas, low_limit, info->high_limit - 1, length))
+	if (mas_empty_area(&mas, low_limit, high_limit - 1, length))
 		return -ENOMEM;
 
 	gap = mas.index;
@@ -1596,7 +1600,8 @@ retry:
  */
 static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap, high_limit, gap_end;
+	unsigned long length, gap, gap_end;
+	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
@@ -1605,10 +1610,12 @@ static unsigned long unmapped_area_topdo
 	if (length < info->length)
 		return -ENOMEM;
 
+	low_limit = info->low_limit;
+	if (low_limit < mmap_min_addr)
+		low_limit = mmap_min_addr;
 	high_limit = info->high_limit;
 retry:
-	if (mas_empty_area_rev(&mas, info->low_limit, high_limit - 1,
-				length))
+	if (mas_empty_area_rev(&mas, low_limit, high_limit - 1, length))
 		return -ENOMEM;
 
 	gap = mas.last + 1 - info->length;
@@ -1743,7 +1750,7 @@ generic_get_unmapped_area_topdown(struct
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
 	info.align_mask = 0;
 	info.align_offset = 0;
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

mm-move-mmap_min_addr-logic-from-callers-into-vm_unmapped_area.patch

