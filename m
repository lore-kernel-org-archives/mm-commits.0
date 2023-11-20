Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7C9C2BB3F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 20:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjKTUIs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 15:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjKTUIo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 15:08:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1666383
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 12:08:41 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A761BC433C8;
        Mon, 20 Nov 2023 20:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700510920;
        bh=6wOkdRQw6sZMHVDnKeP418VPQBEB5InL0U76hujoync=;
        h=Date:To:From:Subject:From;
        b=utU8j6siThUSw7WkpgKKFr46HiDsEkdv9r5PUjRO1Vq7TSYClo+g8J9CmxSpb0GmJ
         GmYJYxUea1br3mNyGv1RYTQKEgo0RmGkS5ULHPM7g68mI90goHgwQxs7m7E2tCefsY
         sTKLz4lZ6IpZQ/JeyKwr437GYvrdd0jN8xd6dcaE=
Date:   Mon, 20 Nov 2023 12:08:39 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        dan.carpenter@linaro.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-delete-one-of-the-two-identical-checks.patch added to mm-unstable branch
Message-Id: <20231120200840.A761BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: delete one of the two identical checks
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-delete-one-of-the-two-identical-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-delete-one-of-the-two-identical-checks.patch

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
Subject: maple_tree: delete one of the two identical checks
Date: Mon, 20 Nov 2023 15:09:36 +0800

There are two identical checks, delete one of them.

Link: https://lkml.kernel.org/r/20231120070937.35481-5-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-delete-one-of-the-two-identical-checks
+++ a/lib/maple_tree.c
@@ -4117,9 +4117,6 @@ static inline bool mas_wr_append(struct
 	if (mt_in_rcu(mas->tree))
 		return false;
 
-	if (mas->offset != mas->end)
-		return false;
-
 	end = mas->end;
 	if (mas->offset != end)
 		return false;
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

