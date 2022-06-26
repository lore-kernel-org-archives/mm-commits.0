Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02035C43334
	for <mm-commits@archiver.kernel.org>; Sun, 26 Jun 2022 20:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiFZUjF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Jun 2022 16:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiFZUjF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Jun 2022 16:39:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF57DD8
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 13:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C47C7B80DF9
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 20:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BB3C34114;
        Sun, 26 Jun 2022 20:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656275940;
        bh=lGh3SkrqVPZhyRKe/e7OQFLBJCs/LeyKg1KnFQks8xY=;
        h=Date:To:From:Subject:From;
        b=RE/G4JsKVdPOAmfEftdDpXRpVgR6QDsBsJR+kT0DOUTOBw1r+iNXjbNxeMJslOFI/
         9BSDdWj6vB149XL5nMD2hS0jo+JCiWn6FBwUONIV4zk9OQZmQ9jcKH+xidD6p7eaIa
         Ly8SuHdfZtrVsZutK667rL+xZeHZuiG7VW+Uwjrw=
Date:   Sun, 26 Jun 2022 13:38:59 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix.patch added to mm-unstable branch
Message-Id: <20220626203900.60BB3C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix underflow in mas_spanning_rebalance()
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix.patch

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
Subject: maple_tree: fix underflow in mas_spanning_rebalance()
Date: Sat, 25 Jun 2022 00:39:06 +0000

When rebalancing a spanning store that spans the entire address space,
the big node end is not expanded the extra position that
mas_spanning_rebalance() expects.  Fix this by expanding on such cases.
Also change mab_mas_cp() from assuming there are at least two entries to
ensure the correct metadata is written.

Link: https://lkml.kernel.org/r/20220625003854.1230114-2-Liam.Howlett@oracle.com
Fixes: f8acc5e9581e (Maple Tree: add new data structure)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix
+++ a/lib/maple_tree.c
@@ -1977,7 +1977,6 @@ static inline void mab_mas_cp(struct map
 		slots[mt_pivots[mt]] = NULL;
 
 	i = mab_start;
-	pivots[j++] = b_node->pivot[i++];
 	do {
 		pivots[j++] = b_node->pivot[i++];
 	} while (i <= mab_end && likely(b_node->pivot[i]));
@@ -2970,7 +2969,7 @@ static int mas_spanning_rebalance(struct
 	mast->free = &free;
 	mast->destroy = &destroy;
 	l_mas.node = r_mas.node = m_mas.node = MAS_NONE;
-	if (!mas_is_root_limits(mast->orig_l) &&
+	if (!(mast->orig_l->min && mast->orig_r->max == ULONG_MAX) &&
 	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
 		mast_spanning_rebalance(mast);
 
@@ -4004,6 +4003,9 @@ static inline int mas_wr_spanning_store(
 	if (r_mas.offset <= r_wr_mas.node_end)
 		mas_mab_cp(&r_mas, r_mas.offset, r_wr_mas.node_end,
 			   &b_node, b_node.b_end + 1);
+	else
+		b_node.b_end++;
+
 	/* Stop spanning searches by searching for just index. */
 	l_mas.index = l_mas.last = mas->index;
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

