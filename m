From: akpm@linux-foundation.org
Subject: [merged] mm-return-true-in-cpupid_pid_unset.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:18:50 -0700
Message-ID: <20200605201850.FJYexWJ8M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbgFEUSu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, yanaijie@huawei.com


The patch titled
     Subject: include/linux/mm.h: return true in cpupid_pid_unset()
has been removed from the -mm tree.  Its filename was
     mm-return-true-in-cpupid_pid_unset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1373,7 +1373,7 @@ static inline int cpu_pid_to_cpupid(int
 
 static inline bool cpupid_pid_unset(int cpupid)
 {
-	return 1;
+	return true;
 }
 
 static inline void page_cpupid_reset_last(struct page *page)
_

Patches currently in -mm which might be from yanaijie@huawei.com are
