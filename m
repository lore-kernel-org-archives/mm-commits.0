Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29B3C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 21:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiHVV1h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 17:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiHVV1g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 17:27:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B12852458
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 14:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 348C160C8F
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 21:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8381DC433C1;
        Mon, 22 Aug 2022 21:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661203654;
        bh=WB5RVxKPqYGPyuLO+dUUzt7mmCH+7ElILZuP7GSekMU=;
        h=Date:To:From:Subject:From;
        b=pHVgfJoNGvKk2CZDpp4ouQWGgIJ32E4PUpZsfUEgyNmbN2MVpM4ZkKbsvAlfCC+ci
         WH+sfk+Z2sFbDPhc0q1dleXDrn+uM+Vly8yDxR2Uu96i3lOkPv6/a6f3LzToiBiCq9
         0NjrUBSsf31D0CYLtw9XT7WjbRfITQMZ0NIe/av8=
Date:   Mon, 22 Aug 2022 14:27:33 -0700
To:     mm-commits@vger.kernel.org, minhquangbui99@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-skip-retry-when-new-limit-is-not-below-old-one-in-page_counter_set_max.patch added to mm-unstable branch
Message-Id: <20220822212734.8381DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Skip retry when new limit is not below old one in page_counter_set_max
has been added to the -mm mm-unstable branch.  Its filename is
     mm-skip-retry-when-new-limit-is-not-below-old-one-in-page_counter_set_max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-skip-retry-when-new-limit-is-not-below-old-one-in-page_counter_set_max.patch

This patch will later appear in the mm-unstable branch at
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
From: Bui Quang Minh <minhquangbui99@gmail.com>
Subject: mm: Skip retry when new limit is not below old one in page_counter_set_max
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

mm-skip-retry-when-new-limit-is-not-below-old-one-in-page_counter_set_max.patch

