Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6F5C76196
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 04:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjDKEic (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjDKEic (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 00:38:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56982171A
        for <mm-commits@vger.kernel.org>; Mon, 10 Apr 2023 21:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D88B862133
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 04:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC12C433D2;
        Tue, 11 Apr 2023 04:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681187909;
        bh=xWYnNu3FfKeSJTwNMdkTuRdN5Y3OqVpai2+ksqH1l1k=;
        h=Date:To:From:Subject:From;
        b=ArldBA69miy4yQ2zu+HBkPlerMjXxIVOGU6XmeestIIwLL/D9pjLZBEmABnFVJDSs
         OaA4xeaW1S3jiU0vuAAaeGIzzN2bPslOIekMBa3FbCUDye3GpvAJQHY6RXa6hDy07S
         Q7jHFGYE+Vp5RM6fYFVTB/agtiAh/qiqvZ1S3FuQ=
Date:   Mon, 10 Apr 2023 21:38:28 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@Oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-a-test-case-to-check-maple_alloc.patch added to mm-unstable branch
Message-Id: <20230411043829.3AC12C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add a test case to check maple_alloc
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-a-test-case-to-check-maple_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-a-test-case-to-check-maple_alloc.patch

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
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: add a test case to check maple_alloc
Date: Tue, 11 Apr 2023 12:10:05 +0800

Add a test case to check whether the number of maple_alloc structures is
actually equal to mas->alloc->total.

Link: https://lkml.kernel.org/r/20230411041005.26205-2-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/tools/testing/radix-tree/maple.c~maple_tree-add-a-test-case-to-check-maple_alloc
+++ a/tools/testing/radix-tree/maple.c
@@ -55,6 +55,28 @@ struct rcu_reader_struct {
 	struct rcu_test_struct2 *test;
 };
 
+static int get_alloc_node_count(struct ma_state *mas)
+{
+	int count = 1;
+	struct maple_alloc *node = mas->alloc;
+
+	if (!node || ((unsigned long)node & 0x1))
+		return 0;
+	while (node->node_count) {
+		count += node->node_count;
+		node = node->slot[0];
+	}
+	return count;
+}
+
+static void check_mas_alloc_node_count(struct ma_state *mas)
+{
+	mas_node_count_gfp(mas, MAPLE_ALLOC_SLOTS + 1, GFP_KERNEL);
+	mas_node_count_gfp(mas, MAPLE_ALLOC_SLOTS + 3, GFP_KERNEL);
+	MT_BUG_ON(mas->tree, get_alloc_node_count(mas) != mas->alloc->total);
+	mas_destroy(mas);
+}
+
 /*
  * check_new_node() - Check the creation of new nodes and error path
  * verification.
@@ -69,6 +91,8 @@ static noinline void check_new_node(stru
 
 	MA_STATE(mas, mt, 0, 0);
 
+	check_mas_alloc_node_count(&mas);
+
 	/* Try allocating 3 nodes */
 	mtree_lock(mt);
 	mt_set_non_kernel(0);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-fix-a-potential-memory-leak-oob-access-or-other-unpredictable-bug.patch
mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch
maple_tree-simplify-mas_wr_node_walk.patch
maple_tree-use-correct-variable-type-in-sizeof.patch
maple_tree-add-a-test-case-to-check-maple_alloc.patch

