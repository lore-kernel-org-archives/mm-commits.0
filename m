From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-cluster-replace-zero-length-array-with-flexible-array-member.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:35:26 -0700
Message-ID: <20200403203526.fpd-w3m9d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUf1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:35:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, gustavo@embeddedor.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: cluster: replace zero-length array with flexible-array member
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-replace-zero-length-array-with-flexible-array-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: ocfs2: cluster: replace zero-length array with flexible-array member

The current codebase makes use of the zero-length array language extension
to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning in
case the flexible array does not occur last in the structure, which will
help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by this
change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied.  As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://urldefense.com/v3/__https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html__;!!GqivPVa7Brio!NzMr-YRl2zy-K3lwLVVatz7x0uD2z7-ykQag4GrGigxmfWU8TWzDy6xrkTiW3hYl00czlw$
[2] https://urldefense.com/v3/__https://github.com/KSPP/linux/issues/21__;!!GqivPVa7Brio!NzMr-YRl2zy-K3lwLVVatz7x0uD2z7-ykQag4GrGigxmfWU8TWzDy6xrkTiW3hYHG1nAnw$
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Link: http://lkml.kernel.org/r/20200309201907.GA8005@embeddedor
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/tcp.h~ocfs2-cluster-replace-zero-length-array-with-flexible-array-member
+++ a/fs/ocfs2/cluster/tcp.h
@@ -32,7 +32,7 @@ struct o2net_msg
 	__be32 status;
 	__be32 key;
 	__be32 msg_num;
-	__u8  buf[0];
+	__u8  buf[];
 };
 
 typedef int (o2net_msg_handler_func)(struct o2net_msg *msg, u32 len, void *data,
_

Patches currently in -mm which might be from gustavo@embeddedor.com are

lib-bch-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_bm-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_fsm-replace-zero-length-array-with-flexible-array-member.patch
lib-ts_kmp-replace-zero-length-array-with-flexible-array-member.patch
gcov-gcc_4_7-replace-zero-length-array-with-flexible-array-member.patch
gcov-gcc_3_4-replace-zero-length-array-with-flexible-array-member.patch
gcov-fs-replace-zero-length-array-with-flexible-array-member.patch
