Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE46C678DC
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjASBTB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjASBRk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:17:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7056A689E3
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2650FB81FB6
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CEDC433F1;
        Thu, 19 Jan 2023 01:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090928;
        bh=pOhqEUlZM09UuLQEEBqysoZnbkyUHd65kNRHymxHNS0=;
        h=Date:To:From:Subject:From;
        b=DUwozEHZtL32ND705DiDr3BSjk2qHZncCVE/Xae3DDvHUFjnOROym3p3wBYz7ohFM
         CB6TAsnMyqri32ANtbI+642xcgV9ef616O1B9u/fWONZ4uP+PXsLpFEEaqUANGCbHb
         TVrq+YrTLkSPYo7BTsYOsZ6p4GX5MgE+aIAtUcSg=
Date:   Wed, 18 Jan 2023 17:15:28 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com, rppt@kernel.org,
        roman.gushchin@linux.dev, Michael@MichaelLarabel.com,
        mhocko@kernel.org, hannes@cmpxchg.org, corbet@lwn.net,
        yuzhao@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-simplify-arch_has_hw_pte_young-check.patch removed from -mm tree
Message-Id: <20230119011528.C4CEDC433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: simplify arch_has_hw_pte_young() check
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-simplify-arch_has_hw_pte_young-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: multi-gen LRU: simplify arch_has_hw_pte_young() check
Date: Wed, 21 Dec 2022 21:19:06 -0700

Scanning page tables when hardware does not set the accessed bit has
no real use cases.

Link: https://lkml.kernel.org/r/20221222041905.2431096-9-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Larabel <Michael@MichaelLarabel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-simplify-arch_has_hw_pte_young-check
+++ a/mm/vmscan.c
@@ -4428,7 +4428,7 @@ static bool try_to_inc_max_seq(struct lr
 	 * handful of PTEs. Spreading the work out over a period of time usually
 	 * is less efficient, but it avoids bursty page faults.
 	 */
-	if (!force_scan && !(arch_has_hw_pte_young() && get_cap(LRU_GEN_MM_WALK))) {
+	if (!arch_has_hw_pte_young() || !get_cap(LRU_GEN_MM_WALK)) {
 		success = iterate_mm_list_nowalk(lruvec, max_seq);
 		goto done;
 	}
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-multi-gen-lru-fix-crash-during-cgroup-migration.patch

