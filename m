Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA763C197A0
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 20:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjKTUIn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 15:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjKTUIm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 15:08:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3747DCB
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 12:08:39 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A92C433C9;
        Mon, 20 Nov 2023 20:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700510918;
        bh=we7xro4WeoHJ27rIfAw7Q3OD9kUMFR6nJnLxeScji38=;
        h=Date:To:From:Subject:From;
        b=IJOG7ferl+u6a5Ud7+By48sxNqUHI8A9kKW3srrGOpGjwjxdIv4BXxXd2tLT/QzT+
         2WHf28UMO3hdeA0nCrbur6uW95BlEhKNn4GT5wGSx8fAgQ4Zsxd/s6WiJbpgO6nqeg
         fLeyk5Ov5lXjy64nU/krtBEMVkOquoVgSmSjtm7E=
Date:   Mon, 20 Nov 2023 12:08:38 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        dan.carpenter@linaro.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-an-unused-parameter-for-ma_meta_end.patch added to mm-unstable branch
Message-Id: <20231120200838.C9A92C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: remove an unused parameter for ma_meta_end()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-an-unused-parameter-for-ma_meta_end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-an-unused-parameter-for-ma_meta_end.patch

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
Subject: maple_tree: remove an unused parameter for ma_meta_end()
Date: Mon, 20 Nov 2023 15:09:35 +0800

The parameter maple_type is not used, so remove it.

Link: https://lkml.kernel.org/r/20231120070937.35481-4-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-an-unused-parameter-for-ma_meta_end
+++ a/lib/maple_tree.c
@@ -930,10 +930,8 @@ static inline unsigned char ma_meta_end(
 /*
  * ma_meta_gap() - Get the largest gap location of a node from the metadata
  * @mn: The maple node
- * @mt: The maple node type
  */
-static inline unsigned char ma_meta_gap(struct maple_node *mn,
-					enum maple_type mt)
+static inline unsigned char ma_meta_gap(struct maple_node *mn)
 {
 	return mn->ma64.meta.gap;
 }
@@ -1587,7 +1585,7 @@ static inline unsigned long mas_max_gap(
 
 	node = mas_mn(mas);
 	MAS_BUG_ON(mas, mt != maple_arange_64);
-	offset = ma_meta_gap(node, mt);
+	offset = ma_meta_gap(node);
 	gaps = ma_gaps(node, mt);
 	return gaps[offset];
 }
@@ -1618,7 +1616,7 @@ static inline void mas_parent_gap(struct
 
 ascend:
 	MAS_BUG_ON(mas, pmt != maple_arange_64);
-	meta_offset = ma_meta_gap(pnode, pmt);
+	meta_offset = ma_meta_gap(pnode);
 	meta_gap = pgaps[meta_offset];
 
 	pgaps[offset] = new;
@@ -7252,7 +7250,7 @@ static void mas_validate_gaps(struct ma_
 counted:
 	if (mt == maple_arange_64) {
 		MT_BUG_ON(mas->tree, !gaps);
-		offset = ma_meta_gap(node, mt);
+		offset = ma_meta_gap(node);
 		if (offset > i) {
 			pr_err("gap offset %p[%u] is invalid\n", node, offset);
 			MT_BUG_ON(mas->tree, 1);
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

