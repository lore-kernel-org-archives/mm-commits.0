Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CBAC001DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjGXR1o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbjGXR1o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:27:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA8CE56
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3855611BD
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D2AC433C7;
        Mon, 24 Jul 2023 17:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690219657;
        bh=vuXQJd1JhLomHD2QfctG4m7vWI9B11VSpSpw/HzkTEY=;
        h=Date:To:From:Subject:From;
        b=hXsD/a5x/PldSPpmRD7YnsAY2Gc1DwgT0HcrJiOeSutTOlXhuKdbkIm0y5mHf/BdU
         n28Pi74PF9SiHW6SNTCK9mIxyGDw0hN2S0iAOEyJI75xskIVeSqleMVGbJYG2CLoRJ
         b97cPbDPi+qUBKtyHlV3pu8OkNPiH0sB/RGK4KnE=
Date:   Mon, 24 Jul 2023 10:27:36 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-avoid-unneeded-pageblock_end_pfn-when-no_set_skip_hint-is-set.patch added to mm-unstable branch
Message-Id: <20230724172737.52D2AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: avoid unneeded pageblock_end_pfn when no_set_skip_hint is set
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-avoid-unneeded-pageblock_end_pfn-when-no_set_skip_hint-is-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-avoid-unneeded-pageblock_end_pfn-when-no_set_skip_hint-is-set.patch

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
From: Kemeng Shi <shikemeng@huawei.com>
Subject: mm/compaction: avoid unneeded pageblock_end_pfn when no_set_skip_hint is set
Date: Fri, 21 Jul 2023 23:09:57 +0800

Move pageblock_end_pfn after no_set_skip_hint check to avoid unneeded
pageblock_end_pfn if no_set_skip_hint is set.

Link: https://lkml.kernel.org/r/20230721150957.2058634-3-shikemeng@huawei.com
Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-avoid-unneeded-pageblock_end_pfn-when-no_set_skip_hint-is-set
+++ a/mm/compaction.c
@@ -458,12 +458,12 @@ static void update_cached_migrate(struct
 {
 	struct zone *zone = cc->zone;
 
-	pfn = pageblock_end_pfn(pfn);
-
 	/* Set for isolation rather than compaction */
 	if (cc->no_set_skip_hint)
 		return;
 
+	pfn = pageblock_end_pfn(pfn);
+
 	if (pfn > zone->compact_cached_migrate_pfn[0])
 		zone->compact_cached_migrate_pfn[0] = pfn;
 	if (cc->mode != MIGRATE_ASYNC &&
_

Patches currently in -mm which might be from shikemeng@huawei.com are

mm-compaction-correct-comment-of-candidate-pfn-in-fast_isolate_freepages.patch
mm-compaction-avoid-unneeded-pageblock_end_pfn-when-no_set_skip_hint-is-set.patch

