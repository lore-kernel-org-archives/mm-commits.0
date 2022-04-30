Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD309C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 30 Apr 2022 18:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244122AbiD3Sng (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 30 Apr 2022 14:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244117AbiD3Sng (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 30 Apr 2022 14:43:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF4D617C
        for <mm-commits@vger.kernel.org>; Sat, 30 Apr 2022 11:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB85E6103D
        for <mm-commits@vger.kernel.org>; Sat, 30 Apr 2022 18:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCC1C385A7;
        Sat, 30 Apr 2022 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651344012;
        bh=rZGSNCSodmyR2B8XJiF4TEXZBoc1+slXUxNQAHR5VTg=;
        h=Date:To:From:Subject:From;
        b=os0t+QwWjnPcWY/6ri2mWz2cZ3SYggDq2Km+dTSRLoOMCnTdT5OmfK7UBcSvi4IPh
         pfsO/zmJNWTJPzCGojhlaJ/xJg7mVPChj+JiC4IXbvOAC4UQX3w/W/f+o/6nQYYKMM
         mGUM41yO4Mh0Sc/R8U45NikYB4P4KLRdVJgdvnBQ=
Date:   Sat, 30 Apr 2022 11:40:11 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-fix-hugetlbfs_statfs-locking.patch added to mm-unstable branch
Message-Id: <20220430184012.2CCC1C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix hugetlbfs_statfs() locking
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-fix-hugetlbfs_statfs-locking.patch

This patch should soon appear in the mm-unstable branch at
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
From: Mina Almasry <almasrymina@google.com>
Subject: hugetlbfs: fix hugetlbfs_statfs() locking

After commit db71ef79b59b ("hugetlb: make free_huge_page irq safe"), the
subpool lock should be locked with spin_lock_irq() and all call sites was
modified as such, except for the ones in hugetlbfs_statfs().

Link: https://lkml.kernel.org/r/20220429202207.3045-1-almasrymina@google.com
Fixes: db71ef79b59b ("hugetlb: make free_huge_page irq safe")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-hugetlbfs_statfs-locking
+++ a/fs/hugetlbfs/inode.c
@@ -1051,12 +1051,12 @@ static int hugetlbfs_statfs(struct dentr
 		if (sbinfo->spool) {
 			long free_pages;
 
-			spin_lock(&sbinfo->spool->lock);
+			spin_lock_irq(&sbinfo->spool->lock);
 			buf->f_blocks = sbinfo->spool->max_hpages;
 			free_pages = sbinfo->spool->max_hpages
 				- sbinfo->spool->used_hpages;
 			buf->f_bavail = buf->f_bfree = free_pages;
-			spin_unlock(&sbinfo->spool->lock);
+			spin_unlock_irq(&sbinfo->spool->lock);
 			buf->f_files = sbinfo->max_inodes;
 			buf->f_ffree = sbinfo->free_inodes;
 		}
_

Patches currently in -mm which might be from almasrymina@google.com are

hugetlbfs-fix-hugetlbfs_statfs-locking.patch

