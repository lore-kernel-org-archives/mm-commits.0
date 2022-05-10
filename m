Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57587C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbiEJEOx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235915AbiEJEOi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED5460CA
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30EC8B81AEF
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78A8C385C2;
        Tue, 10 May 2022 04:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155838;
        bh=7ge8CxQgXzE+K0qdBiN38l8slEgV9a6Ph6I9x0QqdBc=;
        h=Date:To:From:Subject:From;
        b=OdijrcqreKRH8OIgOTvriEdXuBcC4/OU5nn7pGvsaPLGg5QH2UYg3FgotIcZJ7/Co
         q5gcdXw7mr9Z2RvrQ7UIw2R0tSZMLEZ8IFSfmx373LEr6HmEo8jzxE1VemZyY4bj4H
         rP+pRtDj06KsuVo+APxmBgBqQYJKH0fmCfdMw9YQ=
Date:   Mon, 09 May 2022 21:10:38 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-set-memcg-after-css-verified-and-got-reference.patch removed from -mm tree
Message-Id: <20220510041038.D78A8C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: set memcg after css verified and got reference
has been removed from the -mm tree.  Its filename was
     mm-memcg-set-memcg-after-css-verified-and-got-reference.patch

This patch was dropped because it was merged into mm-stable

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

mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-vmscan-filter-empty-page_list-at-the-beginning.patch
mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

