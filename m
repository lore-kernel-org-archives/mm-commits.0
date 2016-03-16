From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-fix-a-variable-overflow-problem-in-dlmdomainc.patch removed from
 -mm tree
Date: Wed, 16 Mar 2016 12:53:23 -0700
Message-ID: <56e9b9b3.AMql/dmHUO/oMHUD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbcCPTxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix a variable overflow problem in dlmdomain.c
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-fix-a-variable-overflow-problem-in-dlmdomainc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jun Piao <piaojun@huawei.com>
Subject: ocfs2/dlm: fix a variable overflow problem in dlmdomain.c

In dlm_send_join_cancels(), node is defined with type unsigned int, but
initialized with -1, this will lead variable overflow.  Although this
won't cause any runtime problem, the code looks a little uncoordinated.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-fix-a-variable-overflow-problem-in-dlmdomainc fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-fix-a-variable-overflow-problem-in-dlmdomainc
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1399,7 +1399,7 @@ static int dlm_send_join_cancels(struct
 				 unsigned int map_size)
 {
 	int status, tmpstat;
-	unsigned int node;
+	int node;
 
 	if (map_size != (BITS_TO_LONGS(O2NM_MAX_NODES) *
 			 sizeof(unsigned long))) {
_

Patches currently in -mm which might be from piaojun@huawei.com are


