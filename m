From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-return-true-in-cpupid_pid_unset.patch added to -mm
 tree
Date: Thu, 23 Apr 2020 18:17:35 -0700
Message-ID: <20200424011735.mPl-ZKRov%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgDXBRh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 21:17:37 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, yanaijie@huawei.com


The patch titled
     Subject: include/linux/mm.h: return true in cpupid_pid_unset()
has been added to the -mm tree.  Its filename is
     mm-return-true-in-cpupid_pid_unset.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-return-true-in-cpupid_pid_unset.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-return-true-in-cpupid_pid_unset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Yan <yanaijie@huawei.com>
Subject: include/linux/mm.h: return true in cpupid_pid_unset()

Fix the following coccicheck warning:

include/linux/mm.h:1371:8-9: WARNING: return of 0/1 in function
'cpupid_pid_unset' with return type bool

Link: http://lkml.kernel.org/r/20200422071816.48879-1-yanaijie@huawei.com
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-return-true-in-cpupid_pid_unset
+++ a/include/linux/mm.h
@@ -1367,7 +1367,7 @@ static inline int cpu_pid_to_cpupid(int
 
 static inline bool cpupid_pid_unset(int cpupid)
 {
-	return 1;
+	return true;
 }
 
 static inline void page_cpupid_reset_last(struct page *page)
_

Patches currently in -mm which might be from yanaijie@huawei.com are

mm-return-true-in-cpupid_pid_unset.patch
userc-make-uidhash_table-static.patch
lib-test_lockupc-make-test_inode-static.patch
