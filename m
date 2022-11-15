Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E73C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbiKOWc3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238529AbiKOWcF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F49D1101
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94BEE61A60
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC08DC433D7;
        Tue, 15 Nov 2022 22:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551523;
        bh=4RP3GqJSSQzRV/N/xG8+xcvfu6pzKbsdjsMACAiuFw8=;
        h=Date:To:From:Subject:From;
        b=vFo7qbQPrvNx31pUUb5MSA8zg1PudfEZN0dfLDURAO86hhKJJiddkBPNqzX5XaCDm
         ecNStRkYK6Gtb84v2NFQExq/klN2ReuUfKN5imOtJPYh7xs7CFlKBaI49PWziV3Y7Y
         nEb4fAZ2yXJjU8R9yRpjNZShNwTfUMV1wThUd1Q0=
Date:   Tue, 15 Nov 2022 14:32:02 -0800
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, joseph.qi@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-dlm-use-bitmap-api-instead-of-hand-writing-it.patch removed from -mm tree
Message-Id: <20221115223202.EC08DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2/dlm: use bitmap API instead of hand-writing it
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-use-bitmap-api-instead-of-hand-writing-it.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2/dlm: use bitmap API instead of hand-writing it
Date: Fri, 7 Oct 2022 20:48:46 +0800

Use bitmap_zero/bitmap_copy/bitmap_qeual directly for bitmap operations.

Link: https://lkml.kernel.org/r/20221007124846.186453-3-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h   |    2 +-
 fs/ocfs2/dlm/dlmdomain.c   |   17 +++++++----------
 fs/ocfs2/dlm/dlmmaster.c   |   30 +++++++++++++++---------------
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 4 files changed, 24 insertions(+), 27 deletions(-)

