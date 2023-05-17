Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71DCC7EE23
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 22:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjEQWZS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 18:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjEQWZR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 18:25:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540B51B5;
        Wed, 17 May 2023 15:25:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5B81616B5;
        Wed, 17 May 2023 22:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416AEC433EF;
        Wed, 17 May 2023 22:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684362315;
        bh=d6/D82zsP0uxS9iJkuCksY9kY97Mw/ZiNPAhJuYdMfY=;
        h=Date:To:From:Subject:From;
        b=IUyCXbbWwICwrhenRHpeyTBb7W+eREiTetFlPP/QN6amTtrdmjaV9Nxaa2rbu2bWd
         FIHmw7D1Z403QpBb88dd5yhsYtD8p6hzz9YjgVDlXdmAmSzTyg+qZsDuuTU8vu8n9k
         VgxdUqDHkSVWDi3shgg02A9VC8UMEWQVMXx8f8WI=
Date:   Wed, 17 May 2023 15:25:14 -0700
To:     mm-commits@vger.kernel.org, support@spotco.us,
        stable@vger.kernel.org, rick.p.edgecombe@intel.com,
        mgkeyes@vigovproductions.net, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-make-maple-state-reusable-after-mas_empty_area.patch removed from -mm tree
Message-Id: <20230517222515.416AEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: make maple state reusable after mas_empty_area()
has been removed from the -mm tree.  Its filename was
     maple_tree-make-maple-state-reusable-after-mas_empty_area.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: make maple state reusable after mas_empty_area()
Date: Fri, 5 May 2023 22:58:29 +0800

Make mas->min and mas->max point to a node range instead of a leaf entry
range.  This allows mas to still be usable after mas_empty_area() returns.
Users would get unexpected results from other operations on the maple
state after calling the affected function.

For example, x86 MAP_32BIT mmap() acts as if there is no suitable gap when
there should be one.

Link: https://lkml.kernel.org/r/20230505145829.74574-1-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reported-by: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Reported-by: Tad <support@spotco.us>
Reported-by: Michael Keyes <mgkeyes@vigovproductions.net>
  Link: https://lore.kernel.org/linux-mm/32f156ba80010fd97dbaf0a0cdfc84366608624d.camel@intel.com/
  Link: https://lore.kernel.org/linux-mm/e6108286ac025c268964a7ead3aab9899f9bc6e9.camel@spotco.us/
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c~maple_tree-make-maple-state-reusable-after-mas_empty_area
+++ a/lib/maple_tree.c
@@ -5317,15 +5317,9 @@ int mas_empty_area(struct ma_state *mas,
 
 	mt = mte_node_type(mas->node);
 	pivots = ma_pivots(mas_mn(mas), mt);
-	if (offset)
-		mas->min = pivots[offset - 1] + 1;
-
-	if (offset < mt_pivots[mt])
-		mas->max = pivots[offset];
-
-	if (mas->index < mas->min)
-		mas->index = mas->min;
-
+	min = mas_safe_min(mas, pivots, offset);
+	if (mas->index < min)
+		mas->index = min;
 	mas->last = mas->index + size - 1;
 	return 0;
 }
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch

