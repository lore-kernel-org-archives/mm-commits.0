Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080EBC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbiEJEXh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236332AbiEJEVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:21:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECC51B0931
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1077FB81AF1
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1543C385C2;
        Tue, 10 May 2022 04:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156245;
        bh=Kcs08F0b40o8T8O/7u3cLPoAmyT41PHi/FGxKDE23Y4=;
        h=Date:To:From:Subject:From;
        b=SOs4Q8mi7hRyytcAvINzhUPAUwRdt/36Lqd/MBiwMT+RJDb4qa0l12fSiNinDjRPF
         9JluoA/dW4N5zPk1khHSv0KLfs2cWlbNjFqMpSgJLc0r0aKfmzv0DlJL+XmlQNQx9T
         lfFyIWXLn7C3tBnO+WheP8vwQBfwAjFp2wJx3Bpc=
Date:   Mon, 09 May 2022 21:17:25 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        jakobkoschel@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable.patch removed from -mm tree
Message-Id: <20220510041725.C1543C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: replace usage of found with dedicated list iterator variable
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jakob Koschel <jakobkoschel@gmail.com>
Subject: ocfs2: replace usage of found with dedicated list iterator variable

To move the list iterator variable into the list_for_each_entry_*() macro
in the future it should be avoided to use the list iterator variable after
the loop body.

To *never* use the list iterator variable after the loop it was concluded
to use a separate iterator variable instead of a found boolean [1].

This removes the need to use a found variable and simply checking if the
variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Link: https://lkml.kernel.org/r/20220324071650.61168-1-jakobkoschel@gmail.com
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmunlock.c |   21 ++++++++++-----------
 fs/ocfs2/quota_local.c   |   10 +++++-----
 2 files changed, 15 insertions(+), 16 deletions(-)

--- a/fs/ocfs2/dlm/dlmunlock.c~ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable
+++ a/fs/ocfs2/dlm/dlmunlock.c
@@ -392,9 +392,9 @@ int dlm_unlock_lock_handler(struct o2net
 	struct dlm_ctxt *dlm = data;
 	struct dlm_unlock_lock *unlock = (struct dlm_unlock_lock *)msg->buf;
 	struct dlm_lock_resource *res = NULL;
-	struct dlm_lock *lock = NULL;
+	struct dlm_lock *lock = NULL, *iter;
 	enum dlm_status status = DLM_NORMAL;
-	int found = 0, i;
+	int i;
 	struct dlm_lockstatus *lksb = NULL;
 	int ignore;
 	u32 flags;
@@ -437,7 +437,6 @@ int dlm_unlock_lock_handler(struct o2net
 	}
 
 	queue=&res->granted;
-	found = 0;
 	spin_lock(&res->spinlock);
 	if (res->state & DLM_LOCK_RES_RECOVERING) {
 		spin_unlock(&res->spinlock);
@@ -461,21 +460,21 @@ int dlm_unlock_lock_handler(struct o2net
 	}
 
 	for (i=0; i<3; i++) {
-		list_for_each_entry(lock, queue, list) {
-			if (lock->ml.cookie == unlock->cookie &&
-		    	    lock->ml.node == unlock->node_idx) {
-				dlm_lock_get(lock);
-				found = 1;
+		list_for_each_entry(iter, queue, list) {
+			if (iter->ml.cookie == unlock->cookie &&
+			    iter->ml.node == unlock->node_idx) {
+				dlm_lock_get(iter);
+				lock = iter;
 				break;
 			}
 		}
-		if (found)
+		if (lock)
 			break;
 		/* scan granted -> converting -> blocked queues */
 		queue++;
 	}
 	spin_unlock(&res->spinlock);
-	if (!found) {
+	if (!lock) {
 		status = DLM_IVLOCKID;
 		goto not_found;
 	}
@@ -505,7 +504,7 @@ int dlm_unlock_lock_handler(struct o2net
 	dlm_kick_thread(dlm, res);
 
 not_found:
-	if (!found)
+	if (!lock)
 		mlog(ML_ERROR, "failed to find lock to unlock! "
 			       "cookie=%u:%llu\n",
 		     dlm_get_lock_cookie_node(be64_to_cpu(unlock->cookie)),
--- a/fs/ocfs2/quota_local.c~ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable
+++ a/fs/ocfs2/quota_local.c
@@ -921,19 +921,19 @@ static struct ocfs2_quota_chunk *ocfs2_f
 {
 	struct mem_dqinfo *info = sb_dqinfo(sb, type);
 	struct ocfs2_mem_dqinfo *oinfo = info->dqi_priv;
-	struct ocfs2_quota_chunk *chunk;
+	struct ocfs2_quota_chunk *chunk = NULL, *iter;
 	struct ocfs2_local_disk_chunk *dchunk;
 	int found = 0, len;
 
-	list_for_each_entry(chunk, &oinfo->dqi_chunk, qc_chunk) {
+	list_for_each_entry(iter, &oinfo->dqi_chunk, qc_chunk) {
 		dchunk = (struct ocfs2_local_disk_chunk *)
-						chunk->qc_headerbh->b_data;
+						iter->qc_headerbh->b_data;
 		if (le32_to_cpu(dchunk->dqc_free) > 0) {
-			found = 1;
+			chunk = iter;
 			break;
 		}
 	}
-	if (!found)
+	if (!chunk)
 		return NULL;
 
 	if (chunk->qc_num < oinfo->dqi_chunks - 1) {
_

Patches currently in -mm which might be from jakobkoschel@gmail.com are


