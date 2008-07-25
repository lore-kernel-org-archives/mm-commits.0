From: akpm@linux-foundation.org
Subject: - quota-fix-possible-infinite-loop-in-quota-code.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:46 -0700
Message-ID: <200807252257.m6PMvk0r003216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbYGYXGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dingdinghua85@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     quota: fix possible infinite loop in quota code
has been removed from the -mm tree.  Its filename was
     quota-fix-possible-infinite-loop-in-quota-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: fix possible infinite loop in quota code
From: Jan Kara <jack@suse.cz>

When quota structure is going to be dropped and it is dirty, quota code tries
to write it.  If the write fails for some reason (e.  g.  transaction cannot
be started because the journal is aborted), we try writing again and again and
again...  Fix the problem by clearing the dirty bit even if the write failed.

(akpm: for 2.6.27, 2.6.26.x and 2.6.25.x)

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: dingdinghua <dingdinghua85@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN fs/dquot.c~quota-fix-possible-infinite-loop-in-quota-code fs/dquot.c
--- a/fs/dquot.c~quota-fix-possible-infinite-loop-in-quota-code
+++ a/fs/dquot.c
@@ -562,6 +562,8 @@ static struct shrinker dqcache_shrinker 
  */
 static void dqput(struct dquot *dquot)
 {
+	int ret;
+
 	if (!dquot)
 		return;
 #ifdef __DQUOT_PARANOIA
@@ -594,7 +596,19 @@ we_slept:
 	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags) && dquot_dirty(dquot)) {
 		spin_unlock(&dq_list_lock);
 		/* Commit dquot before releasing */
-		dquot->dq_sb->dq_op->write_dquot(dquot);
+		ret = dquot->dq_sb->dq_op->write_dquot(dquot);
+		if (ret < 0) {
+			printk(KERN_ERR "VFS: cannot write quota structure on "
+				"device %s (error %d). Quota may get out of "
+				"sync!\n", dquot->dq_sb->s_id, ret);
+			/*
+			 * We clear dirty bit anyway, so that we avoid
+			 * infinite loop here
+			 */
+			spin_lock(&dq_list_lock);
+			clear_dquot_dirty(dquot);
+			spin_unlock(&dq_list_lock);
+		}
 		goto we_slept;
 	}
 	/* Clear flag in case dquot was inactive (something bad happened) */
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch

