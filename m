From: akpm@linux-foundation.org
Subject: + ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix-2.patch added to
 -mm tree
Date: Fri, 28 Jun 2013 13:40:17 -0700
Message-ID: <51cdf4b1.wyNCbpBxkXVxU7Ua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3F1UkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 16:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younger.liu@huawei.com, sunil.mushran@gmail.com, shencanquan@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: + ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix-2.patch added to -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,shencanquan@huawei.com,sunil.mushran@gmail.com,younger.liu@huawei.com
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 13:40:17 -0700


The patch titled
     Subject: ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix-2
has been added to the -mm tree.  Its filename is
     ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Liu <jeff.liu@oracle.com>
Subject: ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix-2

s/inode_is_unlinkable/ocfs2_inode_is_unlinkable/

Cc: Jensen <shencanquan@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Younger Liu <younger.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix-2 fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix-2
+++ a/fs/ocfs2/namei.c
@@ -773,7 +773,7 @@ static int ocfs2_remote_dentry_delete(st
 	return ret;
 }
 
-static inline int inode_is_unlinkable(struct inode *inode)
+static inline int ocfs2_inode_is_unlinkable(struct inode *inode)
 {
 	if (S_ISDIR(inode->i_mode)) {
 		if (inode->i_nlink == 2)
@@ -866,7 +866,7 @@ static int ocfs2_unlink(struct inode *di
 		goto leave;
 	}
 
-	if (inode_is_unlinkable(inode)) {
+       if (ocfs2_inode_is_unlinkable(inode)) {
 		status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
 						  OCFS2_I(inode)->ip_blkno,
 						  orphan_name, &orphan_insert);
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

linux-next.patch
ocfs2-should-not-use-le32_add_cpu-to-set-ocfs2_dinode-i_flags.patch
ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch
ocfs2-remove-unecessary-variable-needs_checkpoint.patch
ocfs2-fix-mutex_unlock-and-possible-memory-leak-in-ocfs2_remove_btree_range.patch
fs-ocfs2-journalh-add-bits_wanted-while-calculating-credits-in-ocfs2_calc_extend_credits.patch
fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch
ocfs2-xattr-remove-useless-free-space-checking.patch
ocfs2-xattr-remove-useless-free-space-checking-fix.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list.patch
ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix-2.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-xattr-fix-inlined-xattr-reflink.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

