Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F53DC4332F
	for <mm-commits@archiver.kernel.org>; Sun, 16 Oct 2022 23:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiJPXwH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 19:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiJPXwG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 19:52:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5999B13FBA
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 16:52:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11A80B80E25
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 23:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C60C433C1;
        Sun, 16 Oct 2022 23:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665964321;
        bh=ojwlwU+xh0YIP+V3d/NezTuPcwpUk/a3G59v/78QfAc=;
        h=Date:To:From:Subject:From;
        b=bJCtsSPLDWFmOXNNHQfgnP0whA6qF1Cx3RdHbtk5FGXDKEKtn0GoKZNeAsZCtwRCg
         09BdXA1pw0C1lAb5L0ND3eFlowXULGsIHMY1ubSgaFcyGDvKEu1I9ZSRyXJ+XZn4tF
         avzXUR+MjwReWDdbKTT6eEp6kQHLYoMuyZDjQOUg=
Date:   Sun, 16 Oct 2022 16:52:00 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        oliver.sang@intel.com, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-mbind_range-arguments-to-vma_merge.patch added to mm-hotfixes-unstable branch
Message-Id: <20221016235201.B3C60C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix mbind_range() arguments to vma_merge()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mempolicy-fix-mbind_range-arguments-to-vma_merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-mbind_range-arguments-to-vma_merge.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/mempolicy: fix mbind_range() arguments to vma_merge()
Date: Sat, 15 Oct 2022 02:12:33 +0000

Fuzzing produced an invalid argument to vma_merge() which was caught
by the newly added verification of the number of VMAs being removed on
process exit.  Analyzing the failure eventually resulted in finding an
issue with the search of a VMA that started at address 0, which caused
an underflow and thus the loss of many VMAs being tracked in the tree.
Fix the underflow by changing the search of the maple tree to use the
start address directly.

Link: https://lkml.kernel.org/r/20221015021135.2816178-1-Liam.Howlett@oracle.com
Fixes: 66850be55e8e ("mm/mempolicy: use vma iterator & maple state instead of vma linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
  Link: https://lore.kernel.org/r/202210052318.5ad10912-oliver.sang@intel.com
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-mbind_range-arguments-to-vma_merge
+++ a/mm/mempolicy.c
@@ -787,17 +787,22 @@ static int vma_replace_policy(struct vm_
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
 {
-	MA_STATE(mas, &mm->mm_mt, start - 1, start - 1);
+	MA_STATE(mas, &mm->mm_mt, start, start);
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
 	pgoff_t pgoff;
 
-	prev = mas_find_rev(&mas, 0);
-	if (prev && (start < prev->vm_end))
-		vma = prev;
-	else
-		vma = mas_next(&mas, end - 1);
+	prev = mas_prev(&mas, 0);
+	if (unlikely(!prev))
+		mas_set(&mas, start);
+
+	vma = mas_find(&mas, end - 1);
+	if (WARN_ON(!vma))
+		return 0;
+
+	if (start > vma->vm_start)
+		prev = vma;
 
 	for (; vma; vma = mas_next(&mas, end - 1)) {
 		unsigned long vmstart = max(start, vma->vm_start);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mm-mempolicy-fix-mbind_range-arguments-to-vma_merge.patch

