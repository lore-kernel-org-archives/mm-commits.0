Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55275C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 20:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiFKUCH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 16:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiFKUCH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 16:02:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B075047E
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 13:02:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0649FB80B39
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 20:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8999DC34116;
        Sat, 11 Jun 2022 20:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654977723;
        bh=5wxth7JZAPYW8EQc50xfe4ZjkOzGhBm2IFwEmHxE610=;
        h=Date:To:From:Subject:From;
        b=2pnXQPw4/wTCdTDtFg5Wy1UipUCki03pqULTzYpWL13zBH5baaOjAj56Kp6+d+J07
         1StlWlOT4pL+ue872xc9uyTXP3OltQx/cKZhm9gFo5rZojYS57EWTheMU3OWxISrY+
         UbRS9Dxd533SsvYJ8rpSPuIkaddJAUnnzCb9KiEE=
Date:   Sat, 11 Jun 2022 13:02:02 -0700
To:     mm-commits@vger.kernel.org, zhangfei.gao@linaro.org,
        willy@infradead.org, paulmck@kernel.org, minchan@kernel.org,
        joaodias@google.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        david@redhat.com, alex.williamson@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-re-allow-pinning-of-zero-pfns.patch added to mm-hotfixes-unstable branch
Message-Id: <20220611200203.8999DC34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: re-allow pinning of zero pfns
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-re-allow-pinning-of-zero-pfns.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-re-allow-pinning-of-zero-pfns.patch

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
From: Alex Williamson <alex.williamson@redhat.com>
Subject: mm: re-allow pinning of zero pfns
Date: Fri, 10 Jun 2022 16:35:13 -0600

The commit referenced below subtly and inadvertently changed the logic to
disallow pinning of zero pfns.  This breaks device assignment with vfio
and potentially various other users of gup.  Exclude the zero page test
from the negation.

Link: https://lkml.kernel.org/r/165490039431.944052.12458624139225785964.stgit@omen
Fixes: 1c563432588d ("mm: fix is_pinnable_page against a cma page")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: John Dias <joaodias@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-re-allow-pinning-of-zero-pfns
+++ a/include/linux/mm.h
@@ -1600,7 +1600,7 @@ static inline bool is_pinnable_page(stru
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
 		return false;
 #endif
-	return !(is_zone_movable_page(page) || is_zero_pfn(page_to_pfn(page)));
+	return !is_zone_movable_page(page) || is_zero_pfn(page_to_pfn(page));
 }
 #else
 static inline bool is_pinnable_page(struct page *page)
_

Patches currently in -mm which might be from alex.williamson@redhat.com are

mm-re-allow-pinning-of-zero-pfns.patch

