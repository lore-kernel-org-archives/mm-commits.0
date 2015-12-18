From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null.patch added
 to -mm tree
Date: Fri, 18 Dec 2015 15:51:36 -0800
Message-ID: <56749c08.LSOm9yORzM2W7eQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbbLRXvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 18:51:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: return appropriate value when dlm_grab() returns NULL
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: return appropriate value when dlm_grab() returns NULL

Function dlm_grab() may return NULL when the node is doing unmount.  When
doing code review, we found that some dlm handlers may return error to
caller when dlm_grab() returns NULL and make caller BUG or other problems.
 Here is an example:

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
@@ -3048,7 +3048,7 @@ int dlm_migrate_request_handler(struct o
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

ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch
ocfs2-dlm-fix-a-race-between-purge-and-migratio-v2.patch
ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

