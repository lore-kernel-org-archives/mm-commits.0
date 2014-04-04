From: akpm@linux-foundation.org
Subject: [merged]
 quota-provide-function-to-grab-quota-structure-reference.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:13 -0700
Message-ID: <533f0845.M8zX/mHm+U4zTsY7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbaDDTaO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.de, jlbec@evilplan.org, jack@suse.cz

Subject: [merged] quota-provide-function-to-grab-quota-structure-reference.patch removed from -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.de,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:13 -0700


The patch titled
     Subject: quota: provide function to grab quota structure reference
has been removed from the -mm tree.  Its filename was
     quota-provide-function-to-grab-quota-structure-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: quota: provide function to grab quota structure reference

Provide dqgrab() function to get quota structure reference when we are
sure it already has at least one active reference.  Make use of this
function inside quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota/dquot.c         |    4 ++--
 include/linux/quotaops.h |    8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/quota/dquot.c~quota-provide-function-to-grab-quota-structure-reference fs/quota/dquot.c
--- a/fs/quota/dquot.c~quota-provide-function-to-grab-quota-structure-reference
+++ a/fs/quota/dquot.c
@@ -528,7 +528,7 @@ restart:
 		if (atomic_read(&dquot->dq_count)) {
 			DEFINE_WAIT(wait);
 
-			atomic_inc(&dquot->dq_count);
+			dqgrab(dquot);
 			prepare_to_wait(&dquot->dq_wait_unused, &wait,
 					TASK_UNINTERRUPTIBLE);
 			spin_unlock(&dq_list_lock);
@@ -632,7 +632,7 @@ int dquot_writeback_dquots(struct super_
 			/* Now we have active dquot from which someone is
  			 * holding reference so we can safely just increase
 			 * use count */
-			atomic_inc(&dquot->dq_count);
+			dqgrab(dquot);
 			spin_unlock(&dq_list_lock);
 			dqstats_inc(DQST_LOOKUPS);
 			err = sb->dq_op->write_dquot(dquot);
diff -puN include/linux/quotaops.h~quota-provide-function-to-grab-quota-structure-reference include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-provide-function-to-grab-quota-structure-reference
+++ a/include/linux/quotaops.h
@@ -46,6 +46,14 @@ void inode_reclaim_rsv_space(struct inod
 void dquot_initialize(struct inode *inode);
 void dquot_drop(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, struct kqid qid);
+static inline struct dquot *dqgrab(struct dquot *dquot)
+{
+	/* Make sure someone else has active reference to dquot */
+	WARN_ON_ONCE(!atomic_read(&dquot->dq_count));
+	WARN_ON_ONCE(!test_bit(DQ_ACTIVE_B, &dquot->dq_flags));
+	atomic_inc(&dquot->dq_count);
+	return dquot;
+}
 void dqput(struct dquot *dquot);
 int dquot_scan_active(struct super_block *sb,
 		      int (*fn)(struct dquot *dquot, unsigned long priv),
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

