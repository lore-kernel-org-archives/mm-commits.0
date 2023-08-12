Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4EFC04A94
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjHLWGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjHLWF5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01D4198E
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EA01620DA
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05ADC433C8;
        Sat, 12 Aug 2023 22:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877959;
        bh=Y3TGFaNMhz13vJDmH7twT/AxKad3xCcByqJIV6v/sU8=;
        h=Date:To:From:Subject:From;
        b=a9ii5H+6q8DGKBZIV9ztqT1X7GlLQ6cj5NKSnDc02yAbqnbCPZYHfv56dZ9W46NP6
         Cm0YIpdwnQt8Tpu73y84gJY6NcogG+pgX197RYme5mFLGdveEQ1ubJc/n8c8kiHADO
         KjjYen8a4yFgfORIcp54wIawlC7cg5EmB9SAfWZA=
Date:   Sat, 12 Aug 2023 15:05:58 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, jiangqi903@gmail.com,
        ghe@suse.com, dg573847474@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cluster-fix-potential-deadlock-on-qs-qs_lock.patch removed from -mm tree
Message-Id: <20230812220558.E05ADC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: cluster: fix potential deadlock on &qs->qs_lock
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-fix-potential-deadlock-on-qs-qs_lock.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengfeng Ye <dg573847474@gmail.com>
Subject: ocfs2: cluster: fix potential deadlock on &qs->qs_lock
Date: Wed, 2 Aug 2023 12:38:24 +0000

&qs->qs_lock is acquired by timer o2net_idle_timer() along the following
call chain.  Thus the acquisition of the lock under process context should
disable bottom half, otherwise deadlock could happen if the timer happens
to preempt the execution while the lock is held in process context on the
same CPU.

<timer interrupt>
        -> o2net_idle_timer()
        -> o2quo_conn_err()
        -> spin_lock(&qs->qs_lock)

Several lock acquisition of &qs->qs_lock under process contex do not
disable irq or bottom half.  The patch fixes these potential deadlocks
scenerio by using spin_lock_bh() on &qs->qs_lock.

This flaw was found by an experimental static analysis tool I am
developing for irq-related deadlock.  x86_64 allmodconfig using gcc shows
no new warning.

Link: https://lkml.kernel.org/r/20230802123824.15301-1-dg573847474@gmail.com
Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/quorum.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/fs/ocfs2/cluster/quorum.c~ocfs2-cluster-fix-potential-deadlock-on-qs-qs_lock
+++ a/fs/ocfs2/cluster/quorum.c
@@ -93,7 +93,7 @@ static void o2quo_make_decision(struct w
 	int lowest_hb, lowest_reachable = 0, fence = 0;
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	lowest_hb = find_first_bit(qs->qs_hb_bm, O2NM_MAX_NODES);
 	if (lowest_hb != O2NM_MAX_NODES)
@@ -146,14 +146,14 @@ static void o2quo_make_decision(struct w
 
 out:
 	if (fence) {
-		spin_unlock(&qs->qs_lock);
+		spin_unlock_bh(&qs->qs_lock);
 		o2quo_fence_self();
 	} else {
 		mlog(ML_NOTICE, "not fencing this node, heartbeating: %d, "
 			"connected: %d, lowest: %d (%sreachable)\n",
 			qs->qs_heartbeating, qs->qs_connected, lowest_hb,
 			lowest_reachable ? "" : "un");
-		spin_unlock(&qs->qs_lock);
+		spin_unlock_bh(&qs->qs_lock);
 
 	}
 
@@ -196,7 +196,7 @@ void o2quo_hb_up(u8 node)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	qs->qs_heartbeating++;
 	mlog_bug_on_msg(qs->qs_heartbeating == O2NM_MAX_NODES,
@@ -211,7 +211,7 @@ void o2quo_hb_up(u8 node)
 	else
 		o2quo_clear_hold(qs, node);
 
-	spin_unlock(&qs->qs_lock);
+	spin_unlock_bh(&qs->qs_lock);
 }
 
 /* hb going down releases any holds we might have had due to this node from
@@ -220,7 +220,7 @@ void o2quo_hb_down(u8 node)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	qs->qs_heartbeating--;
 	mlog_bug_on_msg(qs->qs_heartbeating < 0,
@@ -233,7 +233,7 @@ void o2quo_hb_down(u8 node)
 
 	o2quo_clear_hold(qs, node);
 
-	spin_unlock(&qs->qs_lock);
+	spin_unlock_bh(&qs->qs_lock);
 }
 
 /* this tells us that we've decided that the node is still heartbeating
@@ -245,14 +245,14 @@ void o2quo_hb_still_up(u8 node)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	mlog(0, "node %u\n", node);
 
 	qs->qs_pending = 1;
 	o2quo_clear_hold(qs, node);
 
-	spin_unlock(&qs->qs_lock);
+	spin_unlock_bh(&qs->qs_lock);
 }
 
 /* This is analogous to hb_up.  as a node's connection comes up we delay the
@@ -264,7 +264,7 @@ void o2quo_conn_up(u8 node)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	qs->qs_connected++;
 	mlog_bug_on_msg(qs->qs_connected == O2NM_MAX_NODES,
@@ -279,7 +279,7 @@ void o2quo_conn_up(u8 node)
 	else
 		o2quo_clear_hold(qs, node);
 
-	spin_unlock(&qs->qs_lock);
+	spin_unlock_bh(&qs->qs_lock);
 }
 
 /* we've decided that we won't ever be connecting to the node again.  if it's
@@ -290,7 +290,7 @@ void o2quo_conn_err(u8 node)
 {
 	struct o2quo_state *qs = &o2quo_state;
 
-	spin_lock(&qs->qs_lock);
+	spin_lock_bh(&qs->qs_lock);
 
 	if (test_bit(node, qs->qs_conn_bm)) {
 		qs->qs_connected--;
@@ -307,7 +307,7 @@ void o2quo_conn_err(u8 node)
 	mlog(0, "node %u, %d total\n", node, qs->qs_connected);
 
 
-	spin_unlock(&qs->qs_lock);
+	spin_unlock_bh(&qs->qs_lock);
 }
 
 void o2quo_init(void)
_

Patches currently in -mm which might be from dg573847474@gmail.com are


