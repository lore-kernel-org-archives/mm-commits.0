Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD36C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbiEJEWB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236275AbiEJEUe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F6A2B09C2
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC456176A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30D8C385C2;
        Tue, 10 May 2022 04:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156126;
        bh=N+zQTidD3nJ9TIiYQMxJnU2ZwX4upkjVxpP/AokttvI=;
        h=Date:To:From:Subject:From;
        b=uhKEvxW94Gge3s5hFKD6D2AASMLWxpPTp4iSAg8SRB8/lvzGBynJmvuk2Y7btDPEW
         LkjKk8TZc6CqzSWB0+xvphhhrpPHebQj5vSd5szqxhLVsIjw2KfpSkptMoPKZ2nYS/
         dWKl+p3nTTee3yH1G1JJ/Eh0Ccn35uOFLFUrNue4=
Date:   Mon, 09 May 2022 21:15:26 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-fix-hugetlbfs_statfs-locking.patch removed from -mm tree
Message-Id: <20220510041526.D30D8C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: fix hugetlbfs_statfs() locking
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-hugetlbfs_statfs-locking.patch

This patch was dropped because it was merged into mm-stable

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
@@ -1048,12 +1048,12 @@ static int hugetlbfs_statfs(struct dentr
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


