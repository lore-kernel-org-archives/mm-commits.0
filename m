Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC4BECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiILDdP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiILDbR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:31:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA0F13F05
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 033156116D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57999C433D6;
        Mon, 12 Sep 2022 03:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953384;
        bh=WWrsXuj8ER0FzgI7LZFshHf11nthGGSW+0gbeiXwyDg=;
        h=Date:To:From:Subject:From;
        b=p9RCVSQ20wgNb9bcIPTqPQEUowtWMCxe/AW4sSI54Kxv8tUBoRaQG2Pg7aObOCxQx
         U7YZyw6FmupqJohDaWBdsNjy1Rp+vTdv4Vgw6hTCRr9FBizwNBMux8W5NCp99kT/PU
         I0kjy91fCxRIa7OdtL9d1Shyr8Hlp4jLekX7YomM=
Date:   Sun, 11 Sep 2022 20:29:43 -0700
To:     mm-commits@vger.kernel.org, minhquangbui99@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-skip-retry-when-new-limit-is-not-below-old-one-in-page_counter_set_max.patch removed from -mm tree
Message-Id: <20220912032944.57999C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: skip retry when new limit is not below old one in page_counter_set_max
has been removed from the -mm tree.  Its filename was
     mm-skip-retry-when-new-limit-is-not-below-old-one-in-page_counter_set_max.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bui Quang Minh <minhquangbui99@gmail.com>
Subject: mm: skip retry when new limit is not below old one in page_counter_set_max
Date: Sun, 21 Aug 2022 22:40:55 +0700

In page_counter_set_max, we want to make sure the new limit is not below
the concurrently-changing counter value.  We read the counter and check
that the limit is not below the counter before the swap.  After the swap,
we read the counter again and retry in case the counter is incremented as
this may violate the requirement.  Even though the page_counter_try_charge
can see the old limit, it is guaranteed that the counter is not above the
old limit after the increment.  So in case the new limit is not below the
old limit, the counter is guaranteed to be not above the new limit too. 
We can skip the retry in this case to optimize a little bit.

Link: https://lkml.kernel.org/r/20220821154055.109635-1-minhquangbui99@gmail.com
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_counter.c~mm-skip-retry-when-new-limit-is-not-below-old-one-in-page_counter_set_max
+++ a/mm/page_counter.c
@@ -193,7 +193,7 @@ int page_counter_set_max(struct page_cou
 
 		old = xchg(&counter->max, nr_pages);
 
-		if (page_counter_read(counter) <= usage)
+		if (page_counter_read(counter) <= usage || nr_pages >= old)
 			return 0;
 
 		counter->max = old;
_

Patches currently in -mm which might be from minhquangbui99@gmail.com are


