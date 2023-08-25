Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFCAC3DA66
	for <mm-commits@archiver.kernel.org>; Fri, 25 Aug 2023 17:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbjHYRpu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Aug 2023 13:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbjHYRp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2023 13:45:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389412128
        for <mm-commits@vger.kernel.org>; Fri, 25 Aug 2023 10:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5E9561B98
        for <mm-commits@vger.kernel.org>; Fri, 25 Aug 2023 17:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFD6C433C8;
        Fri, 25 Aug 2023 17:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692985524;
        bh=TSP59X9TqwAcN4WMwflPqPenfpojs0omGUFcbkazlx4=;
        h=Date:To:From:Subject:From;
        b=rJX7AJh1+D4yFhCMPRO2XekgHEeDUXhOf+hZWSjY4OXfdNaG213pGBRut6N2OG8XL
         AojeygeyO5bNjz0TXWUKUm5WVTk20neRUC+hO4bghR3kOIdc+9FVV01mKBjrQ0AsZ5
         rsbLZ0KS/RIZQX6Q8uglThbB/GD8e+ohBZXrM2bY=
Date:   Fri, 25 Aug 2023 10:45:23 -0700
To:     mm-commits@vger.kernel.org, xieyisheng1@huawei.com,
        catalin.marinas@arm.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-move-up-cond_resched-call-in-page-scanning-loop.patch added to mm-unstable branch
Message-Id: <20230825174524.1FFD6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: move up cond_resched() call in page scanning loop
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-move-up-cond_resched-call-in-page-scanning-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-move-up-cond_resched-call-in-page-scanning-loop.patch

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
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: move up cond_resched() call in page scanning loop
Date: Fri, 25 Aug 2023 12:49:47 -0400

Commit bde5f6bc68db ("kmemleak: add scheduling point to kmemleak_scan()")
added a cond_resched() call to the struct page scanning loop to prevent
soft lockup from happening.  However, soft lockup can still happen in that
loop in some corner cases when the pages that satisfy the "!(pfn & 63)"
check are skipped for some reasons.

Fix this corner case by moving up the cond_resched() check so that it will
be called every 64 pages unconditionally.

Link: https://lkml.kernel.org/r/20230825164947.1317981-1-longman@redhat.com
Fixes: bde5f6bc68db ("kmemleak: add scheduling point to kmemleak_scan()")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-move-up-cond_resched-call-in-page-scanning-loop
+++ a/mm/kmemleak.c
@@ -1584,6 +1584,9 @@ static void kmemleak_scan(void)
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 			struct page *page = pfn_to_online_page(pfn);
 
+			if (!(pfn & 63))
+				cond_resched();
+
 			if (!page)
 				continue;
 
@@ -1594,8 +1597,6 @@ static void kmemleak_scan(void)
 			if (page_count(page) == 0)
 				continue;
 			scan_block(page, page + 1, NULL);
-			if (!(pfn & 63))
-				cond_resched();
 		}
 	}
 	put_online_mems();
_

Patches currently in -mm which might be from longman@redhat.com are

mm-kmemleak-move-up-cond_resched-call-in-page-scanning-loop.patch

