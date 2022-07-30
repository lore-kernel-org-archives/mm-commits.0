Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9818BC3F6B0
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239741AbiG3BJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbiG3BI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F3F87F5A
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 960B061BF4
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A27C433C1;
        Sat, 30 Jul 2022 01:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143331;
        bh=p8FAkKEGam9SOMZVr+7Q1rVOE55n0P3N7eUR5caRnN0=;
        h=Date:To:From:Subject:From;
        b=d8t3X/g4B2kyQDJr+PDRSocjWZxsQL5m1fnUojkpkYVuyqsOMAdC+Ki2A+0nxcqJ2
         p4xb9xepVwiCfLUBgmxu7+3KjstkRNHARYc2Rn+69+igWy5PlIJZGuCT/9rVQEDIBL
         /IioL2ULcY3JSSaHENF8RH8JzC8EZpQtldHvuxBI=
Date:   Fri, 29 Jul 2022 18:08:50 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-fix-inaccurate-comment-in-hugetlbfs_statfs.patch removed from -mm tree
Message-Id: <20220730010850.E5A27C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: fix inaccurate comment in hugetlbfs_statfs()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-inaccurate-comment-in-hugetlbfs_statfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: fix inaccurate comment in hugetlbfs_statfs()
Date: Tue, 26 Jul 2022 22:29:18 +0800

In some cases, e.g.  when size option is not specified, f_blocks, f_bavail
and f_bfree will be set to -1 instead of 0.  Likewise, when nr_inodes
isn't specified, f_files and f_ffree will be set to -1 too.  Update the
comment to make this clear.

Link: https://lkml.kernel.org/r/20220726142918.51693-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-inaccurate-comment-in-hugetlbfs_statfs
+++ a/fs/hugetlbfs/inode.c
@@ -1090,7 +1090,7 @@ static int hugetlbfs_statfs(struct dentr
 	buf->f_bsize = huge_page_size(h);
 	if (sbinfo) {
 		spin_lock(&sbinfo->stat_lock);
-		/* If no limits set, just report 0 for max/free/used
+		/* If no limits set, just report 0 or -1 for max/free/used
 		 * blocks, like simple_statfs() */
 		if (sbinfo->spool) {
 			long free_pages;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

