Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0FBC54FB9
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 20:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjKTUIs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 15:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjKTUIq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 15:08:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D619FBE
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 12:08:42 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7158DC433CA;
        Mon, 20 Nov 2023 20:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700510922;
        bh=Ofd5jKomgAlhtxlT+phw084xKETbrgsSn4gEs+EsAl0=;
        h=Date:To:From:Subject:From;
        b=odEKBQnpM1z8c7yzrOhyzf7XFBsHstgI7z3dqtVrJVQMOm4n1W1oMtsrq+n8dA2rc
         dysgWsQNo41wp8DcsPo2R3kzVeBgzekYs7j+a5MdRUB5bosNMYJ3vTFdoPMS4EeCHr
         fNmqoCrQbSNIoCLsOI8hBvf/Zsk0I87+jwarGg48=
Date:   Mon, 20 Nov 2023 12:08:41 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        dan.carpenter@linaro.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-simplify-mas_leaf_set_meta.patch added to mm-unstable branch
Message-Id: <20231120200842.7158DC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: simplify mas_leaf_set_meta()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-simplify-mas_leaf_set_meta.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-simplify-mas_leaf_set_meta.patch

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
Subject: maple_tree: simplify mas_leaf_set_meta()
Date: Mon, 20 Nov 2023 15:09:37 +0800

Now it seems that the incoming 'end' is already pointing to the last item,
so we can simplify this function, considering only whether the last slot
is being used.  This has passed the maple tree test suite.

Link: https://lkml.kernel.org/r/20231120070937.35481-6-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/lib/maple_tree.c~maple_tree-simplify-mas_leaf_set_meta
+++ a/lib/maple_tree.c
@@ -1964,27 +1964,13 @@ complete:
 
 /*
  * mas_leaf_set_meta() - Set the metadata of a leaf if possible.
- * @mas: The maple state
  * @node: The maple node
- * @pivots: pointer to the maple node pivots
  * @mt: The maple type
- * @end: The assumed end
- *
- * Note, end may be incremented within this function but not modified at the
- * source.  This is fine since the metadata is the last thing to be stored in a
- * node during a write.
+ * @end: The node end
  */
-static inline void mas_leaf_set_meta(struct ma_state *mas,
-		struct maple_node *node, unsigned long *pivots,
+static inline void mas_leaf_set_meta(struct maple_node *node,
 		enum maple_type mt, unsigned char end)
 {
-	/* There is no room for metadata already */
-	if (mt_pivots[mt] <= end)
-		return;
-
-	if (pivots[end] && pivots[end] < mas->max)
-		end++;
-
 	if (end < mt_slots[mt] - 1)
 		ma_set_meta(node, mt, 0, end);
 }
@@ -2041,7 +2027,7 @@ static inline void mab_mas_cp(struct map
 
 		ma_set_meta(node, mt, offset, end);
 	} else {
-		mas_leaf_set_meta(mas, node, pivots, mt, end);
+		mas_leaf_set_meta(node, mt, end);
 	}
 }
 
@@ -3962,7 +3948,7 @@ static inline bool mas_wr_node_store(str
 		dst_pivots[new_end] = mas->max;
 
 done:
-	mas_leaf_set_meta(mas, newnode, dst_pivots, maple_leaf_64, new_end);
+	mas_leaf_set_meta(newnode, maple_leaf_64, new_end);
 	if (in_rcu) {
 		struct maple_enode *old_enode = mas->node;
 
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-add-mt_free_one-and-mt_attr-helpers.patch
maple_tree-introduce-mtreemas_lock_nested.patch
maple_tree-introduce-interfaces-__mt_dup-and-mtree_dup.patch
radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior.patch
maple_tree-add-test-for-mtree_dup.patch
maple_tree-update-the-documentation-of-maple-tree.patch
maple_tree-skip-other-tests-when-bench-is-enabled.patch
maple_tree-update-check_forking-and-bench_forking.patch
maple_tree-preserve-the-tree-attributes-when-destroying-maple-tree.patch
fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap.patch
maple_tree-move-the-check-forward-to-avoid-static-check-warning.patch
maple_tree-avoid-ascending-when-mas-min-is-also-the-parents-minimum.patch
maple_tree-remove-an-unused-parameter-for-ma_meta_end.patch
maple_tree-delete-one-of-the-two-identical-checks.patch
maple_tree-simplify-mas_leaf_set_meta.patch

