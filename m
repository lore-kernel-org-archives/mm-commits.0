Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C54EC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 22:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiFKWDT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 18:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbiFKWDR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 18:03:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A403B2AB
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 15:03:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF339B80B3E
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 22:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32D6C34116;
        Sat, 11 Jun 2022 22:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654984993;
        bh=qgcp3zU6uTudzJzRARrDWcPGqd4rHDnk46Abi6VCO6E=;
        h=Date:To:From:Subject:From;
        b=ZBEjzblwxm7UBh6ksbcXt5Uw6DM2+osLuqPaSBHUlKk+M9WY5Uop3K53GohIgswCQ
         9oVGYe5uMV9dfOxFw8hpuC+TgBtxrSq98XB9wVRnm8+gY499sjj14iIPFQs3AAbdY4
         zOoyvdFfVxz8Yar7fdGe/16QA0Z2hifZDtiJmoWU=
Date:   Sat, 11 Jun 2022 15:03:12 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+ee1fdd8dcc770a3a169a@syzkaller.appspotmail.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch added to mm-unstable branch
Message-Id: <20220611220313.A32D6C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: qvoid dereferencing next on null in BUG_ON()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch

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
Subject: mm/mmap: qvoid dereferencing next on null in BUG_ON()
Date: Thu, 19 May 2022 15:04:50 +0000

Check there is a next before checking the bounds.

Link: https://lkml.kernel.org/r/20220519150442.1289962-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: <syzbot+ee1fdd8dcc770a3a169a@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2
+++ a/mm/mmap.c
@@ -685,7 +685,7 @@ inline int vma_expand(struct ma_state *m
 	}
 
 	/* Not merging but overwriting any part of next is not handled. */
-	VM_BUG_ON(!remove_next && next != vma && end > next->vm_start);
+	VM_BUG_ON(next && !remove_next && next != vma && end > next->vm_start);
 	/* Only handles expanding */
 	VM_BUG_ON(vma->vm_start < start || vma->vm_end > end);
 
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

