From: akpm@linux-foundation.org
Subject: [merged]
 mm-migratec-call-detach_page_private-to-cleanup-code.patch removed from -mm
 tree
Date: Tue, 02 Jun 2020 14:39:39 -0700
Message-ID: <20200602213939.Zt5UfdLjh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVjk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:39:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dchinner@redhat.com, ebiggers@google.com, gaoxiang25@huawei.com, guoqing.jiang@cloud.ionos.com, jaegeuk@kernel.org, jhubbard@nvidia.com, johannes.thumshirn@wdc.com, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, mszeredi@redhat.com, xiyou.wangcong@gmail.com, yuchao0@huawei.com, ziy@nvidia.com


The patch titled
     Subject: mm/migrate.c: call detach_page_private to cleanup code
has been removed from the -mm tree.  Its filename was
     mm-migratec-call-detach_page_private-to-cleanup-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: mm/migrate.c: call detach_page_private to cleanup code

We can cleanup code a little by call detach_page_private here.

[akpm@linux-foundation.org: use attach_page_private(), per Dave]
  http://lkml.kernel.org/r/20200521225220.GV2005@dread.disaster.area
[akpm@linux-foundation.org: clear PagePrivate]
Link: http://lkml.kernel.org/r/20200519214049.15179-1-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Gao Xiang <gaoxiang25@huawei.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/migrate.c~mm-migratec-call-detach_page_private-to-cleanup-code
+++ a/mm/migrate.c
@@ -797,10 +797,7 @@ recheck_buffers:
 	if (rc != MIGRATEPAGE_SUCCESS)
 		goto unlock_buffers;
 
-	ClearPagePrivate(page);
-	set_page_private(newpage, page_private(page));
-	set_page_private(page, 0);
-	put_page(page);
+	attach_page_private(newpage, detach_page_private(page));
 	get_page(newpage);
 
 	bh = head;
@@ -810,8 +807,6 @@ recheck_buffers:
 
 	} while (bh != head);
 
-	SetPagePrivate(newpage);
