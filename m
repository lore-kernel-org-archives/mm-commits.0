Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54435C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A82160F45
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhJJVEp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 17:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhJJVEp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 17:04:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC4396054F;
        Sun, 10 Oct 2021 21:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633899766;
        bh=KhnPbYGAVuhxzjSnyAZXSDQL15R5AfsoZaq1elZhnEc=;
        h=Date:From:To:Subject:From;
        b=be+oiDyyFYHaJNiiZAFZV3AcjcOp1AtKsRH5WAl48++hmmy6ByAM76Ra65QsS41dL
         AKxPEtEd+1y3tGFtrBnK74L0fVHQg9cNczihDHs0yY/DNX/781tqg3ILkPdv5ZaFaZ
         H0lFl/fJ1Rq8iyqHpkWildIT0EM3JexCVouVNGc4=
Date:   Sun, 10 Oct 2021 14:02:45 -0700
From:   akpm@linux-foundation.org
To:     liusirui@huawei.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, wuxu.wu@huawei.com,
        zhangyiru3@huawei.com
Subject:  [to-be-updated]
 mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch removed from -mm tree
Message-ID: <20211010210245.Zx1u9f7EJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: remove mlock ulimit for SHM_HUGETLB
has been removed from the -mm tree.  Its filename was
     mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: zhangyiru <zhangyiru3@huawei.com>
Subject: mm,hugetlb: remove mlock ulimit for SHM_HUGETLB

Remove mlock ulimit for SHM_HUGETLB.  2584e517320b ("mm: reintroduce and
deprecate rlimit based access for SHM_HUGETLB") marked this as deprecated
in 2012, but it is not deleted yet

Link: https://lkml.kernel.org/r/20210904075458.51012-1-zhangyiru3@huawei.com
Signed-off-by: zhangyiru <zhangyiru3@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <wuxu.wu@huawei.com>
Cc: <liusirui@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/fs/hugetlbfs/inode.c~mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb
+++ a/fs/hugetlbfs/inode.c
@@ -1463,18 +1463,8 @@ struct file *hugetlb_file_setup(const ch
 	if (!mnt)
 		return ERR_PTR(-ENOENT);
 
-	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
-		*ucounts = current_ucounts();
-		if (user_shm_lock(size, *ucounts)) {
-			task_lock(current);
-			pr_warn_once("%s (%d): Using mlock ulimits for SHM_HUGETLB is deprecated\n",
-				current->comm, current->pid);
-			task_unlock(current);
-		} else {
-			*ucounts = NULL;
-			return ERR_PTR(-EPERM);
-		}
-	}
+	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm())
+		return ERR_PTR(-EPERM);
 
 	file = ERR_PTR(-ENOSPC);
 	inode = hugetlbfs_get_inode(mnt->mnt_sb, NULL, S_IFREG | S_IRWXUGO, 0);
_

Patches currently in -mm which might be from zhangyiru3@huawei.com are


