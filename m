Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC714EB64D8
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jun 2023 20:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjFNUFV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jun 2023 16:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjFNUFU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jun 2023 16:05:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D02B5
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 13:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 229B760AE1
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 20:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA13C433C0;
        Wed, 14 Jun 2023 20:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686773118;
        bh=zhJbOElmfnUwlJyjMXx22e9+Kdy5z/dObZkY89KNaGs=;
        h=Date:To:From:Subject:From;
        b=PHs2kVTPrA8pGlMPlHKqLvN071YOVKVV0raWpf28Ff1J3yermYSus1idcfXmBaU1D
         xVOw5/gOmTukPbRsjgsZlmC+7jVXAtDusUJJaxllQuKRmVE46/ieXoZNBAr20M1Ezh
         eeHPK5KOd878ryXlTmX+t2Y1bFg79s6MgBgUBaPo=
Date:   Wed, 14 Jun 2023 13:05:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmzone-introduce-folio_is_zone_movable.patch added to mm-unstable branch
Message-Id: <20230614200518.6AA13C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmzone: introduce folio_is_zone_movable()
has been added to the -mm mm-unstable branch.  Its filename is
     mmzone-introduce-folio_is_zone_movable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmzone-introduce-folio_is_zone_movable.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mmzone: introduce folio_is_zone_movable()
Date: Tue, 13 Jun 2023 19:13:08 -0700

Patch series "Replace is_longterm_pinnable_page()", v2.

This patchset introduces some more helper functions for the folio
conversions, and converts all callers of is_longterm_pinnable_page() to
use folios.


This patch (of 5):

Introduce folio_is_zone_movable() to act as a folio equivalent for
is_zone_movable_page().  This is to assist in later folio conversions.

Link: https://lkml.kernel.org/r/20230614021312.34085-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20230614021312.34085-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/mmzone.h~mmzone-introduce-folio_is_zone_movable
+++ a/include/linux/mmzone.h
@@ -1116,6 +1116,11 @@ static inline bool is_zone_movable_page(
 {
 	return page_zonenum(page) == ZONE_MOVABLE;
 }
+
+static inline bool folio_is_zone_movable(const struct folio *folio)
+{
+	return folio_zonenum(folio) == ZONE_MOVABLE;
+}
 #endif
 
 /*
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

afs-fix-dangling-folio-ref-counts-in-writeback.patch
afs-fix-waiting-for-writeback-then-skipping-folio.patch
mmzone-introduce-folio_is_zone_movable.patch
mmzone-introduce-folio_migratetype.patch
mm-gup_testc-convert-verify_dma_pinned-to-us-folios.patch
mm-gupc-reorganize-try_get_folio.patch
mm-remove-is_longterm_pinnable_page-and-reimplement-folio_is_longterm_pinnable.patch

