Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFD2C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E351860F38
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhJJVFx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 17:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232815AbhJJVFw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 17:05:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A37F360F22;
        Sun, 10 Oct 2021 21:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633899833;
        bh=VGhU8zZeFAyP+17RTQ294+6Vus74B0tydd+ovyJ2yrM=;
        h=Date:From:To:Subject:From;
        b=nKVS9wJk+0vlWznCoIdP2Eq8JBbnZbpTyygC97TXG0mFXZ59MtiMSeNLsBP8XmT6k
         2/V5rECWJ4JRfc/akXhDOCqFP5Pn+3m9B6mDpjpJNfg/tB34KdmePXjCRhniGupY0M
         m573YKplVdANvNH7/03bw4hkdiiye/AUPSngmr30=
Date:   Sun, 10 Oct 2021 14:03:53 -0700
From:   akpm@linux-foundation.org
To:     liusirui@huawei.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, wuxu.wu@huawei.com,
        zhangyiru3@huawei.com
Subject:  + mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch
 added to -mm tree
Message-ID: <20211010210353.Lbzp7TL-G%akpm@linux-foundation.org>
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

commit 21a3c273f88c9cbbaf7e ("mm, hugetlb: add thread name and pid to
SHM_HUGETLB mlock rlimit warning") marked this as deprecated in 2012, but
it is not deleted yet.

Mike says he still see that message in log files on occasion, so maybe we
should preserve this warning.

Link: https://lkml.kernel.org/r/20211009094355.127705-1-zhangyiru3@huawei.com
Signed-off-by: zhangyiru <zhangyiru3@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <wuxu.wu@huawei.com>
Cc: <liusirui@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/hugetlbfs/inode.c~mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb
+++ a/fs/hugetlbfs/inode.c
@@ -1467,13 +1467,12 @@ struct file *hugetlb_file_setup(const ch
 		*ucounts = current_ucounts();
 		if (user_shm_lock(size, *ucounts)) {
 			task_lock(current);
-			pr_warn_once("%s (%d): Using mlock ulimits for SHM_HUGETLB is deprecated\n",
+			pr_warn_once("%s (%d): Using mlock ulimits for SHM_HUGETLB is obsolete\n",
 				current->comm, current->pid);
 			task_unlock(current);
-		} else {
-			*ucounts = NULL;
-			return ERR_PTR(-EPERM);
 		}
+		*ucounts = NULL;
+		return ERR_PTR(-EPERM);
 	}
 
 	file = ERR_PTR(-ENOSPC);
_

Patches currently in -mm which might be from zhangyiru3@huawei.com are

mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch

