Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BC8C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjFIXdA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbjFIXb5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC69B46A3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82CC863EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF30C433EF;
        Fri,  9 Jun 2023 23:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353373;
        bh=qO1OUWyZMA6wYfgUNFeGBtaRk9UbXPmQ2ne0LUnwtPk=;
        h=Date:To:From:Subject:From;
        b=Q5m5iVTlreZfBnDtA3hL7xsqyQgOcgCF6KuKfam4EnmRJBSm6VLPRYusdmpNkmM6B
         85bPKUKhmvjCex55xdHkQRhLoYmRZZ1ID6ppwCrhQuIlkZ8jbpNArDAIsZa3tX7x6L
         fixAAXrZxk/XHXtGTS+qOnHLBEu7EvlRVwz4l7Vs=
Date:   Fri, 09 Jun 2023 16:29:32 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-make-the-code-symmetrical-in-mas_wr_extend_null.patch removed from -mm tree
Message-Id: <20230609232932.DBF30C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: make the code symmetrical in mas_wr_extend_null()
has been removed from the -mm tree.  Its filename was
     maple_tree-make-the-code-symmetrical-in-mas_wr_extend_null.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: make the code symmetrical in mas_wr_extend_null()
Date: Wed, 24 May 2023 11:12:42 +0800

Just make the code symmetrical to improve readability.

Link: https://lkml.kernel.org/r/20230524031247.65949-6-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/lib/maple_tree.c~maple_tree-make-the-code-symmetrical-in-mas_wr_extend_null
+++ a/lib/maple_tree.c
@@ -4264,19 +4264,21 @@ static inline void mas_wr_extend_null(st
 {
 	struct ma_state *mas = wr_mas->mas;
 
-	if (mas->last < wr_mas->end_piv && !wr_mas->slots[wr_mas->offset_end])
+	if (!wr_mas->slots[wr_mas->offset_end]) {
+		/* If this one is null, the next and prev are not */
 		mas->last = wr_mas->end_piv;
-
-	/* Check next slot(s) if we are overwriting the end */
-	if ((mas->last == wr_mas->end_piv) &&
-	    (wr_mas->node_end != wr_mas->offset_end) &&
-	    !wr_mas->slots[wr_mas->offset_end + 1]) {
-		wr_mas->offset_end++;
-		if (wr_mas->offset_end == wr_mas->node_end)
-			mas->last = mas->max;
-		else
-			mas->last = wr_mas->pivots[wr_mas->offset_end];
-		wr_mas->end_piv = mas->last;
+	} else {
+		/* Check next slot(s) if we are overwriting the end */
+		if ((mas->last == wr_mas->end_piv) &&
+		    (wr_mas->node_end != wr_mas->offset_end) &&
+		    !wr_mas->slots[wr_mas->offset_end + 1]) {
+			wr_mas->offset_end++;
+			if (wr_mas->offset_end == wr_mas->node_end)
+				mas->last = mas->max;
+			else
+				mas->last = wr_mas->pivots[wr_mas->offset_end];
+			wr_mas->end_piv = mas->last;
+		}
 	}
 
 	if (!wr_mas->content) {
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


