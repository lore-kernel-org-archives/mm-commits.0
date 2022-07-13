Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287EBC43334
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 15:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbiGMPdT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 11:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiGMPdT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 11:33:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B4F4D4C9
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 08:33:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BED4B81FC6
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 15:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFC7C34114;
        Wed, 13 Jul 2022 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657726395;
        bh=FTNxHm6b49DoUvexCyq0ZEmJo+nPkFVmveIVjO19SaA=;
        h=Date:To:From:Subject:From;
        b=qCvqmBWMVb3qlbmdkey8cy0UnCI1P8AokoNGfcx95z3YblgZ8VwkLF7tai9e+/7/Q
         jIB5ODRA0prkKAmm4+vRXqj6BXM4WdZVlsLRlqMCU82GjPAjvtlDLdI8WPYeqSb9hI
         UeuuMymqaPrbmclzO14eZ/58T0q+SNutMF9BRDEw=
Date:   Wed, 13 Jul 2022 08:33:14 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-4.patch added to mm-unstable branch
Message-Id: <20220713153315.9CFC7C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix out of bounds access on mas_wr_node_walk()
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-4.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix out of bounds access on mas_wr_node_walk()
Date: Wed, 13 Jul 2022 02:13:12 +0000

When walking the node, check to see if offset is within the range of
pivots before reading that pivot, otherwise return the max of the node.

Link: https://lkml.kernel.org/r/20220713021256.542856-1-Liam.Howlett@oracle.com
Fixes: d0aac5e48048 (Maple Tree: add new data structure)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-4
+++ a/lib/maple_tree.c
@@ -2254,10 +2254,10 @@ static inline void mas_wr_node_walk(stru
 					       wr_mas->pivots, mas->max);
 	offset = mas->offset;
 	min = mas_safe_min(mas, wr_mas->pivots, offset);
-	max = wr_mas->pivots[offset];
 	if (unlikely(offset == count))
-		goto max; /* may have been set to zero */
+		goto max;
 
+	max = wr_mas->pivots[offset];
 	index = mas->index;
 	if (unlikely(index <= max))
 		goto done;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
mm-remove-the-vma-linked-list-fix-3.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

