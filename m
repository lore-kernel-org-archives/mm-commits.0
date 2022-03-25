Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA8BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 20:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiCYUQV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiCYUQU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 16:16:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD29D4550C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 13:14:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A21861D01
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D50C340F0;
        Fri, 25 Mar 2022 20:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648239284;
        bh=DWVPTxQH8RnFbnl5bbxAj+qvEiI+fUGEhAMA4QBVZyc=;
        h=Date:To:From:Subject:From;
        b=h7d2KJPkfLPXJZs9d5p/2tW44biGOIsX/bBP2XYUVVrQ2Bm6I6SRSX1eg5fUPDbJ+
         oVQsjtMHk6JM5ZjZwZCkj6nSnsokxvZ/00QaYZvw2qdud5MrDdyQ5zU697qfgGt+/T
         GJNFo5JxWLaoO+w7/zJ9TNFJCCg2jNTXeFPWBCRs=
Date:   Fri, 25 Mar 2022 13:14:44 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        jakobkoschel@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable.patch added to -mm tree
Message-Id: <20220325201444.D2D50C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: replace usage of found with dedicated list iterator variable
has been added to the -mm tree.  Its filename is
     ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -923,19 +923,19 @@ static struct ocfs2_quota_chunk *ocfs2_f
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

ocfs2-replace-usage-of-found-with-dedicated-list-iterator-variable.patch

