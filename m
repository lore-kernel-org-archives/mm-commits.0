Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542E8C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 05:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiB1Fi3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 00:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbiB1Fi1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 00:38:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32B722B0D
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 21:37:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76E0CCE108B
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 05:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BEFC340E7;
        Mon, 28 Feb 2022 05:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646026664;
        bh=nNZ6yFMG/ibkh7HShKsd+nft4KEj0ZrQW92YxogHk3c=;
        h=Date:To:From:Subject:From;
        b=GRl8OJWm7S1bZRSQnkV7CHSEmsemeMA8vxpecPSxiRRfTp+N9iRTeNNlaXh6ALnMR
         iaBxxA3OXa8CEOx8DUX80VKoZ3gAgp2XziidbyS4k3XZMeAHSAASpLnB85GFjmNK8G
         3ROJnFPsAA6bT7iBf+Rwmm+v7qZRDc/cP4FWZtRE=
Date:   Sun, 27 Feb 2022 21:37:44 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-set-memcg-after-css-verified-and-got-reference.patch added to -mm tree
Message-Id: <20220228053744.D6BEFC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: set memcg after css verified and got reference
has been added to the -mm tree.  Its filename is
     mm-memcg-set-memcg-after-css-verified-and-got-reference.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-set-memcg-after-css-verified-and-got-reference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1040,15 +1040,10 @@ struct mem_cgroup *mem_cgroup_iter(struc
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
mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
mm-memcg-set-pos-to-prev-unconditionally.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

