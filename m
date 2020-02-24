From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 ocfs2-there-is-no-need-to-log-twice-in-several-functions.patch added to -mm
 tree
Date: Sun, 23 Feb 2020 19:31:10 -0800
Message-ID: <20200224033110.j3nTFeWpN%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbgBXDbL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 22:31:11 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, wangyan122@huawei.com


The patch titled
     Subject: ocfs2: there is no need to log twice in several functions
has been added to the -mm tree.  Its filename is
     ocfs2-there-is-no-need-to-log-twice-in-several-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-there-is-no-need-to-log-twice-in-several-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-there-is-no-need-to-log-twice-in-several-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: wangyan <wangyan122@huawei.com>
Subject: ocfs2: there is no need to log twice in several functions

There is no need to log twice in several functions.

Link: http://lkml.kernel.org/r/77eec86a-f634-5b98-4f7d-0cd15185a37b@huawei.com
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
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
