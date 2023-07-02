Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC10EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 22:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjGBWdi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 18:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjGBWdi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 18:33:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4FCE67
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 15:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 631E160CE8
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 22:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7D8C433C7;
        Sun,  2 Jul 2023 22:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688337211;
        bh=m3UVtwinSSEpssaE1YsSSu4kjojaBnfKocBo7G/g+4c=;
        h=Date:To:From:Subject:From;
        b=Ff6lam1cHa0PSnfw5qa8zwBQ9Evk9lWGAzLnsxvJPkVsB2wXsEGuo5XI3qrZglpXC
         iUawE3J0uoxljMsJVF28CmVmF15nLOpQcmz6Aro/K+f4CLhLggG6CWAyvrPKD+dtZE
         eeMbtWUuYvzzq5BDte5zh3osbE9HKD2etWxDymlE=
Date:   Sun, 02 Jul 2023 15:33:31 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-test-for-mas_wr_modify-fast-path.patch added to mm-unstable branch
Message-Id: <20230702223331.BC7D8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add test for mas_wr_modify() fast path
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-test-for-mas_wr_modify-fast-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-test-for-mas_wr_modify-fast-path.patch

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
Subject: maple_tree: add test for mas_wr_modify() fast path
Date: Wed, 28 Jun 2023 15:36:54 +0800

Patch series "Optimize the fast path of mas_store()", v4.

Add fast paths for mas_wr_append() and mas_wr_slot_store() respectively.
The newly added fast path of mas_wr_append() is used in fork() and how
much it benefits fork() depends on how many VMAs are duplicated.

Thanks Liam for the review.


This patch (of 4):

Add tests for all cases of mas_wr_append() and mas_wr_slot_store().

Link: https://lkml.kernel.org/r/20230628073657.75314-1-zhangpeng.00@bytedance.com
Link: https://lkml.kernel.org/r/20230628073657.75314-2-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   65 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

--- a/lib/test_maple_tree.c~maple_tree-add-test-for-mas_wr_modify-fast-path
+++ a/lib/test_maple_tree.c
@@ -1157,6 +1157,71 @@ static noinline void __init check_ranges
 	MT_BUG_ON(mt, !mt_height(mt));
 	mtree_destroy(mt);
 
+	/* Check in-place modifications */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	/* Append to the start of last range */
+	mt_set_non_kernel(50);
+	for (i = 0; i <= 500; i++) {
+		val = i * 5 + 1;
+		val2 = val + 4;
+		check_store_range(mt, val, val2, xa_mk_value(val), 0);
+	}
+
+	/* Append to the last range without touching any boundaries */
+	for (i = 0; i < 10; i++) {
+		val = val2 + 5;
+		val2 = val + 4;
+		check_store_range(mt, val, val2, xa_mk_value(val), 0);
+	}
+
+	/* Append to the end of last range */
+	val = val2;
+	for (i = 0; i < 10; i++) {
+		val += 5;
+		MT_BUG_ON(mt, mtree_test_store_range(mt, val, ULONG_MAX,
+						     xa_mk_value(val)) != 0);
+	}
+
+	/* Overwriting the range and over a part of the next range */
+	for (i = 10; i < 30; i += 2) {
+		val = i * 5 + 1;
+		val2 = val + 5;
+		check_store_range(mt, val, val2, xa_mk_value(val), 0);
+	}
+
+	/* Overwriting a part of the range and over the next range */
+	for (i = 50; i < 70; i += 2) {
+		val2 = i * 5;
+		val = val2 - 5;
+		check_store_range(mt, val, val2, xa_mk_value(val), 0);
+	}
+
+	/*
+	 * Expand the range, only partially overwriting the previous and
+	 * next ranges
+	 */
+	for (i = 100; i < 130; i += 3) {
+		val = i * 5 - 5;
+		val2 = i * 5 + 1;
+		check_store_range(mt, val, val2, xa_mk_value(val), 0);
+	}
+
+	/*
+	 * Expand the range, only partially overwriting the previous and
+	 * next ranges, in RCU mode
+	 */
+	mt_set_in_rcu(mt);
+	for (i = 150; i < 180; i += 3) {
+		val = i * 5 - 5;
+		val2 = i * 5 + 1;
+		check_store_range(mt, val, val2, xa_mk_value(val), 0);
+	}
+
+	MT_BUG_ON(mt, !mt_height(mt));
+	mt_validate(mt);
+	mt_set_non_kernel(0);
+	mtree_destroy(mt);
+
 	/* Test rebalance gaps */
 	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
 	mt_set_non_kernel(50);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-add-test-for-mas_wr_modify-fast-path.patch
maple_tree-add-test-for-expanding-range-in-rcu-mode.patch
maple_tree-optimize-mas_wr_append-also-improve-duplicating-vmas.patch
maple_tree-add-a-fast-path-case-in-mas_wr_slot_store.patch

