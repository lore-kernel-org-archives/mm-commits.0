Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3977C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 23:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiLAXN0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 18:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiLAXNV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 18:13:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F52F17
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 15:13:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FACDB82042
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 23:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A2FC433C1;
        Thu,  1 Dec 2022 23:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669936397;
        bh=L/J6GAp21pFet834WWC8L2EE8dn/D5GIUlD01EQhvhY=;
        h=Date:To:From:Subject:From;
        b=jv067P5a1C4pnaNWKtRdOGk3/FRAbnyap9pikR9ruzVQFbHEEZsVndIciBg54J37/
         gTrloMJRWgR/uEf/YnH/yi6IAXclB+AATUmSXhNtqUXQ85heE6zny+GVVOBdUfTgGw
         fWRxH5jlGhQsIIMNmiF5BvxmZo+WkoAtZ3g405l0=
Date:   Thu, 01 Dec 2022 15:13:17 -0800
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        dan.j.williams@intel.com, nathan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fsdax-introduce-pgmap_request_folios-fix.patch removed from -mm tree
Message-Id: <20221201231317.D9A2FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memremap: mark folio_span_valid() as __maybe_unused
has been removed from the -mm tree.  Its filename was
     fsdax-introduce-pgmap_request_folios-fix.patch

This patch was dropped because it was folded into fsdax-introduce-pgmap_request_folios.patch

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: mm/memremap: mark folio_span_valid() as __maybe_unused
Date: Tue, 18 Oct 2022 08:26:46 -0700

When building without CONFIG_DEBUG_VM, clang warns:

  mm/memremap.c:495:13: error: function 'folio_span_valid' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
  static bool folio_span_valid(struct dev_pagemap *pgmap, struct folio *folio,
              ^
  1 error generated.

folio_span_valid() is only used within a instance of VM_WARN_ON_ONCE(),
which evaluates to BUILD_BUG_ON_INVALID() with CONFIG_DEBUG_VM=n, which
ultimately resolves to sizeof(), which is fully resolved at compile
time. Basically, the warning is flagging that folio_span_valid() is
only used in a compile time context and will not be called at run time.

Since this is expected given the configuration, mark folio_span_valid()
as __maybe_unused so that there is no warning.

Link: https://lkml.kernel.org/r/20221018152645.3195108-1-nathan@kernel.org
Fixes: ("fsdax: introduce pgmap_request_folios()")
  Link: https://github.com/ClangBuiltLinux/linux/issues/1739
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memremap.c~fsdax-introduce-pgmap_request_folios-fix
+++ a/mm/memremap.c
@@ -531,8 +531,9 @@ void zone_device_page_init(struct page *
 }
 EXPORT_SYMBOL_GPL(zone_device_page_init);
 
-static bool folio_span_valid(struct dev_pagemap *pgmap, struct folio *folio,
-			     int nr_folios)
+static __maybe_unused bool folio_span_valid(struct dev_pagemap *pgmap,
+					    struct folio *folio,
+					    int nr_folios)
 {
 	unsigned long pfn_start, pfn_end;
 
_

Patches currently in -mm which might be from nathan@kernel.org are

fsdax-introduce-pgmap_request_folios.patch

