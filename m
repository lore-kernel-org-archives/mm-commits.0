Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739DEC43334
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jul 2022 18:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbiGFS74 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jul 2022 14:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiGFS7z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2022 14:59:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06621EAD7
        for <mm-commits@vger.kernel.org>; Wed,  6 Jul 2022 11:59:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A408CE2024
        for <mm-commits@vger.kernel.org>; Wed,  6 Jul 2022 18:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DC8C341CA;
        Wed,  6 Jul 2022 18:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657133991;
        bh=kEE/tYlpntzOJbOlBKAUtkw+NIXtzrmPhIHn2q+GWvM=;
        h=Date:To:From:Subject:From;
        b=D0jaVY1+d5FSEccF7WJ7C6BZiE2XEXnLn0nf2ZTSOXGFocAw903gvvdwoj1EdFtpE
         tU6hkBB1oQF7alFNJ+H2f4ah6fRTJnNp1773PAVCmNOXMCAV2i/gL2OahjlV4/eQMo
         6KFvRWZA4qyIU4Gk/hc7SKf/8Jd0OEhH6zMzRJWY=
Date:   Wed, 06 Jul 2022 11:59:50 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-vma-linked-list-fix-3.patch added to mm-unstable branch
Message-Id: <20220706185951.21DC8C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix copy_vma() new_vma check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-vma-linked-list-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-vma-linked-list-fix-3.patch

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
Subject: mm/mmap: fix copy_vma() new_vma check
Date: Wed, 6 Jul 2022 00:35:33 +0000

When checking new_vma limits to ensure they are not within where the copy
of the vma will be placed, ensure new_vma is not NULL.

Link: https://lkml.kernel.org/r/20220706003522.1827240-1-Liam.Howlett@oracle.com
Fixes: ded0cf440d9b (mm: remove the vma linked list)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-remove-the-vma-linked-list-fix-3
+++ a/mm/mmap.c
@@ -3347,7 +3347,7 @@ struct vm_area_struct *copy_vma(struct v
 	}
 
 	new_vma = find_vma_prev(mm, addr, &prev);
-	if (new_vma->vm_start < addr + len)
+	if (new_vma && new_vma->vm_start < addr + len)
 		return NULL;	/* should never get here */
 
 	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-remove-the-vma-linked-list-fix-3.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

