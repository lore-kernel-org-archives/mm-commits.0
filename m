From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-a-potential-abba-deadlock-caused-by-l_lock-and-dentry_attach_lock.patch added to -mm tree
Date: Thu, 07 Dec 2017 15:41:47 -0800
Message-ID: <5a29d1bb.YEBrSyusrYeXeMKH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57284 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdLGXls (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2017 18:41:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a potential 'ABBA' deadlock caused by 'l_lock' and 'dentry_attach_lock'
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-potential-abba-deadlock-caused-by-l_lock-and-dentry_attach_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-potential-abba-deadlock-caused-by-l_lock-and-dentry_attach_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-potential-abba-deadlock-caused-by-l_lock-and-dentry_attach_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jun Piao <piaojun@huawei.com>
Subject: ocfs2: fix a potential 'ABBA' deadlock caused by 'l_lock' and 'dentry_attach_lock'

       CPUA                                      CPUB

ocfs2_dentry_convert_worker
get 'l_lock'

                                    get 'dentry_attach_lock'

                                    interruptted by dio_end_io:
                                      dio_end_io
                                        dio_bio_end_aio
                                          dio_complete
                                            dio->end_io
                                              ocfs2_dio_end_io
                                                ocfs2_rw_unlock
                                                ...
                                                try to get 'l_lock'
                                                but CPUA has got it.

We try to get 'dentry_attach_lock', but CPUB has taken
'dentry_attach_lock' and would not release it.

So we need use spin_lock_irqsave() for 'dentry_attach_lock' to prevent
interruption by softirq.

Link: http://lkml.kernel.org/r/5A2925FB.2060908@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dcache.c  |   14 ++++++++------
 fs/ocfs2/dlmglue.c |   14 +++++++-------
 fs/ocfs2/namei.c   |    5 +++--
 3 files changed, 18 insertions(+), 15 deletions(-)

diff -puN fs/ocfs2/dcache.c~ocfs2-fix-a-potential-abba-deadlock-caused-by-l_lock-and-dentry_attach_lock fs/ocfs2/dcache.c
--- a/fs/ocfs2/dcache.c~ocfs2-fix-a-potential-abba-deadlock-caused-by-l_lock-and-dentry_attach_lock
+++ a/fs/ocfs2/dcache.c
@@ -230,6 +230,7 @@ int ocfs2_dentry_attach_lock(struct dent
 	int ret;
 	struct dentry *alias;
 	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
+	unsigned long flags;
 
 	trace_ocfs2_dentry_attach_lock(dentry->d_name.len, dentry->d_name.name,
 				       (unsigned long long)parent_blkno, dl);
@@ -309,10 +310,10 @@ int ocfs2_dentry_attach_lock(struct dent
 	ocfs2_dentry_lock_res_init(dl, parent_blkno, inode);
 
 out_attach:
-	spin_lock(&dentry_attach_lock);
+	spin_lock_irqsave(&dentry_attach_lock, flags);
 	dentry->d_fsdata = dl;
 	dl->dl_count++;
-	spin_unlock(&dentry_attach_lock);
+	spin_unlock_irqrestore(&dentry_attach_lock, flags);
 
 	/*
 	 * This actually gets us our PRMODE level lock. From now on,
@@ -333,9 +334,9 @@ out_attach:
 	if (ret < 0 && !alias) {
 		ocfs2_lock_res_free(&dl->dl_lockres);
 		BUG_ON(dl->dl_count != 1);
-		spin_lock(&dentry_attach_lock);
+		spin_lock_irqsave(&dentry_attach_lock, flags);
 		dentry->d_fsdata = NULL;
-		spin_unlock(&dentry_attach_lock);
+		spin_unlock_irqrestore(&dentry_attach_lock, flags);
 		kfree(dl);
 		iput(inode);
 	}
@@ -379,13 +380,14 @@ void ocfs2_dentry_lock_put(struct ocfs2_
 			   struct ocfs2_dentry_lock *dl)
 {
 	int unlock = 0;
+	unsigned long flags;
 
 	BUG_ON(dl->dl_count == 0);
 
-	spin_lock(&dentry_attach_lock);
+	spin_lock_irqsave(&dentry_attach_lock, flags);
 	dl->dl_count--;
 	unlock = !dl->dl_count;
-	spin_unlock(&dentry_attach_lock);
+	spin_unlock_irqrestore(&dentry_attach_lock, flags);
 
 	if (unlock)
 		ocfs2_drop_dentry_lock(osb, dl);
diff -puN fs/ocfs2/dlmglue.c~ocfs2-fix-a-potential-abba-deadlock-caused-by-l_lock-and-dentry_attach_lock fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-fix-a-potential-abba-deadlock-caused-by-l_lock-and-dentry_attach_lock
+++ a/fs/ocfs2/dlmglue.c
@@ -3801,7 +3801,7 @@ static int ocfs2_dentry_convert_worker(s
 	struct ocfs2_dentry_lock *dl = ocfs2_lock_res_dl(lockres);
 	struct ocfs2_inode_info *oi = OCFS2_I(dl->dl_inode);
 	struct dentry *dentry;
-	unsigned long flags;
+	unsigned long flags, d_flags;
 	int extra_ref = 0;
 
 	/*
@@ -3831,13 +3831,13 @@ static int ocfs2_dentry_convert_worker(s
 	 * flag.
 	 */
 	spin_lock_irqsave(&lockres->l_lock, flags);
-	spin_lock(&dentry_attach_lock);
+	spin_lock_irqsave(&dentry_attach_lock, d_flags);
 	if (!(lockres->l_flags & OCFS2_LOCK_FREEING)
 	    && dl->dl_count) {
 		dl->dl_count++;
 		extra_ref = 1;
 	}
-	spin_unlock(&dentry_attach_lock);
+	spin_unlock_irqrestore(&dentry_attach_lock, d_flags);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	mlog(0, "extra_ref = %d\n", extra_ref);
@@ -3850,13 +3850,13 @@ static int ocfs2_dentry_convert_worker(s
 	if (!extra_ref)
 		return UNBLOCK_CONTINUE;
 
-	spin_lock(&dentry_attach_lock);
+	spin_lock_irqsave(&dentry_attach_lock, d_flags);
 	while (1) {
 		dentry = ocfs2_find_local_alias(dl->dl_inode,
 						dl->dl_parent_blkno, 1);
 		if (!dentry)
 			break;
-		spin_unlock(&dentry_attach_lock);
+		spin_unlock_irqrestore(&dentry_attach_lock, d_flags);
 
 		if (S_ISDIR(dl->dl_inode->i_mode))
 			shrink_dcache_parent(dentry);
@@ -3874,9 +3874,9 @@ static int ocfs2_dentry_convert_worker(s
 		d_delete(dentry);
 		dput(dentry);
 
-		spin_lock(&dentry_attach_lock);
+		spin_lock_irqsave(&dentry_attach_lock, d_flags);
 	}
-	spin_unlock(&dentry_attach_lock);
+	spin_unlock_irqrestore(&dentry_attach_lock, d_flags);
 
 	/*
 	 * If we are the last holder of this dentry lock, there is no
diff -puN fs/ocfs2/namei.c~ocfs2-fix-a-potential-abba-deadlock-caused-by-l_lock-and-dentry_attach_lock fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-a-potential-abba-deadlock-caused-by-l_lock-and-dentry_attach_lock
+++ a/fs/ocfs2/namei.c
@@ -223,13 +223,14 @@ static void ocfs2_cleanup_add_entry_fail
 		struct dentry *dentry, struct inode *inode)
 {
 	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
+	unsigned long flags;
 
 	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
 	ocfs2_lock_res_free(&dl->dl_lockres);
 	BUG_ON(dl->dl_count != 1);
-	spin_lock(&dentry_attach_lock);
+	spin_lock_irqsave(&dentry_attach_lock, flags);
 	dentry->d_fsdata = NULL;
-	spin_unlock(&dentry_attach_lock);
+	spin_unlock_irqrestore(&dentry_attach_lock, flags);
 	kfree(dl);
 	iput(inode);
 }
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-fix-a-potential-abba-deadlock-caused-by-l_lock-and-dentry_attach_lock.patch
ocfs2-dlm-wait-for-dlm-recovery-done-when-migrating-all-lockres.patch

