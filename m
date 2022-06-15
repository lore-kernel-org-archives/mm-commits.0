Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DB8C43334
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 20:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbiFOURE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 16:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240566AbiFOURD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 16:17:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7E24B86D
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 13:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81878B81DDA
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 20:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE1AC3411B;
        Wed, 15 Jun 2022 20:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655324220;
        bh=FjcnmU1l8jz3gtTTCXRuLdMkIk3TUgTFEmMfz7oY3HE=;
        h=Date:To:From:Subject:From;
        b=pSdufatg1LmxuYl4oBCvOVbgoumcVyw/bNCJptqjzI3n7PWey9w+VvYa7kQZ9nnLE
         zLtZkkcrR2Gv/XJ3RZjec6kYzxEvMM/SWM+GhjlcWEnBu25M6P3krH1qiiOdfNIEK5
         ezGgdgcCU2dyufyLc6brem9GObZPnxj3F+8kW0E0=
Date:   Wed, 15 Jun 2022 13:16:59 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch added to mm-unstable branch
Message-Id: <20220615201700.1BE1AC3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: drop dead code in count_mm_mlocked_page_nr()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

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
Subject: mm/mlock: drop dead code in count_mm_mlocked_page_nr()
Date: Wed, 15 Jun 2022 17:40:58 +0000

The check for mm being null has never been needed since the only caller
has always passed in current->mm.  Remove the check from
count_mm_mlocked_page_nr().

Link: https://lkml.kernel.org/r/20220615174050.738523-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mlock.c~mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr
+++ a/mm/mlock.c
@@ -531,14 +531,12 @@ static unsigned long count_mm_mlocked_pa
 	unsigned long end;
 	VMA_ITERATOR(vmi, mm, start);
 
-	if (mm == NULL)
-		mm = current->mm;
-
 	/* Don't overflow past ULONG_MAX */
 	if (unlikely(ULONG_MAX - len < start))
 		end = ULONG_MAX;
 	else
 		end = start + len;
+
 	for_each_vma_range(vmi, vma, end) {
 		if (vma->vm_flags & VM_LOCKED) {
 			if (start > vma->vm_start)
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
maple-tree-add-new-data-structure-fix-7.patch
maple-tree-add-new-data-structure-fix-8.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix-3.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch
mm-remove-the-vma-linked-list-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

