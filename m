Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2EBC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 06:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7EEC6124D
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 06:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhKEGWx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 02:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhKEGWw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 02:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 381CD6120E;
        Fri,  5 Nov 2021 06:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636093213;
        bh=ibwqbvLijXLUGtS+dRwriANb8WnN7CphpUGpOUrNgZE=;
        h=Date:From:To:Subject:From;
        b=TV/wNkV+oWpBCkSdjoM8y3NEWAoe9fLoWjMi5CaO3ceVdKq28g/ejVGgJNeBj8I2Z
         A3YyjUxXIvafEK5cmEgksTPoyO6RncZKOFoncwkExA3CLHKeRC/9T9KgZBjwYDTYJm
         j54qLRqDNyrh7lFur47RRsygoYoF5+uFRn7j5yos=
Date:   Thu, 04 Nov 2021 23:20:12 -0700
From:   akpm@linux-foundation.org
To:     liusirui@huawei.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, wuxu.wu@huawei.com,
        zhangyiru3@huawei.com
Subject:  [to-be-updated]
 mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb.patch removed from -mm tree
Message-ID: <20211105062012.SgUtFp668%akpm@linux-foundation.org>
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

commit 21a3c273f88c9cbbaf7e ("mm, hugetlb: add thread name and pid to
SHM_HUGETLB mlock rlimit warning") marked this as deprecated in 2012, but
it is not deleted yet.

Mike says he still see that message in log files on occasion, so maybe we
should preserve this warning.

Link: https://lkml.kernel.org/r/20211009094355.127705-1-zhangyiru3@huawei.com
Signed-off-by: zhangyiru <zhangyiru3@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
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

mmhugetlb-remove-mlock-ulimit-for-shm_hugetlb-v8.patch

