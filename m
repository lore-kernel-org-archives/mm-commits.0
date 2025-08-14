Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F6718DB1F
	for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2025 23:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755213927; cv=none; b=tdOU4u8ksrj85ajZg/fmDE0qORmF3UcBQY54pxtpGiEVwdBw8W8i/4OOvrUSLxC6+ZPTf1bZ3u2COVopa/Yy4RDrXClLyxnUFTLwr8NMmEfNBHryhrUwsUDQ0Ahy0IPfgQ+B8a0VphJN07jIQmCVjOR+DZBUKWDQAJNA/IIpuy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755213927; c=relaxed/simple;
	bh=CtyxLlKPcrLVjI54VBURzcngdliYdhqZn+Z9yMSv9H4=;
	h=Date:To:From:Subject:Message-Id; b=P35pCatdkmZ9MFR2zRCgQtN54zNvfbWYMXFRw0TJ324h8NJ0N2sMq6lLqwYBs66KRmefnMmrt60jDj8b5WcFiqtUoLzXmYic5ppgEFha1WP3R0dsAWH6DyM5FoAvAgBfbvmtxafa3DtZ9K3pFbsyVwreK3/1eFJzRDFcFnt1OX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oCNRPD5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oCNRPD5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28198C4CEED;
	Thu, 14 Aug 2025 23:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755213927;
	bh=CtyxLlKPcrLVjI54VBURzcngdliYdhqZn+Z9yMSv9H4=;
	h=Date:To:From:Subject:From;
	b=oCNRPD5INSiB35wsYZWMgWCazXWhj2WQppbS7EeY1J60qgu+RrIoMn4wWAceeUpqU
	 83mv2RCsumCA2anEmhu8OTmJ+jpxatxYiES/ywOE7K6GTEC7Q6a1cOfsMggtE4S7AK
	 3tUGUFuimJU6PZ3pB/MANAvaIg1FhZfpB5qnqFHk=
Date: Thu, 14 Aug 2025 16:25:26 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,nabijaczleweli@nabijaczleweli.xyz,mark.tinguely@oracle.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-commented-out-mlog-statements.patch added to mm-nonmm-unstable branch
Message-Id: <20250814232527.28198C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove commented out mlog() statements
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-commented-out-mlog-statements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-commented-out-mlog-statements.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: ocfs2: remove commented out mlog() statements
Date: Thu, 14 Aug 2025 13:38:10 +0200

The mlog() statements have been commented out ever since commit
6714d8e86bf44 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem") -
remove them.

Link: https://lkml.kernel.org/r/20250814113815.219064-1-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: Mark Fasheh <mark@fasheh.com>
Cc: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
Cc: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c   |   11 -----------
 fs/ocfs2/dlm/dlmrecovery.c |    1 -
 2 files changed, 12 deletions(-)

--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-remove-commented-out-mlog-statements
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1477,7 +1477,6 @@ way_up_top:
 			goto send_response;
 		} else if (res->owner != DLM_LOCK_RES_OWNER_UNKNOWN) {
 			spin_unlock(&res->spinlock);
-			// mlog(0, "node %u is the master\n", res->owner);
 			response = DLM_MASTER_RESP_NO;
 			if (mle)
 				kmem_cache_free(dlm_mle_cache, mle);
@@ -1493,7 +1492,6 @@ way_up_top:
 			BUG();
 		}
 
-		// mlog(0, "lockres is in progress...\n");
 		spin_lock(&dlm->master_lock);
 		found = dlm_find_mle(dlm, &tmpmle, name, namelen);
 		if (!found) {
@@ -1503,8 +1501,6 @@ way_up_top:
 		set_maybe = 1;
 		spin_lock(&tmpmle->spinlock);
 		if (tmpmle->type == DLM_MLE_BLOCK) {
-			// mlog(0, "this node is waiting for "
-			// "lockres to be mastered\n");
 			response = DLM_MASTER_RESP_NO;
 		} else if (tmpmle->type == DLM_MLE_MIGRATION) {
 			mlog(0, "node %u is master, but trying to migrate to "
@@ -1531,8 +1527,6 @@ way_up_top:
 			} else
 				response = DLM_MASTER_RESP_NO;
 		} else {
-			// mlog(0, "this node is attempting to "
-			// "master lockres\n");
 			response = DLM_MASTER_RESP_MAYBE;
 		}
 		if (set_maybe)
@@ -1559,7 +1553,6 @@ way_up_top:
 	found = dlm_find_mle(dlm, &tmpmle, name, namelen);
 	if (!found) {
 		/* this lockid has never been seen on this node yet */
-		// mlog(0, "no mle found\n");
 		if (!mle) {
 			spin_unlock(&dlm->master_lock);
 			spin_unlock(&dlm->spinlock);
@@ -1573,8 +1566,6 @@ way_up_top:
 			goto way_up_top;
 		}
 
-		// mlog(0, "this is second time thru, already allocated, "
-		// "add the block.\n");
 		dlm_init_mle(mle, DLM_MLE_BLOCK, dlm, NULL, name, namelen);
 		set_bit(request->node_idx, mle->maybe_map);
 		__dlm_insert_mle(dlm, mle);
@@ -1897,8 +1888,6 @@ ok:
 		spin_unlock(&res->spinlock);
 	}
 
-	// mlog(0, "woo!  got an assert_master from node %u!\n",
-	// 	     assert->node_idx);
 	if (mle) {
 		int extra_ref = 0;
 		int nn = -1;
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-remove-commented-out-mlog-statements
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -464,7 +464,6 @@ static int dlm_do_recovery(struct dlm_ct
 	}
 
 	if (dlm->reco.dead_node == O2NM_INVALID_NODE_NUM) {
-		// mlog(0, "nothing to recover!  sleeping now!\n");
 		spin_unlock(&dlm->spinlock);
 		/* return to main thread loop and sleep. */
 		return 0;
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

ocfs2-remove-commented-out-mlog-statements.patch

