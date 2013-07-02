From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add-v3.patch removed from -mm tree
Date: Tue, 02 Jul 2013 14:25:52 -0700
Message-ID: <51d34560.KvqNRzPFn47EkTVI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3GBVZx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jul 2013 17:25:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: [folded-merged] ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add-v3.patch removed from -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 02 Jul 2013 14:25:52 -0700


The patch titled
     Subject: ocfs2: need rollback when journal_access failed in ocfs2_orphan_add()
has been removed from the -mm tree.  Its filename was
     ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add-v3.patch

This patch was dropped because it was folded into ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add.patch

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: need rollback when journal_access failed in ocfs2_orphan_add()

Compared with the PATCH V2, this patch cleans up mlog_errno(status)
which was called two times for the same error.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add-v3 fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add-v3
+++ a/fs/ocfs2/namei.c
@@ -2067,8 +2067,6 @@ rollback:
 leave:
 	brelse(orphan_dir_bh);
 
-	if (status)
-		mlog_errno(status);
 	return status;
 }
 
_

Patches currently in -mm which might be from younger.liu@huawei.com are

origin.patch
linux-next.patch
fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix-2.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch

