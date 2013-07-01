From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch added to -mm tree
Date: Mon, 01 Jul 2013 14:36:23 -0700
Message-ID: <51d1f657.UsPAVWEEcnRpUEPW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3GAVgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jul 2013 17:36:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, shencanquan@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: + ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch added to -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,shencanquan@huawei.com,sunil.mushran@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 01 Jul 2013 14:36:23 -0700


The patch titled
     Subject: ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2
has been added to the -mm tree.  Its filename is
     ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch

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
Subject: ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2

Compared with PATCH V1, bug description is updated, and pointless comments
are removed.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Jensen <shencanquan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2 fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2
+++ a/fs/ocfs2/file.c
@@ -474,8 +474,6 @@ static int ocfs2_truncate_file(struct in
 		goto bail;
 	}
 
-	/* lets handle the simple truncate cases before doing any more
-	 * cluster locking. */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	ocfs2_resv_discard(&osb->osb_la_resmap,
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
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch

