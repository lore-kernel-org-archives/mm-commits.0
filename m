Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E326C197A0
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 20:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjKTUIj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 15:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjKTUIj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 15:08:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AC283
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 12:08:35 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80906C433C9;
        Mon, 20 Nov 2023 20:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700510915;
        bh=Dm/FdIXzTd6VkJtc2chpWUMEAbVYpfL17wcLN0+D3dE=;
        h=Date:To:From:Subject:From;
        b=W334C2WTdjrtf//hzZE2s+mdpGB/sfr7enZwDtRRSLw7CF1hVXxLk9spWKd3Rt65P
         8zsJzMjZOsRrShetAXZwVZxtduuFAVsT8FNehfg1TrwWX5MPK3E0Htz8ifv4TSx4L9
         TDCEH8s8zYB1CbWxmGSZJPJf+UV+uXIsyNKi0o/Q=
Date:   Mon, 20 Nov 2023 12:08:34 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        dan.carpenter@linaro.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-move-the-check-forward-to-avoid-static-check-warning.patch added to mm-unstable branch
Message-Id: <20231120200835.80906C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: move the check forward to avoid static check warning
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-move-the-check-forward-to-avoid-static-check-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-move-the-check-forward-to-avoid-static-check-warning.patch

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
Subject: maple_tree: move the check forward to avoid static check warning
Date: Mon, 20 Nov 2023 15:09:33 +0800

Patch series "Some cleanups of maple tree", v2.

These are some small cleanups of maple tree.


This patch (of 5):

Put the check for gap before its reference to avoid Smatch static check
warnings.  This is not a bug, it's just a validation program.  Even with
this change, Smatch may still generate warnings because MT_BUG_ON()
doesn't necessarily stop the program.  It may require fixing Smatch itself
to avoid these warnings.

Link: https://lkml.kernel.org/r/20231120070937.35481-1-zhangpeng.00@bytedance.com
Link: https://lkml.kernel.org/r/20231120070937.35481-2-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: http://lists.infradead.org/pipermail/maple-tree/2023-November/003046.html
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-move-the-check-forward-to-avoid-static-check-warning
+++ a/lib/maple_tree.c
@@ -7249,6 +7249,7 @@ static void mas_validate_gaps(struct ma_
 
 counted:
 	if (mt == maple_arange_64) {
+		MT_BUG_ON(mas->tree, !gaps);
 		offset = ma_meta_gap(node, mt);
 		if (offset > i) {
 			pr_err("gap offset %p[%u] is invalid\n", node, offset);
@@ -7261,7 +7262,6 @@ counted:
 			MT_BUG_ON(mas->tree, 1);
 		}
 
-		MT_BUG_ON(mas->tree, !gaps);
 		for (i++ ; i < mt_slot_count(mte); i++) {
 			if (gaps[i] != 0) {
 				pr_err("gap %p[%u] beyond node limit != 0\n",
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

