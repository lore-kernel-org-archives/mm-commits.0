Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33AEC6FD1D
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 20:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbjDDUZP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 16:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbjDDUZK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 16:25:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7B5422D
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 13:25:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66D79636F7
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 20:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90FFC433EF;
        Tue,  4 Apr 2023 20:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680639906;
        bh=YnVmxdveVhJHI3arDmU24Q5/CWrU5yGo6frqLmTlFo8=;
        h=Date:To:From:Subject:From;
        b=wObqiu+fWRtV0FjPF/RlD3xyJGPoW+fdnCDPJGTH+KeKVNP0Nn908a0+uQsXZymBb
         9u9HlpSYNp0DBqm6hkHXi9Eeznw483E1myPWD+ZFSkAWra77i1wxg5clC7MNqpjRWB
         rlLxwUSHQp9LAv2Yhi8aWrSrPHhBxxgOMiOgpLWI=
Date:   Tue, 04 Apr 2023 13:25:06 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-a-potential-concurrency-bug-in-rcu-mode.patch added to mm-unstable branch
Message-Id: <20230404202506.B90FFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix a potential concurrency bug in RCU mode
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-a-potential-concurrency-bug-in-rcu-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-a-potential-concurrency-bug-in-rcu-mode.patch

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
Subject: maple_tree: fix a potential concurrency bug in RCU mode
Date: Tue, 14 Mar 2023 20:42:03 +0800

There is a concurrency bug that may cause the wrong value to be loaded
when a CPU is modifying the maple tree.

CPU1:
mtree_insert_range()
  mas_insert()
    mas_store_root()
      ...
      mas_root_expand()
        ...
        rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
        ma_set_meta(node, maple_leaf_64, 0, slot);    <---IP

CPU2:
mtree_load()
  mtree_lookup_walk()
    ma_data_end();

When CPU1 is about to execute the instruction pointed to by IP, the
ma_data_end() executed by CPU2 may return the wrong end position, which
will cause the value loaded by mtree_load() to be wrong.

An example of triggering the bug:

Add mdelay(100) between rcu_assign_pointer() and ma_set_meta() in
mas_root_expand().

static DEFINE_MTREE(tree);
int work(void *p) {
	unsigned long val;
	for (int i = 0 ; i< 30; ++i) {
		val = (unsigned long)mtree_load(&tree, 8);
		mdelay(5);
		pr_info("%lu",val);
	}
	return 0;
}

mt_init_flags(&tree, MT_FLAGS_USE_RCU);
mtree_insert(&tree, 0, (void*)12345, GFP_KERNEL);
run_thread(work)
mtree_insert(&tree, 1, (void*)56789, GFP_KERNEL);

In RCU mode, mtree_load() should always return the value before or after
the data structure is modified, and in this example mtree_load(&tree, 8)
may return 56789 which is not expected, it should always return NULL.  Fix
it by put ma_set_meta() before rcu_assign_pointer().

Link: https://lkml.kernel.org/r/20230314124203.91572-4-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-a-potential-concurrency-bug-in-rcu-mode
+++ a/lib/maple_tree.c
@@ -3701,10 +3701,9 @@ static inline int mas_root_expand(struct
 		slot++;
 	mas->depth = 1;
 	mas_set_height(mas);
-
+	ma_set_meta(node, maple_leaf_64, 0, slot);
 	/* swap the new root into the tree */
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
-	ma_set_meta(node, maple_leaf_64, 0, slot);
 	return slot;
 }
 
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

mm-kfence-improve-the-performance-of-__kfence_alloc-and-__kfence_free.patch
maple_tree-fix-get-wrong-data_end-in-mtree_lookup_walk.patch
maple_tree-simplify-mas_wr_node_walk.patch
maple_tree-fix-a-potential-concurrency-bug-in-rcu-mode.patch

