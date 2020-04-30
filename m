From: akpm@linux-foundation.org
Subject: +
 mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix.patch
 added to -mm tree
Date: Wed, 29 Apr 2020 18:51:49 -0700
Message-ID: <20200430015149.JTw5qwiaE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgD3Bvu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 21:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hulkci@huawei.com, minchan@kernel.org, mm-commits@vger.kernel.org, zhengbin13@huawei.com


The patch titled
     Subject: mm/madvise: make function 'do_process_madvise' static
has been added to the -mm tree.  Its filename is
     mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zheng Bin <zhengbin13@huawei.com>
Subject: mm/madvise: make function 'do_process_madvise' static

Fix sparse warnings:

mm/madvise.c:1233:9: warning: symbol 'do_process_madvise' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20200429014030.41147-1-zhengbin13@huawei.com
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
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

mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix.patch
