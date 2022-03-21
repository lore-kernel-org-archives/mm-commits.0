Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5F7C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Mar 2022 21:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiCUVGd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Mar 2022 17:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiCUVGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2022 17:06:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3242983C
        for <mm-commits@vger.kernel.org>; Mon, 21 Mar 2022 14:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4242661240
        for <mm-commits@vger.kernel.org>; Mon, 21 Mar 2022 21:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C18C340E8;
        Mon, 21 Mar 2022 21:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647896704;
        bh=atc4DZdIdwPMN+Dqe54r2925M6SBI3FPh/+j7ytObjs=;
        h=Date:To:From:Subject:From;
        b=CsEOGCPnZszryFJDyuLE1a/9T+E2fFpa1DY5rU3Ctw1FsFygzVFn0KAfcr7TsASBy
         blmYYNjgqAlxAyEVTQSjwb42n00DU8xLjy3jQdXC2xIGYs71pc/rB/LZfYl3HhqULH
         rl7pNSXEw98lGv+X5furRu1AfATnJAwuf+ZlnCUM=
Date:   Mon, 21 Mar 2022 14:05:03 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-memcg-set-memcg-after-css-verified-and-got-reference.patch removed from -mm tree
Message-Id: <20220321210504.87C18C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: set memcg after css verified and got reference
has been removed from the -mm tree.  Its filename was
     mm-memcg-set-memcg-after-css-verified-and-got-reference.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: set memcg after css verified and got reference

Patch series "mm/memcg: some cleanup for mem_cgroup_iter()".


This patch (of 3):

Instead of resetting memcg when css is either not verified or has no
reference, we can set it after these are processed.

No functional change, just simplified the code a little.

Link: https://lkml.kernel.org/r/20220225003437.12620-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-set-memcg-after-css-verified-and-got-reference
+++ a/mm/memcontrol.c
@@ -1050,15 +1050,10 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		 * is provided by the caller, so we know it's alive
 		 * and kicking, and don't take an extra reference.
 		 */
-		memcg = mem_cgroup_from_css(css);
-
-		if (css == &root->css)
-			break;
-
-		if (css_tryget(css))
+		if (css == &root->css || css_tryget(css)) {
+			memcg = mem_cgroup_from_css(css);
 			break;
-
-		memcg = NULL;
+		}
 	}
 
 	if (reclaim) {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch
mm-memcg-retrieve-parent-memcg-from-cssparent.patch
mm-memcg-set-pos-to-prev-unconditionally.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

