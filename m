Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F775C7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 21:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjEYVE5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 17:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240778AbjEYVEt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 17:04:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9D6194
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 14:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C839D64B21
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 21:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCD5C4339B;
        Thu, 25 May 2023 21:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685048670;
        bh=ETuIv4dd76EJ343+PkHTM1RsrWlpTSGZ7139ubaTol4=;
        h=Date:To:From:Subject:From;
        b=sVnIjtqBtMenYhxEt/vFn5w+jCJ7gVQlDgUGzQEG33g/TQhL5ECp3i1ocfHdVgfo5
         8pFA9o0vGO/bwcwScYKlxj5PemHFJDp2XqQzN4H1jEbBqhtHRRxUnfcDScjHonl37q
         mahXXUjmY6mRotb7azLxhb7xH1TMPpwrHbcO68Ow=
Date:   Thu, 25 May 2023 14:04:29 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-simplify-mas_is_span_wr.patch added to mm-unstable branch
Message-Id: <20230525210430.2BCD5C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: simplify mas_is_span_wr()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-simplify-mas_is_span_wr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-simplify-mas_is_span_wr.patch

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
Subject: maple_tree: simplify mas_is_span_wr()
Date: Wed, 24 May 2023 11:12:41 +0800

Make the code for detecting spanning writes more concise.

Link: https://lkml.kernel.org/r/20230524031247.65949-5-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

--- a/lib/maple_tree.c~maple_tree-simplify-mas_is_span_wr
+++ a/lib/maple_tree.c
@@ -3728,43 +3728,31 @@ static inline void mas_store_root(struct
  */
 static bool mas_is_span_wr(struct ma_wr_state *wr_mas)
 {
-	unsigned long max;
+	unsigned long max = wr_mas->r_max;
 	unsigned long last = wr_mas->mas->last;
-	unsigned long piv = wr_mas->r_max;
 	enum maple_type type = wr_mas->type;
 	void *entry = wr_mas->entry;
 
-	/* Contained in this pivot */
-	if (piv > last)
+	/* Contained in this pivot, fast path */
+	if (last < max)
 		return false;
 
-	max = wr_mas->mas->max;
-	if (unlikely(ma_is_leaf(type))) {
-		/* Fits in the node, but may span slots. */
+	if (ma_is_leaf(type)) {
+		max = wr_mas->mas->max;
 		if (last < max)
 			return false;
+	}
 
-		/* Writes to the end of the node but not null. */
-		if ((last == max) && entry)
-			return false;
-
+	if (last == max) {
 		/*
-		 * Writing ULONG_MAX is not a spanning write regardless of the
-		 * value being written as long as the range fits in the node.
+		 * The last entry of leaf node cannot be NULL unless it is the
+		 * rightmost node (writing ULONG_MAX), otherwise it spans slots.
 		 */
-		if ((last == ULONG_MAX) && (last == max))
-			return false;
-	} else if (piv == last) {
-		if (entry)
-			return false;
-
-		/* Detect spanning store wr walk */
-		if (last == ULONG_MAX)
+		if (entry || last == ULONG_MAX)
 			return false;
 	}
 
-	trace_ma_write(__func__, wr_mas->mas, piv, entry);
-
+	trace_ma_write(__func__, wr_mas->mas, wr_mas->r_max, entry);
 	return true;
 }
 
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

radix-tree-move-declarations-to-header-fix.patch
maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch
maple_tree-rework-mtree_alloc_rangerrange.patch
maple_tree-drop-mas_rev_alloc-and-mas_fill_gap.patch
maple_tree-fix-the-arguments-to-__must_hold.patch
maple_tree-simplify-mas_is_span_wr.patch
maple_tree-make-the-code-symmetrical-in-mas_wr_extend_null.patch
maple_tree-add-mas_wr_new_end-to-calculate-new_end-accurately.patch
maple_tree-add-comments-and-some-minor-cleanups-to-mas_wr_append.patch
maple_tree-rework-mas_wr_slot_store-to-be-cleaner-and-more-efficient.patch
maple_tree-simplify-and-clean-up-mas_wr_node_store.patch
maple_tree-relocate-the-declaration-of-mas_empty_area_rev.patch

