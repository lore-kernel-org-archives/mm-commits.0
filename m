From: akpm@linux-foundation.org
Subject: [withdrawn]
 =?US-ASCII?Q?ocfs2-old-mle-put-and-release-after-the-function-dlm=5Fad?=
 =?US-ASCII?Q?d=5Fmigration=5Fmle-called.patch?= removed from -mm tree
Date: Mon, 13 Nov 2017 22:27:24 -0800
Message-ID: <20171114062724.50iyE83I0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753403AbdKNG1Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 01:27:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: old mle put and release after the function dlm_add_migration_mle called
has been removed from the -mm tree.  Its filename was
     ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: old mle put and release after the function dlm_add_migration_mle called

If the old mle is found after the dlm_add_migration_mle called, it should
be put once.  If the return value is not - EEXIST and its type is BLOCK,
it should be put again to release it to avoid memory leak, for it had been
unhashed from the map.

[akpm@linux-foundation.org: fix coding style, comments]
Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA4A3D4B7FE@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2612,20 +2612,48 @@ static int dlm_migrate_lockres(struct dl
 	spin_lock(&dlm->master_lock);
 	ret = dlm_add_migration_mle(dlm, res, mle, &oldmle, name,
 				    namelen, target, dlm->node_num);
+	if (ret == -EEXIST) {
+		if (oldmle)
+			__dlm_put_mle(oldmle);
+
+		spin_unlock(&dlm->master_lock);
+		spin_unlock(&dlm->spinlock);
+		mlog(0, "another process is already migrating it\n");
+		goto fail;
+	}
+
+	/*
+	 * If an old mle is found, it should be put.  If its type is BLOCK,
+	 * it should be put again.  Because it has been unhasded from the map
+	 * in the function dlm_add_migration_mle.
+	 * Otherwise the memory will be leaked.  It will not be found again from
+	 * the hash map.
+	 */
+	if (oldmle) {
+		/* master is known, detach if not already detached */
+		__dlm_mle_detach_hb_events(dlm, oldmle);
+		__dlm_put_mle(oldmle);
+
+		/*
+		 * If the type of the mle is BLOCK, it should be put once for
+		 * release.  Otherwise a memory leak may be caused because
+		 * oldmle has been unhashed from the hash map and it will not
+		 * be found any more.
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
@@ -2642,12 +2670,6 @@ static int dlm_migrate_lockres(struct dl
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
@@ -3182,16 +3204,24 @@ int dlm_migrate_request_handler(struct o
 	if (ret < 0)
 		kmem_cache_free(dlm_mle_cache, mle);
 
+	/*
+	 * If an old mle is found, it should be put.  If its type is BLOCK,
+	 * it should be put again because it has been unhashed from the map
+	 * in the dlm_add_migration_mle().
+	 * Otherwise the memory will be leaked.  It will not be found again from
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
