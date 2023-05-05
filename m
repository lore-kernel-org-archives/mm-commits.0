Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419AEC77B7F
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 20:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjEEUFm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 16:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjEEUFl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 16:05:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D97F1BE4;
        Fri,  5 May 2023 13:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 872E76406D;
        Fri,  5 May 2023 20:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9120C433D2;
        Fri,  5 May 2023 20:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683317136;
        bh=TL9yHmjw458DbDGdwIebwFwl9m1AzNPbuJGudKkLUlI=;
        h=Date:To:From:Subject:From;
        b=C5mRN2eOCya+JRR9GcUN4cdWpJsEm6rwqY+UKRBJyWbg8dQTRk0pSgVj4r5f0RNax
         H8xPoIo5Xig9dyX4xMQbL+2IGaRR3pKtYbiUMR2kZtB0kujx+h5XlAa8Yy9XhzeRxj
         GuWfWpITMhRVzqWDJYNwP4THxNMNCIcaZo45AwKY=
Date:   Fri, 05 May 2023 13:05:36 -0700
To:     mm-commits@vger.kernel.org, support@spotco.us,
        stable@vger.kernel.org, rick.p.edgecombe@intel.com,
        mgkeyes@vigovproductions.net, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-make-maple-state-reusable-after-mas_empty_area.patch added to mm-hotfixes-unstable branch
Message-Id: <20230505200536.D9120C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: make maple state reusable after mas_empty_area()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-make-maple-state-reusable-after-mas_empty_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-make-maple-state-reusable-after-mas_empty_area.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

maple_tree-make-maple-state-reusable-after-mas_empty_area.patch

