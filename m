Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E39C61DA4
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 21:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjBWVts (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 16:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBWVtr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 16:49:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56A3F77B
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 13:49:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3A07617A7
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 21:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31FFC433EF;
        Thu, 23 Feb 2023 21:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677188985;
        bh=sKv9KdUoKOcBrl3QmHQ9zfWhquXAZZH1FKu3pqs3Sx0=;
        h=Date:To:From:Subject:From;
        b=DRxOQIk18jqh/TPSEOTnP/e2cnSG8MR6tmmfdpOSDTjsLwn22aUMsg8Uu1503rVQ9
         KUMhNtBahjHUsdKvDi5tOieVKO7nQjnPHRhxEwRH5pJ6LeWnRbhntRcXSbWvZAsKSW
         zCfvN7WV4CohEu5zKeHDJkhRmg1VInYckgquX2FM=
Date:   Thu, 23 Feb 2023 13:49:45 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20230223214945.C31FFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes
Date: Thu Feb 23 01:48:48 PM PST 2023

WARNING: braces {} are not necessary for single statement blocks
#152: FILE: mm/page_alloc.c:956:
+	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages) {
+		static_branch_enable(&check_pages_enabled);
+	}

total: 3 errors, 2 warnings, 307 lines checked

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -953,9 +953,8 @@ void __init init_mem_debugging_and_harde
 	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM it's
 	 * enabled already.
 	 */
-	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages) {
+	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages)
 		static_branch_enable(&check_pages_enabled);
-	}
 }
 
 static inline void set_buddy_order(struct page *page, unsigned int order)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch

