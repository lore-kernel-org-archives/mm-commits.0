Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2D0C636D7
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjBJAwd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjBJAwb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405616D8E7
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AABA161BA3
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100BBC433D2;
        Fri, 10 Feb 2023 00:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990346;
        bh=lPIbF+wBab+FAAiPHF9saa5g8Spnu4HxzZ8LiWU5goU=;
        h=Date:To:From:Subject:From;
        b=BoQuCMui8DiMnxTsNOEij751JA8aX+8fHH0t9pUOt7aF8Yq/8Y8NiCSWmIso+esbO
         sikBAwtrMl0TxwZkA+CQgR/iSEyjA1bI6o4nh7ghCQ/3XLTjkmis2O2FstDqC7VvPS
         MBsCSOlFdy0xz9fSDn6IqjJYdEtIq257hf7wA2M8=
Date:   Thu, 09 Feb 2023 16:52:25 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] test_maple_tree-test-modifications-while-iterating.patch removed from -mm tree
Message-Id: <20230210005226.100BBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: test_maple_tree: test modifications while iterating
has been removed from the -mm tree.  Its filename was
     test_maple_tree-test-modifications-while-iterating.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: test_maple_tree: test modifications while iterating
Date: Fri, 20 Jan 2023 11:26:05 -0500

Add a testcase to ensure the iterator detects bad states on modifications
and does what the user expects

Link: https://lkml.kernel.org/r/20230120162650.984577-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   72 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

--- a/lib/test_maple_tree.c~test_maple_tree-test-modifications-while-iterating
+++ a/lib/test_maple_tree.c
@@ -1709,6 +1709,74 @@ static noinline void check_forking(struc
 	mtree_destroy(&newmt);
 }
 
+static noinline void check_iteration(struct maple_tree *mt)
+{
+	int i, nr_entries = 125;
+	void *val;
+	MA_STATE(mas, mt, 0, 0);
+
+	for (i = 0; i <= nr_entries; i++)
+		mtree_store_range(mt, i * 10, i * 10 + 9,
+				  xa_mk_value(i), GFP_KERNEL);
+
+	mt_set_non_kernel(99999);
+
+	i = 0;
+	mas_lock(&mas);
+	mas_for_each(&mas, val, 925) {
+		MT_BUG_ON(mt, mas.index != i * 10);
+		MT_BUG_ON(mt, mas.last != i * 10 + 9);
+		/* Overwrite end of entry 92 */
+		if (i == 92) {
+			mas.index = 925;
+			mas.last = 929;
+			mas_store(&mas, val);
+		}
+		i++;
+	}
+	/* Ensure mas_find() gets the next value */
+	val = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, val != xa_mk_value(i));
+
+	mas_set(&mas, 0);
+	i = 0;
+	mas_for_each(&mas, val, 785) {
+		MT_BUG_ON(mt, mas.index != i * 10);
+		MT_BUG_ON(mt, mas.last != i * 10 + 9);
+		/* Overwrite start of entry 78 */
+		if (i == 78) {
+			mas.index = 780;
+			mas.last = 785;
+			mas_store(&mas, val);
+		} else {
+			i++;
+		}
+	}
+	val = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, val != xa_mk_value(i));
+
+	mas_set(&mas, 0);
+	i = 0;
+	mas_for_each(&mas, val, 765) {
+		MT_BUG_ON(mt, mas.index != i * 10);
+		MT_BUG_ON(mt, mas.last != i * 10 + 9);
+		/* Overwrite end of entry 76 and advance to the end */
+		if (i == 76) {
+			mas.index = 760;
+			mas.last = 765;
+			mas_store(&mas, val);
+			mas_next(&mas, ULONG_MAX);
+		}
+		i++;
+	}
+	/* Make sure the next find returns the one after 765, 766-769 */
+	val = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, val != xa_mk_value(76));
+	mas_unlock(&mas);
+	mas_destroy(&mas);
+	mt_set_non_kernel(0);
+}
+
 static noinline void check_mas_store_gfp(struct maple_tree *mt)
 {
 
@@ -2660,6 +2728,10 @@ static int maple_tree_seed(void)
 #endif
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_iteration(&tree);
+	mtree_destroy(&tree);
+
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_forking(&tree);
 	mtree_destroy(&tree);
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