--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-use-bitmap-api-instead-of-hand-writing-it
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -1094,7 +1094,7 @@ static inline enum dlm_status dlm_err_to
 static inline void dlm_node_iter_init(unsigned long *map,
 				      struct dlm_node_iter *iter)
 {
-	memcpy(iter->node_map, map, sizeof(iter->node_map));
+	bitmap_copy(iter->node_map, map, O2NM_MAX_NODES);
 	iter->curnode = -1;
 }
 
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-use-bitmap-api-instead-of-hand-writing-it
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1576,8 +1576,8 @@ static int dlm_should_restart_join(struc
 	spin_lock(&dlm->spinlock);
 	/* For now, we restart the process if the node maps have
 	 * changed at all */
-	ret = memcmp(ctxt->live_map, dlm->live_nodes_map,
-		     sizeof(dlm->live_nodes_map));
+	ret = !bitmap_equal(ctxt->live_map, dlm->live_nodes_map,
+			    O2NM_MAX_NODES);
 	spin_unlock(&dlm->spinlock);
 
 	if (ret)
@@ -1607,10 +1607,8 @@ static int dlm_try_to_join_domain(struct
 	o2hb_fill_node_map(dlm->live_nodes_map, O2NM_MAX_NODES);
 
 	spin_lock(&dlm->spinlock);
-	memcpy(ctxt->live_map, dlm->live_nodes_map, sizeof(ctxt->live_map));
-
+	bitmap_copy(ctxt->live_map, dlm->live_nodes_map, O2NM_MAX_NODES);
 	__dlm_set_joining_node(dlm, dlm->node_num);
-
 	spin_unlock(&dlm->spinlock);
 
 	node = -1;
@@ -1643,8 +1641,7 @@ static int dlm_try_to_join_domain(struct
 	 * yes_resp_map. Copy that into our domain map and send a join
 	 * assert message to clean up everyone elses state. */
 	spin_lock(&dlm->spinlock);
-	memcpy(dlm->domain_map, ctxt->yes_resp_map,
-	       sizeof(ctxt->yes_resp_map));
+	bitmap_copy(dlm->domain_map, ctxt->yes_resp_map, O2NM_MAX_NODES);
 	set_bit(dlm->node_num, dlm->domain_map);
 	spin_unlock(&dlm->spinlock);
 
@@ -2009,9 +2006,9 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
 	mlog(0, "dlm->recovery_map=%p, &(dlm->recovery_map[0])=%p\n",
 		  dlm->recovery_map, &(dlm->recovery_map[0]));
 
-	memset(dlm->recovery_map, 0, sizeof(dlm->recovery_map));
-	memset(dlm->live_nodes_map, 0, sizeof(dlm->live_nodes_map));
-	memset(dlm->domain_map, 0, sizeof(dlm->domain_map));
+	bitmap_zero(dlm->recovery_map, O2NM_MAX_NODES);
+	bitmap_zero(dlm->live_nodes_map, O2NM_MAX_NODES);
+	bitmap_zero(dlm->domain_map, O2NM_MAX_NODES);
 
 	dlm->dlm_thread_task = NULL;
 	dlm->dlm_reco_thread_task = NULL;
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-use-bitmap-api-instead-of-hand-writing-it
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -258,12 +258,12 @@ static void dlm_init_mle(struct dlm_mast
 	mle->type = type;
 	INIT_HLIST_NODE(&mle->master_hash_node);
 	INIT_LIST_HEAD(&mle->hb_events);
-	memset(mle->maybe_map, 0, sizeof(mle->maybe_map));
+	bitmap_zero(mle->maybe_map, O2NM_MAX_NODES);
 	spin_lock_init(&mle->spinlock);
 	init_waitqueue_head(&mle->wq);
 	atomic_set(&mle->woken, 0);
 	kref_init(&mle->mle_refs);
-	memset(mle->response_map, 0, sizeof(mle->response_map));
+	bitmap_zero(mle->response_map, O2NM_MAX_NODES);
 	mle->master = O2NM_MAX_NODES;
 	mle->new_master = O2NM_MAX_NODES;
 	mle->inuse = 0;
@@ -290,8 +290,8 @@ static void dlm_init_mle(struct dlm_mast
 	atomic_inc(&dlm->mle_cur_count[mle->type]);
 
 	/* copy off the node_map and register hb callbacks on our copy */
-	memcpy(mle->node_map, dlm->domain_map, sizeof(mle->node_map));
-	memcpy(mle->vote_map, dlm->domain_map, sizeof(mle->vote_map));
+	bitmap_copy(mle->node_map, dlm->domain_map, O2NM_MAX_NODES);
+	bitmap_copy(mle->vote_map, dlm->domain_map, O2NM_MAX_NODES);
 	clear_bit(dlm->node_num, mle->vote_map);
 	clear_bit(dlm->node_num, mle->node_map);
 
@@ -572,7 +572,7 @@ static void dlm_init_lockres(struct dlm_
 	spin_unlock(&dlm->track_lock);
 
 	memset(res->lvb, 0, DLM_LVB_LEN);
-	memset(res->refmap, 0, sizeof(res->refmap));
+	bitmap_zero(res->refmap, O2NM_MAX_NODES);
 }
 
 struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
@@ -1036,10 +1036,10 @@ recheck:
 
 	spin_lock(&mle->spinlock);
 	m = mle->master;
-	map_changed = (memcmp(mle->vote_map, mle->node_map,
-			      sizeof(mle->vote_map)) != 0);
-	voting_done = (memcmp(mle->vote_map, mle->response_map,
-			     sizeof(mle->vote_map)) == 0);
+	map_changed = !bitmap_equal(mle->vote_map, mle->node_map,
+				    O2NM_MAX_NODES);
+	voting_done = bitmap_equal(mle->vote_map, mle->response_map,
+				   O2NM_MAX_NODES);
 
 	/* restart if we hit any errors */
 	if (map_changed) {
@@ -1277,11 +1277,11 @@ static int dlm_restart_lock_mastery(stru
 
 			/* now blank out everything, as if we had never
 			 * contacted anyone */
-			memset(mle->maybe_map, 0, sizeof(mle->maybe_map));
-			memset(mle->response_map, 0, sizeof(mle->response_map));
+			bitmap_zero(mle->maybe_map, O2NM_MAX_NODES);
+			bitmap_zero(mle->response_map, O2NM_MAX_NODES);
 			/* reset the vote_map to the current node_map */
-			memcpy(mle->vote_map, mle->node_map,
-			       sizeof(mle->node_map));
+			bitmap_copy(mle->vote_map, mle->node_map,
+				    O2NM_MAX_NODES);
 			/* put myself into the maybe map */
 			if (mle->type != DLM_MLE_BLOCK)
 				set_bit(dlm->node_num, mle->maybe_map);
@@ -2094,7 +2094,7 @@ static void dlm_assert_master_worker(str
 	flags = item->u.am.flags;
 
 	spin_lock(&dlm->spinlock);
-	memcpy(nodemap, dlm->domain_map, sizeof(nodemap));
+	bitmap_copy(nodemap, dlm->domain_map, O2NM_MAX_NODES);
 	spin_unlock(&dlm->spinlock);
 
 	clear_bit(dlm->node_num, nodemap);
@@ -3447,7 +3447,7 @@ int dlm_finish_migration(struct dlm_ctxt
 		ret = 0;
 	}
 
-	memset(iter.node_map, 0, sizeof(iter.node_map));
+	bitmap_zero(iter.node_map, O2NM_MAX_NODES);
 	set_bit(old_master, iter.node_map);
 	mlog(0, "doing assert master of %.*s back to %u\n",
 	     res->lockname.len, res->lockname.name, old_master);
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-use-bitmap-api-instead-of-hand-writing-it
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -733,7 +733,7 @@ static int dlm_init_recovery_area(struct
 	struct dlm_reco_node_data *ndata;
 
 	spin_lock(&dlm->spinlock);
-	memcpy(dlm->reco.node_map, dlm->domain_map, sizeof(dlm->domain_map));
+	bitmap_copy(dlm->reco.node_map, dlm->domain_map, O2NM_MAX_NODES);
 	/* nodes can only be removed (by dying) after dropping
 	 * this lock, and death will be trapped later, so this should do */
 	spin_unlock(&dlm->spinlock);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


