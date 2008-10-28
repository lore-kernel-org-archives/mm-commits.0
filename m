From: akpm@linux-foundation.org
Subject: + quota-make-_suspended-just-a-flag.patch added to -mm tree
Date: Mon, 27 Oct 2008 22:56:02 -0700
Message-ID: <200810280556.m9S5u2AY013380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364AbYJ1F4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 01:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     quota: make _SUSPENDED just a flag
has been added to the -mm tree.  Its filename is
     quota-make-_suspended-just-a-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: make _SUSPENDED just a flag
From: Jan Kara <jack@suse.cz>

Up to now, DQUOT_USR_SUSPENDED behaved like a state - i.e., either quota
was enabled or suspended or none.  Now allowed states are 0, ENABLED,
ENABLED | SUSPENDED.  This will be useful later when we implement separate
enabling of quota usage tracking and limits enforcement because we need to
keep track of a state which has been suspended.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c               |   10 ++++++----
 include/linux/quotaops.h |    6 ++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/dquot.c~quota-make-_suspended-just-a-flag fs/dquot.c
--- a/fs/dquot.c~quota-make-_suspended-just-a-flag
+++ a/fs/dquot.c
@@ -1564,18 +1564,20 @@ static inline void reset_enable_flags(st
 {
 	switch (type) {
 		case USRQUOTA:
-			dqopt->flags &= ~DQUOT_USR_ENABLED;
 			if (remount)
 				dqopt->flags |= DQUOT_USR_SUSPENDED;
-			else
+			else {
+				dqopt->flags &= ~DQUOT_USR_ENABLED;
 				dqopt->flags &= ~DQUOT_USR_SUSPENDED;
+			}
 			break;
 		case GRPQUOTA:
-			dqopt->flags &= ~DQUOT_GRP_ENABLED;
 			if (remount)
 				dqopt->flags |= DQUOT_GRP_SUSPENDED;
-			else
+			else {
+				dqopt->flags &= ~DQUOT_GRP_ENABLED;
 				dqopt->flags &= ~DQUOT_GRP_SUSPENDED;
+			}
 			break;
 	}
 }
diff -puN include/linux/quotaops.h~quota-make-_suspended-just-a-flag include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-make-_suspended-just-a-flag
+++ a/include/linux/quotaops.h
@@ -67,8 +67,10 @@ static inline struct mem_dqinfo *sb_dqin
 static inline int sb_has_quota_enabled(struct super_block *sb, int type)
 {
 	if (type == USRQUOTA)
-		return sb_dqopt(sb)->flags & DQUOT_USR_ENABLED;
-	return sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED;
+		return (sb_dqopt(sb)->flags & DQUOT_USR_ENABLED)
+			&& !(sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED);
+	return (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED)
+		&& !(sb_dqopt(sb)->flags & DQUOT_GROUP_SUSPENDED);
 }
 
 static inline int sb_any_quota_enabled(struct super_block *sb)
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ext4-fix-a-bug-accessing-freed-memory-in-ext4_abort.patch
ext3-fix-a-bug-accessing-freed-memory-in-ext3_abort.patch
quota-add-callbacks-for-allocating-and-destroying-dquot-structures.patch
quota-increase-size-of-variables-for-limits-and-inode-usage.patch
quota-remove-bogus-optimization-in-check_idq-and-check_bdq.patch
quota-make-_suspended-just-a-flag.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits.patch
ext3-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
ext4-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
reiserfs-use-sb_any_quota_loaded-instead-of-sb_any_quota_enabled.patch
quota-remove-compatibility-function-sb_any_quota_enabled.patch
quota-introduce-dquot_quota_sys_file-flag.patch
quota-move-quotaio_vh-from-include-linux-to-fs.patch
quota-split-off-quota-tree-handling-into-a-separate-file.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format.patch

