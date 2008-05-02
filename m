From: akpm@linux-foundation.org
Subject: - quota-add-a-convenience-macro-for-filesystems.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:06 -0700
Message-ID: <200805021943.m42Jh6Va011259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758032AbYEBTtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:49:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: add a convenience macro for filesystems
has been removed from the -mm tree.  Its filename was
     quota-add-a-convenience-macro-for-filesystems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: add a convenience macro for filesystems
From: Jan Kara <jack@suse.cz>

Note that it cannot be an inline function because we don't have struct
super_block prototype...

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quota.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/quota.h~quota-add-a-convenience-macro-for-filesystems include/linux/quota.h
--- a/include/linux/quota.h~quota-add-a-convenience-macro-for-filesystems
+++ a/include/linux/quota.h
@@ -347,6 +347,9 @@ struct quota_info {
 	((type) == USRQUOTA ? (sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED) : \
 			      (sb_dqopt(sb)->flags & DQUOT_GRP_SUSPENDED))
 
+#define sb_any_quota_suspended(sb) (sb_has_quota_suspended(sb, USRQUOTA) | \
+				  sb_has_quota_suspended(sb, GRPQUOTA))
+
 int register_quota_format(struct quota_format_type *fmt);
 void unregister_quota_format(struct quota_format_type *fmt);
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
git-udf.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch
reiserfs-fix-typos-in-messages-and-comments-journalled-journaled.patch
reiserfs-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
ext4-fix-mount-messages-when-quota-disabled.patch
ext4-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext4-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext4-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch

