Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6362C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5117664DF8
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhBDA6m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:58:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234328AbhBDA6e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Feb 2021 19:58:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8656064F5C;
        Thu,  4 Feb 2021 00:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612400259;
        bh=FQWabb40CPbtrKrd9f/u5tDEhF4HT5RTBOSFeVf9Uok=;
        h=Date:From:To:Subject:From;
        b=YKA1rKT6eTKzhA11CrOoQL1oAFpT2Zmatg6FZ31YI5cdv9YaQXEbXHSxNXyyl/Ftd
         dOSVUTTl1QU8/h7pLW0qma0NtJ5grlYPCw4cgr9OQWRcAyPQdoXD09VV6pqH/Ef2OP
         I3smJOrGsNWztAFzuAFp8UBs2fm/k476ImZO6Gbo=
Date:   Wed, 03 Feb 2021 16:57:39 -0800
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, sfr@canb.auug.org.au
Subject:  [to-be-updated] mm-gup-do-not-migrate-zero-page-fix.patch
 removed from -mm tree
Message-ID: <20210204005739.NJUyOTAzW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-do-not-migrate-zero-page-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-do-not-migrate-zero-page-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm-gup-do-not-migrate-zero-page-fix

add is_pinnable_page() stub

Link: https://lkml.kernel.org/r/CA+CK2bBjC8=cRsL5VhWkcevPsqSXWhsANVjsFNMERLT8vWtiQw@mail.gmail.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/mm.h~mm-gup-do-not-migrate-zero-page-fix
+++ a/include/linux/mm.h
@@ -1121,12 +1121,19 @@ static inline bool is_zone_movable_page(
 	return page_zonenum(page) == ZONE_MOVABLE;
 }
 
+#ifdef CONFIG_MIGRATION
 /* MIGRATE_CMA and ZONE_MOVABLE do not allow pin pages */
 static inline bool is_pinnable_page(struct page *page)
 {
 	return !(is_zone_movable_page(page) || is_migrate_cma_page(page)) ||
 		is_zero_pfn(page_to_pfn(page));
 }
+#else
+static inline bool is_pinnable_page(struct page *page)
+{
+	return true;
+}
+#endif
 
 #ifdef CONFIG_DEV_PAGEMAP_OPS
 void free_devmap_managed_page(struct page *page);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-gup-migrate-pinned-pages-out-of-movable-zone.patch
memory-hotplugrst-add-a-note-about-zone_movable-and-page-pinning.patch
mm-gup-change-index-type-to-long-as-it-counts-pages.patch
mm-gup-longterm-pin-migration-cleanup.patch
selftests-vm-gup_test-fix-test-flag.patch
selftests-vm-gup_test-test-faulting-in-kernel-and-verify-pinnable-pages.patch

