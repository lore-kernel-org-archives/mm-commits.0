Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C63AC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 18:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244013AbiESSeM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 14:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244021AbiESSeL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 14:34:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC5D9C2E7
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 11:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2307261AE1
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 18:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE9DC385AA;
        Thu, 19 May 2022 18:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652985248;
        bh=dcIgY+1M8kYx+knXWsz8kCGU0LgAtG3BQ2b/xsKCq8c=;
        h=Date:To:From:Subject:From;
        b=zb+7V83xLOuzY/NBpTcRYfrkVplRkCKIYHaDzPRHfM/4IXxoqFGrOAV6r11h3KCz/
         7gHrb/gEL4OTpl1DCLkXhFlA8Xw6h4aXyBxx9Gn+Zu24gFJTQvs7FSIs9xhLz5KRZm
         XRP0v/gZ8fapfn3elgUkFuVMjJYvHFWP2TaKl9GE=
Date:   Thu, 19 May 2022 11:34:07 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+ee1fdd8dcc770a3a169a@syzkaller.appspotmail.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch added to mm-unstable branch
Message-Id: <20220519183408.7AE9DC385AA@smtp.kernel.org>
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


