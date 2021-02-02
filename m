Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCF5C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 144E864E08
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239881AbhBBTfy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:35:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239748AbhBBTfT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Feb 2021 14:35:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C173564F4D;
        Tue,  2 Feb 2021 19:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612294479;
        bh=ojgNWm5ym5VYRJGdcBeivMuTi6wSi7TU3BSXqywhnQs=;
        h=Date:From:To:Subject:From;
        b=VSDX/PCVbG64YHPWpScUp2JmETbxMU4F9xOz/1rahqsB70EivU+gjnh8uQLH5ymOl
         DR/6Drg6zD6ROKZ+Ri+3cWTyHjo/IlCwT2Qtn5OP5u7TFgwrDOumYK6s1t/iu6GpRK
         yUIKJduVzexX4EFDsxWjjSDt9wccLlurqeVw3gyE=
Date:   Tue, 02 Feb 2021 11:34:38 -0800
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, sfr@canb.auug.org.au
Subject:  + mm-gup-do-not-migrate-zero-page-fix.patch added to -mm
 tree
Message-ID: <20210202193438.M1pjE6lYJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-do-not-migrate-zero-page-fix
has been added to the -mm tree.  Its filename is
     mm-gup-do-not-migrate-zero-page-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-do-not-migrate-zero-page-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-do-not-migrate-zero-page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-gup-dont-pin-migrated-cma-pages-in-movable-zone.patch
mm-gup-check-every-subpage-of-a-compound-page-during-isolation.patch
mm-gup-return-an-error-on-migration-failure.patch
mm-gup-check-for-isolation-errors.patch
mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin.patch
mm-apply-per-task-gfp-constraints-in-fast-path.patch
mm-honor-pf_memalloc_pin-for-all-movable-pages.patch
mm-gup-do-not-migrate-zero-page.patch
mm-gup-do-not-migrate-zero-page-fix.patch
mm-gup-migrate-pinned-pages-out-of-movable-zone.patch
memory-hotplugrst-add-a-note-about-zone_movable-and-page-pinning.patch
mm-gup-change-index-type-to-long-as-it-counts-pages.patch
mm-gup-longterm-pin-migration-cleanup.patch
selftests-vm-gup_test-fix-test-flag.patch
selftests-vm-gup_test-test-faulting-in-kernel-and-verify-pinnable-pages.patch

