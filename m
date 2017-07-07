From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-free-dummy_sc-in-sc_fop_release-in-case-of-memory-leak.patch removed
 from -mm tree
Date: Fri, 07 Jul 2017 12:07:39 -0700
Message-ID: <20170707190739.GGkOLcWk_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60672 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdGGTHk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: free 'dummy_sc' in sc_fop_release() to prevent memory leak
has been removed from the -mm tree.  Its filename was
     ocfs2-free-dummy_sc-in-sc_fop_release-in-case-of-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2: free 'dummy_sc' in sc_fop_release() to prevent memory leak

'sd->dbg_sock' is malloced in sc_common_open(), but not freed at the end
of sc_fop_release().

Link: http://lkml.kernel.org/r/594FB0A4.2050105@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/netdebug.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/cluster/netdebug.c~ocfs2-free-dummy_sc-in-sc_fop_release-in-case-of-memory-leak fs/ocfs2/cluster/netdebug.c
--- a/fs/ocfs2/cluster/netdebug.c~ocfs2-free-dummy_sc-in-sc_fop_release-in-case-of-memory-leak
+++ a/fs/ocfs2/cluster/netdebug.c
@@ -426,6 +426,7 @@ static int sc_fop_release(struct inode *
 	struct o2net_sock_container *dummy_sc = sd->dbg_sock;
 
 	o2net_debug_del_sc(dummy_sc);
+	kfree(dummy_sc);
 	return seq_release_private(inode, file);
 }
 
_

Patches currently in -mm which might be from piaojun@huawei.com are


