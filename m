Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89166C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 21:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiGYVxE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 17:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGYVxE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 17:53:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE961F5
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 14:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D63D0B80ECE
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 21:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80837C341C6;
        Mon, 25 Jul 2022 21:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658785980;
        bh=Jql6YM/z+WmhxdmRGRHVIz7wcKUNu0DCwI1sg/EikcI=;
        h=Date:To:From:Subject:From;
        b=E99DmRQB20c1QDZbeU7GjrQPpyNVkq0eqGqa49NBdYeXGLNWN+nACbP9v9PZrN60O
         NQgtyIwzFGSTvV80D9m85uOp9X1ceCUNa31ZHfJ7RZjJCzdssx/el0rQQh4RMdsEK7
         SECHpScrbweXRYEyuS7JqmHb3J7ED8EwJPyOtJ4o=
Date:   Mon, 25 Jul 2022 14:52:59 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-do-not-inline-write-slow-path.patch added to mm-unstable branch
Message-Id: <20220725215300.80837C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: do not inline write slow path
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-do-not-inline-write-slow-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-do-not-inline-write-slow-path.patch

This patch will later appear in the mm-unstable branch at
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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: do not inline write slow path
Date: Thu, 21 Jul 2022 00:53:02 +0000

Having the slow path inlined causes too much stack usage.  Create new
function mas_wr_bnode() to write a big node into the tree

Link: https://lkml.kernel.org/r/20220721005237.377987-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-do-not-inline-write-slow-path
+++ a/lib/maple_tree.c
@@ -4309,12 +4309,27 @@ static inline bool mas_wr_append(struct
 	return false;
 }
 
+/*
+ * mas_wr_bnode() - Slow path for a modification.
+ * @wr_mas: The write maple state
+ *
+ * This is where split, rebalance end up.
+ */
+static void mas_wr_bnode(struct ma_wr_state *wr_mas)
+{
+	struct maple_big_node b_node;
+
+	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
+	memset(&b_node, 0, sizeof(struct maple_big_node));
+	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
+	mas_commit_b_node(wr_mas, &b_node, wr_mas->node_end);
+}
+
 static inline void mas_wr_modify(struct ma_wr_state *wr_mas)
 {
 	unsigned char node_slots;
 	unsigned char node_size;
 	struct ma_state *mas = wr_mas->mas;
-	struct maple_big_node b_node;
 
 	/* Direct replacement */
 	if (wr_mas->r_min == mas->index && wr_mas->r_max == mas->last) {
@@ -4350,10 +4365,7 @@ static inline void mas_wr_modify(struct
 		return;
 
 slow_path:
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	trace_ma_write(__func__, mas, 0, wr_mas->entry);
-	mas_commit_b_node(wr_mas, &b_node, wr_mas->node_end);
+	mas_wr_bnode(wr_mas);
 }
 
 /*
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
kernel-fork-use-maple-tree-for-dup_mmap-during-forking-fix.patch
maple_tree-do-not-inline-write-slow-path.patch
maple_tree-add-a-mas_destroy-call-to-mas_expected_entries-failure-path.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

