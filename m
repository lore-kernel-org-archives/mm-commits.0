From: akpm@linux-foundation.org
Subject: +
 ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add-v3.patch added to -mm tree
Date: Fri, 28 Jun 2013 13:45:28 -0700
Message-ID: <51cdf5e8.+QgJSzoqTPrcKgiW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3F1Up3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 16:45:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: + ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add-v3.patch added to -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 13:45:28 -0700


The patch titled
     Subject: ocfs2: need rollback when journal_access failed in ocfs2_orphan_add()
has been added to the -mm tree.  Its filename is
     ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add.patch
ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add-v3.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix-2.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch

