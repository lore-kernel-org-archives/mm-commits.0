Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8CAC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 23:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359342AbiELXDB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 19:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359340AbiELXDB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 19:03:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EB4AFAD5
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 16:03:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3243262002
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 23:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C222C385B8;
        Thu, 12 May 2022 23:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652396579;
        bh=PI1YEDtmkJ6/iO8WQ4JZf+aTbpjQjkTpEbydlvE9+f8=;
        h=Date:To:From:Subject:From;
        b=B3AkqsBsFPByBZsb5aN0IhRZU0NMW6B7umb7NnyWQUEV5Y1ZKvyw/srojmD38CL/c
         jSmRVkVZNPi24ptMsbhZI6LDbeoAltdZhCfx9nscFrernkMLfI6FirCUiuLMweNA6F
         ynB8MUejSCKIgxqEPqTj75QTB5+krU0SQZPya9/0=
Date:   Thu, 12 May 2022 16:02:58 -0700
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com,
        minchan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-is_pinnable_page-against-on-cma-page-v5-fix.patch added to mm-unstable branch
Message-Id: <20220512230259.7C222C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-is_pinnable_page-against-on-cma-page-v5-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-is_pinnable_page-against-on-cma-page-v5-fix.patch

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
Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5-fix

fat finger

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-on-cma-page-v5-fix
+++ a/include/linux/mm.h
@@ -1632,6 +1632,7 @@ static inline bool is_pinnable_page(stru
 	 * this routine races with set_pageblock_migratetype(), and we want to
 	 * avoid reading zero, when actually one or the other flags was set.
 	 */
+	int __mt = get_pageblock_migratetype(page);
 	int mt = __READ_ONCE(__mt);
 
 	if (mt & (MIGRATE_CMA | MIGRATE_ISOLATE))
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-fix-is_pinnable_page-against-on-cma-page.patch
mm-fix-is_pinnable_page-against-on-cma-page-v5.patch
mm-fix-is_pinnable_page-against-on-cma-page-v5-fix.patch
mm-dont-be-stuck-to-rmap-lock-on-reclaim-path.patch

