Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6E7EB64D9
	for <mm-commits@archiver.kernel.org>; Sat, 17 Jun 2023 05:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjFQFir (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Jun 2023 01:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjFQFiq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 17 Jun 2023 01:38:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA05D1704
        for <mm-commits@vger.kernel.org>; Fri, 16 Jun 2023 22:38:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4554B610A1
        for <mm-commits@vger.kernel.org>; Sat, 17 Jun 2023 05:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1B5C433C8;
        Sat, 17 Jun 2023 05:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686980324;
        bh=4IYC2ZfVsUe9lObmdsUFFaCps8K+QhLTVi7dRzI78uE=;
        h=Date:To:From:Subject:From;
        b=YRW90dxkVESqhX82mSX5bHELueySOvuFJHV9cpUBqUWTAuH/oD5Rg1758xX5AnQzU
         KY03FMRW3v1X30XHwNaIwcq5nHyQ/ompya7yR1eZewdfbDFqkSrVa2XGaOtB1bQWum
         ZUEdGScfRJBFhv6aXUeGCvMcp/E9ONFvTTP0c3nM=
Date:   Fri, 16 Jun 2023 22:38:43 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-compound_page_dtors-static.patch added to mm-unstable branch
Message-Id: <20230617053844.8A1B5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: make compound_page_dtors static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-make-compound_page_dtors-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-compound_page_dtors-static.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: page_alloc: make compound_page_dtors static
Date: Sat, 17 Jun 2023 11:46:22 +0800

It's only used inside page_alloc.c now. So make it static and remove the
declaration in mm.h.

Link: https://lkml.kernel.org/r/20230617034622.1235913-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/page_alloc.c    |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-page_alloc-make-compound_page_dtors-static
+++ a/include/linux/mm.h
@@ -1220,7 +1220,6 @@ enum compound_dtor_id {
 #endif
 	NR_COMPOUND_DTORS,
 };
-extern compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS];
 
 static inline void folio_set_compound_dtor(struct folio *folio,
 		enum compound_dtor_id compound_dtor)
--- a/mm/page_alloc.c~mm-page_alloc-make-compound_page_dtors-static
+++ a/mm/page_alloc.c
@@ -284,7 +284,7 @@ const char * const migratetype_names[MIG
 #endif
 };
 
-compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
+static compound_page_dtor * const compound_page_dtors[NR_COMPOUND_DTORS] = {
 	[NULL_COMPOUND_DTOR] = NULL,
 	[COMPOUND_PAGE_DTOR] = free_compound_page,
 #ifdef CONFIG_HUGETLB_PAGE
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-remove-obsolete-alloc_migrate_target.patch
mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch
memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration.patch
mm-compaction-mark-kcompactd_run-and-kcompactd_stop-__meminit.patch
memory-tier-remove-unneeded-is_enabledconfig_migration-check.patch
mm-page_alloc-make-compound_page_dtors-static.patch

