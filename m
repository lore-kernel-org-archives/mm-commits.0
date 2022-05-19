Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DE5C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 17:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242044AbiESRCH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 13:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbiESRCG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 13:02:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4ED7A454
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 10:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 504D2B8276B
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 17:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB81C385AA;
        Thu, 19 May 2022 17:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652979723;
        bh=GseQUU8ry8vKD8kcu2QLKZJK+r2G1d8NRcK54tn/tvw=;
        h=Date:To:From:Subject:From;
        b=vH0WZDwLrnRr0XYrYL8ihqZZfN0MlM+/TNT9Qt1myI2VVv5mOqSS9vWUQ6GeGPC7j
         F2VcXtUzP46pylGAsKXQqJwswuuGN7jB6JtyQgyFEGhOZJf4fwINaCnTqOLo4mpCoL
         AE3kRpOZuimF/1T1SSIHu/n5/zwfa0QzYDNAXdmA=
Date:   Thu, 19 May 2022 10:02:02 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch added to mm-unstable branch
Message-Id: <20220519170202.DEB81C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix do_brk_munmap() when munmapping multiple mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: fix do_brk_munmap() when munmapping multiple mappings
Date: Thu, 19 May 2022 15:05:22 +0000

If the newbrk is less than the last brk vma start, then munmap entire
VMA(s).

Link: https://lkml.kernel.org/r/20220519150509.1290067-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix
+++ a/mm/mmap.c
@@ -3056,8 +3056,7 @@ static int do_brk_munmap(struct ma_state
 
 	arch_unmap(mm, newbrk, oldbrk);
 
-	if (likely((vma->vm_end < oldbrk) ||
-		   ((vma->vm_start == newbrk) && (vma->vm_end == oldbrk)))) {
+	if (likely((vma->vm_end < oldbrk) || (vma->vm_start >= newbrk))) {
 		/* remove entire mapping(s) */
 		ret = do_mas_align_munmap(mas, vma, mm, newbrk, oldbrk, uf,
 					  true);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch
mm-remove-the-vma-linked-list-fix.patch

