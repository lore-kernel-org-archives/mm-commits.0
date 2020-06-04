From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 069/127] include/linux/mm.h: return true in
 cpupid_pid_unset()
Date: Thu, 04 Jun 2020 16:49:49 -0700
Message-ID: <20200604234949.BjXCcOXlG%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXtv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:51 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yanaijie@huawei.com

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
