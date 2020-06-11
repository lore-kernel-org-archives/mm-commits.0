From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix.patch
 removed from -mm tree
Date: Wed, 10 Jun 2020 18:24:02 -0700
Message-ID: <20200611012402.GchxL3aVh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgFKBYE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:24:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christian.brauner@ubuntu.com, hulkci@huawei.com, minchan@kernel.org, mm-commits@vger.kernel.org, zhengbin13@huawei.com


The patch titled
     Subject: mm/madvise: make function 'do_process_madvise' static
has been removed from the -mm tree.  Its filename was
     mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix.patch

This patch was dropped because it was folded into mm-support-vector-address-ranges-for-process_madvise.patch

------------------------------------------------------
From: Zheng Bin <zhengbin13@huawei.com>
Subject: mm/madvise: make function 'do_process_madvise' static

Fix sparse warnings:

mm/madvise.c:1233:9: warning: symbol 'do_process_madvise' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20200429014030.41147-1-zhengbin13@huawei.com
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix
+++ a/mm/madvise.c
@@ -1230,8 +1230,8 @@ static int process_madvise_vec(struct ta
 	return ret;
 }
 
-ssize_t do_process_madvise(int which, pid_t upid, struct iov_iter *iter,
-				int behavior, unsigned long flags)
+static ssize_t do_process_madvise(int which, pid_t upid, struct iov_iter *iter,
+				       int behavior, unsigned long flags)
 {
 	ssize_t ret;
 	struct pid *pid;
_

Patches currently in -mm which might be from zhengbin13@huawei.com are

mm-pass-task-and-mm-to-do_madvise.patch
mm-support-vector-address-ranges-for-process_madvise.patch
