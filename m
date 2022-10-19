Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5529EC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiJSXce (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiJSXc1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:32:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D091AC1F9
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C51A2B824C3
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B24C433D6;
        Wed, 19 Oct 2022 23:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666222327;
        bh=ZMpFeqB1puJ4K9raPslrwks03PLOh+HO18YsafzdLII=;
        h=Date:To:From:Subject:From;
        b=wtd9F0z1gxo79zYwFbEJqnIjpBY6Qv4HhB4TGo91obc8vjijbXvxHsBszi8YsZuwx
         2+9pZmgpJz7lj6L4MZVFRuUHCthsdyjAfigr+i5J/4ybNHbQhWRumFDbI8MV8pybr5
         JFstqKVbZ8/nvNuf+83uwTBD2og4WacLmeR8z8ok=
Date:   Wed, 19 Oct 2022 16:32:06 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        dan.j.williams@intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch added to mm-unstable branch
Message-Id: <20221019233207.66B24C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch

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
Subject: mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix
Date: Wed Oct 19 04:28:52 PM PDT 2022

restore removal of zone_device_page_init

Reported-by: kernel test robot <lkp@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/mm/memremap.c~mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix
+++ a/mm/memremap.c
@@ -518,18 +518,6 @@ void free_zone_device_page(struct page *
 		put_dev_pagemap(page->pgmap);
 }
 
-void zone_device_page_init(struct page *page)
-{
-	/*
-	 * Drivers shouldn't be allocating pages after calling
-	 * memunmap_pages().
-	 */
-	WARN_ON_ONCE(!percpu_ref_tryget_live(&page->pgmap->ref));
-	set_page_count(page, 1);
-	lock_page(page);
-}
-EXPORT_SYMBOL_GPL(zone_device_page_init);
-
 static __maybe_unused bool folio_span_valid(struct dev_pagemap *pgmap,
 					    struct folio *folio,
 					    int nr_folios)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mmapc-__vma_adjust-suppress-unintialized-var-warning.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

