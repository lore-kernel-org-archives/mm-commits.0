Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 834CCC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 01:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiCaBqk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 21:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352337AbiCaBqj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 21:46:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF4D4889C
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 18:44:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC42EB81E45
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 01:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759E9C340EC;
        Thu, 31 Mar 2022 01:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648691090;
        bh=M+lmlQrNlIqR3E/g3uXTyLhHxGU07PSF23I8kkV3J8E=;
        h=Date:To:From:Subject:From;
        b=ezyloyhDqZriXWXRf/1iROX+Y/ViAEjYlrTrjFRF/reTnt85+q7nM3N+NrXSSa5lf
         U6IYYDPYGBaycaDR1zFsIfPVIKa93H9U/Danubxm5X14lks2s125ZfNfOaMH0mjUff
         ZH9pK9ug6pP6yPqY775xKa6V/EhVoG0+ePMMEmm0=
Date:   Wed, 30 Mar 2022 18:44:49 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-set-memcg-after-css-verified-and-got-reference.patch added to -mm tree
Message-Id: <20220331014450.759E9C340EC@smtp.kernel.org>
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

Patch series "mm/memcg: some cleanup for mem_cgroup_iter()", v2.

No functional change, try to make it more readable.


This patch (of 3):

Instead of resetting memcg when css is either not verified or not got
reference, we can set it after these process.

No functional change, just simplified the code a little.

Link: https://lkml.kernel.org/r/20220330234719.18340-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20220330234719.18340-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-set-memcg-after-css-verified-and-got-reference
+++ a/mm/memcontrol.c
@@ -1065,15 +1065,10 @@ struct mem_cgroup *mem_cgroup_iter(struc
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

mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch
mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch
mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch

