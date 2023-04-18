Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72221C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjDRXgI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbjDRXe6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BC1B478
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB1F362F22
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0A4C433D2;
        Tue, 18 Apr 2023 23:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860878;
        bh=lD6J6+gt9Nz1Un9ByixyG/ae0ulW2JG5DAsgX1uKKZY=;
        h=Date:To:From:Subject:From;
        b=k0rqrdg4GPIX6YQc6sRH2cK3ACiH+ZPjJ0qcnQvIT0U0JfEMuTMU/RP/7+L/gDpDJ
         yhNMwYxsM4MccopJMiaRZDQGNBMzJMElCigOJBT9n502qwXE8cazXO8WiZF5I06Mkp
         aeeIEF4ryQ3zRGWh3QEq6ObwtLou9JHdTmHLBqfY=
Date:   Tue, 18 Apr 2023 16:34:37 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@Oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-a-test-case-to-check-maple_alloc.patch removed from -mm tree
Message-Id: <20230418233438.3C0A4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add a test case to check maple_alloc
has been removed from the -mm tree.  Its filename was
     maple_tree-add-a-test-case-to-check-maple_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


