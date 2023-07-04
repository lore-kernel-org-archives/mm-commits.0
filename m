Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C98EB64D9
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 16:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbjGDQig (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 12:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbjGDQie (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 12:38:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1D010D7
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 09:38:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BA24612FD
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 16:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E486CC433C7;
        Tue,  4 Jul 2023 16:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688488711;
        bh=23pxuyomcELojFN9oUgFaiIc2D493PWgOtDsFP9w+QA=;
        h=Date:To:From:Subject:From;
        b=fnO6affWXKbNi5K8TmG3hpX7C2Zy3WOUTZwa6Ij8iGjRkws7yrvcuFYB5bwk00Rmo
         qG6Tg8C3Ab7PoL2xgb32ADEbDJBReKo7Ygvks9uFGzmCaXRIl0sZWO7Y6OxLtK40W8
         Llz39BGTqazcreGeTmhn/RG1ECQqFHfGMfDJCrUM=
Date:   Tue, 04 Jul 2023 09:38:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch added to mm-unstable branch
Message-Id: <20230704163830.E486CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-avoid-false-page-outside-zone-error-info-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch

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
Subject: mm-page_alloc-avoid-false-page-outside-zone-error-info-fix
Date: Tue Jul  4 09:35:46 AM PDT 2023

code simplification, per Matthew

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-false-page-outside-zone-error-info-fix
+++ a/mm/page_alloc.c
@@ -468,10 +468,7 @@ static int page_outside_zone_boundaries(
 		seq = zone_span_seqbegin(zone);
 		start_pfn = zone->zone_start_pfn;
 		sp = zone->spanned_pages;
-		if (!zone_spans_pfn(zone, pfn))
-			ret = 1;
-		else
-			ret = 0;
+		ret = !zone_spans_pfn(zone, pfn);
 	} while (zone_span_seqretry(zone, seq));
 
 	if (ret)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch

