From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 010/155] ocfs2: there is no need to log twice in
 several functions
Date: Wed, 01 Apr 2020 21:03:35 -0700
Message-ID: <20200402040335.7u45Tn9WV%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEDg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:03:36 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org, wangyan122@huawei.com

From: wangyan <wangyan122@huawei.com>
Subject: ocfs2: there is no need to log twice in several functions

There is no need to log twice in several functions.

Link: http://lkml.kernel.org/r/77eec86a-f634-5b98-4f7d-0cd15185a37b@huawei.com
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c    |    1 -
 fs/ocfs2/suballoc.c |    5 -----
 2 files changed, 6 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-there-is-no-need-to-log-twice-in-several-functions
+++ a/fs/ocfs2/alloc.c
@@ -1060,7 +1060,6 @@ bail:
 			brelse(bhs[i]);
 			bhs[i] = NULL;
 		}
-		mlog_errno(status);
 	}
 	return status;
 }
--- a/fs/ocfs2/suballoc.c~ocfs2-there-is-no-need-to-log-twice-in-several-functions
+++ a/fs/ocfs2/suballoc.c
@@ -2509,9 +2509,6 @@ static int _ocfs2_free_suballoc_bits(han
 
 bail:
 	brelse(group_bh);
