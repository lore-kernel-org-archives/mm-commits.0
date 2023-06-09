Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457EBC83005
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbjFIXc7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjFIXbk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948E946A2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75BD465D07
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE39AC433EF;
        Fri,  9 Jun 2023 23:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353371;
        bh=/y7MXinw4tlaCIwkQRKK3Ud2JAUwKh8CCNzTIQ73gEE=;
        h=Date:To:From:Subject:From;
        b=zp4zTGPyeOsMSy6NG1PtwUhe6xXwipKjFJ+0C5+JWX3dUBHbSrArWiqgsYct7iajE
         G8n+XwXw1PMsW03aX3/wstoxjH62KG/wcbBlDt2RzjQHqZBTfmy+wAWsZzH5yV5AWM
         SOXFPYpn2dgCudeLOVYGIreQSrUcXdHt1Al4TUK8=
Date:   Fri, 09 Jun 2023 16:29:31 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-simplify-mas_is_span_wr.patch removed from -mm tree
Message-Id: <20230609232931.CE39AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: simplify mas_is_span_wr()
has been removed from the -mm tree.  Its filename was
     maple_tree-simplify-mas_is_span_wr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


