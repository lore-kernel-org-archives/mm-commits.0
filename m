Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1013C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 19:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiGSTLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 15:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGSTLB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 15:11:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5FC958E
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 12:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D613C617D4
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 19:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED18EC341C6;
        Tue, 19 Jul 2022 19:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658257859;
        bh=53pARR+llgDGnmQaD5gmjxYOpf4PIHM0ihdu2S7JA9w=;
        h=Date:To:From:Subject:From;
        b=ShSkd0vS5c1SFjDYGl7Ytdnznqp1OK0me+3pxTOwgfBwkcyds0DKkPX+DR6tBiV7N
         RBNFvDBhNlmMprrUDzXPgj6mgn+A6LxfmfonRrB0Vwj3R6AB0Jhxl0TeVjWkKjExPS
         8hGbNepZ09SsWCibAeZbIS2CkBURS4dn92MofjI8=
Date:   Tue, 19 Jul 2022 12:10:58 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-maple-tree-for-unmapped_area_topdown-fix.patch added to mm-unstable branch
Message-Id: <20220719191058.ED18EC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: drop VM_BUG_ON() until better tested
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-use-maple-tree-for-unmapped_area_topdown-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-use-maple-tree-for-unmapped_area_topdown-fix.patch

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
Subject: mm/mmap: drop VM_BUG_ON() until better tested
Date: Tue, 19 Jul 2022 17:09:00 +0000

The limits that the maple tree return are trimmed so there is enough space.

Link: https://lkml.kernel.org/r/20220719170841.3298839-1-Liam.Howlett@oracle.com
Fixes: Fixes: 06fade172129 ("mm/mmap: use maple tree for unmapped_area{_topdown}")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-maple-tree-for-unmapped_area_topdown-fix
+++ a/mm/mmap.c
@@ -2037,8 +2037,6 @@ static unsigned long unmapped_area(struc
 
 	gap = mas.index;
 	gap += (info->align_offset - gap) & info->align_mask;
-	VM_BUG_ON(gap + info->length > info->high_limit);
-	VM_BUG_ON(gap + info->length > mas.last);
 	return gap;
 }
 
@@ -2068,8 +2066,6 @@ static unsigned long unmapped_area_topdo
 
 	gap = mas.last + 1 - info->length;
 	gap -= (gap - info->align_offset) & info->align_mask;
-	VM_BUG_ON(gap < info->low_limit);
-	VM_BUG_ON(gap < mas.index);
 	return gap;
 }
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
mm-mmap-use-maple-tree-for-unmapped_area_topdown-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

