From: akpm@linux-foundation.org
Subject: +
 ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called.patch added to -mm tree
Date: Fri, 18 Nov 2016 14:59:44 -0800
Message-ID: <582f87e0.Bkd2eRtTmxCNhthy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40812 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752444AbcKRW7p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 17:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: old mle put and release after the function dlm_add_migration_mle called
has been added to the -mm tree.  Its filename is
     ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: old mle put and release after the function dlm_add_migration_mle called

If the old mle is found after the dlm_add_migration_mle called, it should
be put once.  If the return value is not - EEXIST and its type is BLOCK,
it should be put again to release it to avoid memory leak, for it had been
unhashed from the map.

Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA4A3D4B7FE@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   62 ++++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2612,20 +2612,45 @@ static int dlm_migrate_lockres(struct dl
 	spin_lock(&dlm->master_lock);
 	ret = dlm_add_migration_mle(dlm, res, mle, &oldmle, name,
 				    namelen, target, dlm->node_num);
+	if (ret == -EEXIST) {
+		if(oldmle)
+			__dlm_put_mle(oldmle);
+
+		spin_unlock(&dlm->master_lock);
+		spin_unlock(&dlm->spinlock);
+		mlog(0, "another process is already migrating it\n");
+		goto fail;
+	}
+
+	/* If an old one mle found, it should be put. if its type is BLOCK,
+	 * it should be put again. Because it had been unhasded from the map
+	 * in the function dlm_add_migration_mle.
+	 * otherwise the memory will be leaked. It will not found it again from
+	 * the hash map.
+	 */
+	if (oldmle) {
+		/* master is known, detach if not already detached */
+		__dlm_mle_detach_hb_events(dlm, oldmle);
+		__dlm_put_mle(oldmle);
+
+		/* if the type of the mle is BLOCK, should put it once for release.
+		 * otherwise memory leak may be caused because oldmle had been unhashed
+		 * from the hash map, it will not be found anymore.
+		 */
+		if (oldmle->type == DLM_MLE_BLOCK)
+			__dlm_put_mle(oldmle);
+       }
+
 	/* get an extra reference on the mle.
 	 * otherwise the assert_master from the new
 	 * master will destroy this.
 	 */
 	dlm_get_mle_inuse(mle);
+	mle_added = 1;
+
 	spin_unlock(&dlm->master_lock);
 	spin_unlock(&dlm->spinlock);
 
-	if (ret == -EEXIST) {
-		mlog(0, "another process is already migrating it\n");
-		goto fail;
-	}
-	mle_added = 1;
-
 	/*
 	 * set the MIGRATING flag and flush asts
 	 * if we fail after this we need to re-dirty the lockres
@@ -2642,12 +2667,6 @@ static int dlm_migrate_lockres(struct dl
 	}
 
 fail:
-	if (ret != -EEXIST && oldmle) {
-		/* master is known, detach if not already detached */
-		dlm_mle_detach_hb_events(dlm, oldmle);
-		dlm_put_mle(oldmle);
-	}
-
 	if (ret < 0) {
 		if (mle_added) {
 			dlm_mle_detach_hb_events(dlm, mle);
@@ -3182,16 +3201,23 @@ int dlm_migrate_request_handler(struct o
 	if (ret < 0)
 		kmem_cache_free(dlm_mle_cache, mle);
 
+	/* If an old one mle found, it should be put. if its type is BLOCK,
+	 * it should be put again. Because it had been unhasded from the map
+	 * in the function dlm_add_migration_mle.
+	 * otherwise the memory will be leaked. It will not found it again from
+	 * the hash map.
+	 */
+	if (oldmle) {
+		__dlm_mle_detach_hb_events(dlm, oldmle);
+		__dlm_put_mle(oldmle);
+		if (ret >= 0 && oldmle->type == DLM_MLE_BLOCK)
+			__dlm_put_mle(oldmle);
+	}
+
 	spin_unlock(&dlm->master_lock);
 unlock:
 	spin_unlock(&dlm->spinlock);
 
-	if (oldmle) {
-		/* master is known, detach if not already detached */
-		dlm_mle_detach_hb_events(dlm, oldmle);
-		dlm_put_mle(oldmle);
-	}
