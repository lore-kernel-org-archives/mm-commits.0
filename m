From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:31:42 -0800
Message-ID: <5699734e.CJEx8gpyve84BklZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbcAOWbn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: return appropriate value when dlm_grab() returns NULL
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: return appropriate value when dlm_grab() returns NULL

dlm_grab() may return NULL when the node is doing unmount.  When doing
code review, we found that some dlm handlers may return error to caller
when dlm_grab() returns NULL and make caller BUG or other problems.  Here
is an example:

Node 1                                 Node 2
receives migration message
from node 3, and send
migrate request to others
                                     start unmounting

                                     receives migrate request
                                     from node 1 and call
                                     dlm_migrate_request_handler()

                                     unmount thread unregisters
                                     domain handlers and removes
                                     dlm_context from dlm_domains

                                     dlm_migrate_request_handlers()
                                     returns -EINVAL to node 1
Exit migration neither clearing the
migration state nor sending
assert master message to node 3 which
cause node 3 hung.

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    2 +-
 fs/ocfs2/dlm/dlmunlock.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -3050,7 +3050,7 @@ int dlm_migrate_request_handler(struct o
 	int ret = 0;
 
 	if (!dlm_grab(dlm))
-		return -EINVAL;
+		return 0;
 
 	name = migrate->name;
 	namelen = migrate->namelen;
diff -puN fs/ocfs2/dlm/dlmunlock.c~ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null fs/ocfs2/dlm/dlmunlock.c
--- a/fs/ocfs2/dlm/dlmunlock.c~ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null
+++ a/fs/ocfs2/dlm/dlmunlock.c
@@ -421,7 +421,7 @@ int dlm_unlock_lock_handler(struct o2net
 	}
 
 	if (!dlm_grab(dlm))
-		return DLM_REJECTED;
+		return DLM_FORWARD;
 
 	mlog_bug_on_msg(!dlm_domain_fully_joined(dlm),
 			"Domain %s not fully joined!\n", dlm->name);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

