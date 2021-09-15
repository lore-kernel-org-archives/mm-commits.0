Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEBCC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 23:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F390261164
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 23:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhIOX5b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232836AbhIOX5b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 19:57:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93E9E60D07;
        Wed, 15 Sep 2021 23:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631750171;
        bh=v3Av0PM50jou8KmHZTsbKF5QJXbQeF0kswFn/PkxELk=;
        h=Date:From:To:Subject:From;
        b=cooU+CJTsWTXK8foEpTPBSj9wl8V5Ks5AN3a0eZ+1M73SD9WAJkBbfg+mVYETeE8F
         iZCV2C2hgkHoB7+s0WYcVcSJVocrV98L3Upz8JUKCWqwhTAoq0vugkdyrovPLPf3E3
         rJ8ztwl8jTekWjkVvBtbhR0crGxeb4YJPsXtnJUU=
Date:   Wed, 15 Sep 2021 16:56:11 -0700
From:   akpm@linux-foundation.org
To:     liusirui@huawei.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, wuxu.wu@huawei.com,
        zhangyiru3@huawei.com
Subject:  + mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch
 added to -mm tree
Message-ID: <20210915235611.rP5mVvWK_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: remove mlock ulimit for SHM_HUGETLB
has been added to the -mm tree.  Its filename is
     mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch

