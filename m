From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 ocfs2-correct-annotation-from-l_next_rec-to-l_next_free_rec.patch added to
 -mm tree
Date: Sun, 23 Feb 2020 19:31:13 -0800
Message-ID: <20200224033113.ZZiCdtHNP%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbgBXDbO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 22:31:14 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, wangyan122@huawei.com


The patch titled
     Subject: ocfs2: correct annotation from "l_next_rec" to "l_next_free_rec"
has been added to the -mm tree.  Its filename is
     ocfs2-correct-annotation-from-l_next_rec-to-l_next_free_rec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-correct-annotation-from-l_next_rec-to-l_next_free_rec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-correct-annotation-from-l_next_rec-to-l_next_free_rec.patch

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
Subject: ocfs2: correct annotation from "l_next_rec" to "l_next_free_rec"

Correct annotation from "l_next_rec" to "l_next_free_rec"

Link: http://lkml.kernel.org/r/5e76c953-3479-1280-023c-ad05e4c75608@huawei.com
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

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-correct-annotation-from-l_next_rec-to-l_next_free_rec
+++ a/fs/ocfs2/alloc.c
@@ -3941,7 +3941,7 @@ rotate:
 	 * above.
 	 *
 	 * This leaf needs to have space, either by the empty 1st
-	 * extent record, or by virtue of an l_next_rec < l_count.
+	 * extent record, or by virtue of an l_next_free_rec < l_count.
 	 */
 	ocfs2_rotate_leaf(el, insert_rec);
 }
_

Patches currently in -mm which might be from wangyan122@huawei.com are

ocfs2-there-is-no-need-to-log-twice-in-several-functions.patch
ocfs2-correct-annotation-from-l_next_rec-to-l_next_free_rec.patch
