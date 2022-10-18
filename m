Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808F7C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 20:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJRUzy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiJRUzy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 16:55:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6717E03D
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 13:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CF3DB8210A
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 20:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34316C433D6;
        Tue, 18 Oct 2022 20:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666126550;
        bh=c55JbkeAEc5H3dKIe2/7aqQjCzuiC2/LN1q3J7yR1Gc=;
        h=Date:To:From:Subject:From;
        b=Rpr6LhLHIcDuT3LNYxHDxltLvPiyfOCINtvgrNJOq6e085WodTcLJEXVyBrzXDnYx
         chHZ1PaikuPz8WXyb5UCK9bXkm6KAjdOdzb3bZgamKXH+Wg2IArkhFV7vkZJDh5FHT
         fXzW3yMGF44g8gyN9FDLyytHlCuDeRTAtFyFQb84=
Date:   Tue, 18 Oct 2022 13:55:49 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        dan.j.williams@intel.com, nathan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-introduce-pgmap_request_folios-fix.patch added to mm-unstable branch
Message-Id: <20221018205550.34316C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap: mark folio_span_valid() as __maybe_unused
has been added to the -mm mm-unstable branch.  Its filename is
     fsdax-introduce-pgmap_request_folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-introduce-pgmap_request_folios-fix.patch

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
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memremap.c~fsdax-introduce-pgmap_request_folios-fix
+++ a/mm/memremap.c
@@ -530,8 +530,9 @@ void zone_device_page_init(struct page *
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

fsdax-introduce-pgmap_request_folios-fix.patch

