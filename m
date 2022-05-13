Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBDDEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383838AbiEMTjf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383685AbiEMTje (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:39:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00AA4C433
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:39:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 821EAB83177
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35361C34100;
        Fri, 13 May 2022 19:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652470771;
        bh=+MvTIbhnfv8t9CF6DmkTSE0+6A1rXRhXFWD6iTR19IE=;
        h=Date:To:From:Subject:From;
        b=u7fNo18+1lfAyC/vBOYH7tHM+/8VnJ8oTwutFTljXOLFQ8le1m05kFY896oJlxrxm
         c+GycOPvNjKqK4/AnBO8bF7aQE8oJlHB/0D6Kj1h+Fd3M7SciAGcokJ0yplYp/R1Dv
         o3eG6Y6g4nsD4GGVxWYpXqV2DZOkl5qc1I3yJH/k=
Date:   Fri, 13 May 2022 12:39:30 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        quic_qiancai@quicinc.com, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-vma-linked-list-fix.patch added to mm-unstable branch
Message-Id: <20220513193931.35361C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix potential leak on do_mas_align_munmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-vma-linked-list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-vma-linked-list-fix.patch

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
Subject: mm/mmap: fix potential leak on do_mas_align_munmap()
Date: Fri, 13 May 2022 14:15:53 +0000

There is a leak when the system is low on resources and fails to allocate
enough memory to complete the munmap task.  Fix this by adding the
necessary free operations in the unwinding.

Link: https://lkml.kernel.org/r/20220513141548.2019143-1-Liam.Howlett@oracle.com
Fixes: a760774e7b7b (mm: start tracking VMAs with maple tree)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Qian Cai <quic_qiancai@quicinc.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-remove-the-vma-linked-list-fix
+++ a/mm/mmap.c
@@ -2394,7 +2394,7 @@ do_mas_align_munmap(struct ma_state *mas
 		return -ENOMEM;
 
 	if (mas_preallocate(&mas_detach, vma, GFP_KERNEL))
-		return -ENOMEM;
+		goto detach_alloc_fail;
 
 	mas->last = end - 1;
 	/*
@@ -2533,6 +2533,8 @@ do_mas_align_munmap(struct ma_state *mas
 map_count_exceeded:
 split_failed:
 userfaultfd_error:
+	mas_destroy(&mas_detach);
+detach_alloc_fail:
 	mas_destroy(mas);
 	return error;
 }
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-remove-the-vma-linked-list-fix.patch

