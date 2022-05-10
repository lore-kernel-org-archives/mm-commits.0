Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BD3C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbiEJEOw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235922AbiEJEOi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADD36465
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E387B81AF5
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EEDC385C5;
        Tue, 10 May 2022 04:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155840;
        bh=CaCHT7p9QyP/NthFF6hzffQOv7POTVVoZLYTU4QNDg4=;
        h=Date:To:From:Subject:From;
        b=1kaWGPVbLLm+fSVKz0Ru8eKaYv7DJjwyvYJLHsNQyLrrLoDv5jATNKR9po4P/gBnw
         tflpDdOCo0k3BwDwYJPE8XNS8SfF0ByWhx5ECmm3QQ0m20CyxG6a66ITlcf2Y7MMaN
         GIVjoB6P9/QKq4XvC8nhCWI4Iqp9VcurzKwW0M/U=
Date:   Mon, 09 May 2022 21:10:39 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        hannes@cmpxchg.org, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch removed from -mm tree
Message-Id: <20220510041039.E3EEDC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: set pos explicitly for reclaim and !reclaim
has been removed from the -mm tree.  Its filename was
     mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: set pos explicitly for reclaim and !reclaim

During mem_cgroup_iter, there are two ways to get iteration position:
reclaim vs non-reclaim mode.

Let's do it explicitly for reclaim vs non-reclaim mode.

Link: https://lkml.kernel.org/r/20220330234719.18340-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim
+++ a/mm/memcontrol.c
@@ -1013,9 +1013,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	if (!root)
 		root = root_mem_cgroup;
 
-	if (prev && !reclaim)
-		pos = prev;
-
 	rcu_read_lock();
 
 	if (reclaim) {
@@ -1041,6 +1038,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			 */
 			(void)cmpxchg(&iter->position, pos, NULL);
 		}
+	} else if (prev) {
+		pos = prev;
 	}
 
 	if (pos)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-vmscan-filter-empty-page_list-at-the-beginning.patch
mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

