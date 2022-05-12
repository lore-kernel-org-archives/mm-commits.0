Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B356FC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 20:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358423AbiELUpO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 16:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358432AbiELUpN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 16:45:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0581A2300DC
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 13:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E47C6CE2C9C
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 20:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423D0C3411F;
        Thu, 12 May 2022 20:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652388306;
        bh=iPY0oGWhzyHYb9lhozTakMvFamT5AENlaEYtT4EuhcU=;
        h=Date:To:From:Subject:From;
        b=CYU6ub+Av+zqqJRnXWvQ67wM5HibaVPaglkHKqQpH9SPSq2+sdfUztWt3QhDIBYUC
         aoETN4cZZ+p097FH36MwtXU+4VVwBx33Ks07SURvnMzh8xyiX9vpjpHtBgYq6kPIye
         Oc3JMSnxRzqD/yUAXH+eWXhE/7nFedxXHXaec2Vc=
Date:   Thu, 12 May 2022 13:45:05 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org,
        jhubbard@nvidia.com, david@redhat.com, minchan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-is_pinnable_page-against-on-cma-page-v5.patch added to mm-unstable branch
Message-Id: <20220512204506.423D0C3411F@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-is_pinnable_page-against-on-cma-page-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-is_pinnable_page-against-on-cma-page-v5.patch

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
From: Minchan Kim <minchan@kernel.org>
Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5

  * clarification why we need READ_ONCE - Paul
  * Add a comment about READ_ONCE - John

Link: https://lkml.kernel.org/r/20220512204143.3961150-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-on-cma-page-v5
+++ a/include/linux/mm.h
@@ -1627,13 +1627,14 @@ static inline bool is_pinnable_page(stru
 {
 #ifdef CONFIG_CMA
 	/*
-	 * use volatile to use local variable mt instead of
-	 * refetching mt value.
+	 * Defend against future compiler LTO features, or code refactoring
+	 * that inlines the above function, by forcing a single read. Because,
+	 * this routine races with set_pageblock_migratetype(), and we want to
+	 * avoid reading zero, when actually one or the other flags was set.
 	 */
-	int __mt = get_pageblock_migratetype(page);
 	int mt = __READ_ONCE(__mt);
 
-	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
+	if (mt & (MIGRATE_CMA | MIGRATE_ISOLATE))
 		return false;
 #endif
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-fix-is_pinnable_page-against-on-cma-page.patch
mm-fix-is_pinnable_page-against-on-cma-page-v5.patch
mm-dont-be-stuck-to-rmap-lock-on-reclaim-path.patch

