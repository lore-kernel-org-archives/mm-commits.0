Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA35EC54EBD
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 01:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjAJBD5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjAJBD4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 20:03:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF41F3FCB1
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 17:03:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BBA6614B0
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 01:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D856C433D2;
        Tue, 10 Jan 2023 01:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673312634;
        bh=ns18sj9r4qQcU/REqA1vkMXgq/Jy+bYjJbySbbn/ZdI=;
        h=Date:To:From:Subject:From;
        b=2qQ2vOKtImfpV7/ed2GR9ePn0sFtYh+rB79psOWiuhuQAEovN2NgkE/O6QlteoJWL
         TSIlC7oyK1AwL2FOV/6tegJpOM6KSZ0tDtGBu4HVWxL4Hhk6tFFKLjMOUlVR78POz+
         ng73G9EXhkaAVRIiaLVgJUjHvpUK7akNkgb3ctT0=
Date:   Mon, 09 Jan 2023 17:03:53 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        xhao@linux.alibaba.com, willy@infradead.org, shy828301@gmail.com,
        osalvador@suse.de, nathan@kernel.org, mgorman@techsingularity.net,
        bharata@amd.com, baolin.wang@linux.alibaba.com, apopple@nvidia.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-split-unmap_and_move-to-_unmap-and-_move-fix.patch added to mm-unstable branch
Message-Id: <20230110010354.5D856C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages-split-unmap_and_move-to-_unmap-and-_move-fix
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-split-unmap_and_move-to-_unmap-and-_move-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-split-unmap_and_move-to-_unmap-and-_move-fix.patch

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
Subject: migrate_pages-split-unmap_and_move-to-_unmap-and-_move-fix
Date: Mon Jan  9 05:00:53 PM PST 2023

use void* cast on page->mapping, per Kees

Reported-by: Nathan Chancellor <nathan@kernel.org>
  Link: https://lkml.kernel.org/r/87pmbo7g9y.fsf@yhuang6-desk2.ccr.corp.intel.com
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: haoxin <xhao@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~migrate_pages-split-unmap_and_move-to-_unmap-and-_move-fix
+++ a/mm/migrate.c
@@ -1038,7 +1038,7 @@ static void __migrate_folio_extract(stru
 				   int *page_was_mappedp,
 				   struct anon_vma **anon_vmap)
 {
-	*anon_vmap = (struct anon_vma *)dst->mapping;
+	*anon_vmap = (void *)dst->mapping;
 	*page_was_mappedp = (unsigned long)dst->private;
 	dst->mapping = NULL;
 	dst->private = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
migrate_pages-split-unmap_and_move-to-_unmap-and-_move-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mmap-convert-__vma_adjust-to-use-vma-iterator-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch

