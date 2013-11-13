From: akpm@linux-foundation.org
Subject: [merged] ocfs2-dont-spam-on-edquot.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:37:16 -0800
Message-ID: <5283e2fc.9GG5JbATNKkOXkG5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3KMUhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, admin@wset.edu.pl, jlbec@evilplan.org

Subject: [merged] ocfs2-dont-spam-on-edquot.patch removed from -mm tree
To: jlbec@evilplan.org,admin@wset.edu.pl,jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:16 -0800


The patch titled
     Subject: ocfs2: don't spam on -EDQUOT
has been removed from the -mm tree.  Its filename was
     ocfs2-dont-spam-on-edquot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joel Becker <jlbec@evilplan.org>
Subject: ocfs2: don't spam on -EDQUOT

-EDQUOT is a user-visible error, not a logic problem.  Teach mlog_errno()
to ignore it like it ignores -ENOSPC, etc.

Signed-off-by: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reported-by: Marek Królikowski <admin@wset.edu.pl>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/masklog.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/masklog.h~ocfs2-dont-spam-on-edquot fs/ocfs2/cluster/masklog.h
--- a/fs/ocfs2/cluster/masklog.h~ocfs2-dont-spam-on-edquot
+++ a/fs/ocfs2/cluster/masklog.h
@@ -199,7 +199,8 @@ extern struct mlog_bits mlog_and_bits, m
 #define mlog_errno(st) do {						\
 	int _st = (st);							\
 	if (_st != -ERESTARTSYS && _st != -EINTR &&			\
-	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC)		\
+	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC &&		\
+	    _st != -EDQUOT)						\
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
 } while (0)
 
_

Patches currently in -mm which might be from jlbec@evilplan.org are

origin.patch
configfs-fix-race-between-dentry-put-and-lookup.patch
add-clustername-to-cluster-connection.patch
add-dlm-recovery-callbacks.patch
shift-allocation-ocfs2_live_connection-to-user_connect.patch
pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
framework-for-version-lvb.patch
framework-for-version-lvb-remove-some-impossible-checks.patch
use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch
linux-next.patch

