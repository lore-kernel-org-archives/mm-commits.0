Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49ACC761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 01:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbjDFBG5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 21:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjDFBGw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 21:06:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811021FD8;
        Wed,  5 Apr 2023 18:06:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62DEC64296;
        Thu,  6 Apr 2023 01:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD3BC433EF;
        Thu,  6 Apr 2023 01:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743210;
        bh=aL4JewT0n853RqTs6bm3nijmZZD43dKBa51pZzb600g=;
        h=Date:To:From:Subject:From;
        b=r11Dt4ReczRy+cXyMr8fd81UGbSJwYGpnDeMvzbYpcwzl8XrrQwCicqMEIvV+zpfQ
         fu6yc7R43/MMctjkYNG/j6XK7QWpgGAfFWLrVziwLFfM8bBERxa9Ot1S21P4ni5lle
         ge+HDIFyKtNLFaLQc2IwzJ2/O5He1tZxDQvDnEE0=
Date:   Wed, 05 Apr 2023 18:06:50 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-add-smp_rmb-to-dead-node-detection.patch removed from -mm tree
Message-Id: <20230406010650.BBD3BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add smp_rmb() to dead node detection
has been removed from the -mm tree.  Its filename was
     maple_tree-add-smp_rmb-to-dead-node-detection.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add smp_rmb() to dead node detection
Date: Mon, 27 Feb 2023 09:36:05 -0800

Add an smp_rmb() before reading the parent pointer to ensure that anything
read from the node prior to the parent pointer hasn't been reordered ahead
of this check.

The is necessary for RCU mode.

Link: https://lkml.kernel.org/r/20230227173632.3292573-7-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-smp_rmb-to-dead-node-detection
+++ a/lib/maple_tree.c
@@ -539,9 +539,11 @@ static inline struct maple_node *mte_par
  */
 static inline bool ma_dead_node(const struct maple_node *node)
 {
-	struct maple_node *parent = (void *)((unsigned long)
-					     node->parent & ~MAPLE_NODE_MASK);
+	struct maple_node *parent;
 
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
+	parent = (void *)((unsigned long) node->parent & ~MAPLE_NODE_MASK);
 	return (parent == node);
 }
 
@@ -556,6 +558,8 @@ static inline bool mte_dead_node(const s
 	struct maple_node *parent, *node;
 
 	node = mte_to_node(enode);
+	/* Do not reorder reads from the node prior to the parent check */
+	smp_rmb();
 	parent = mte_parent(enode);
 	return (parent == node);
 }
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


