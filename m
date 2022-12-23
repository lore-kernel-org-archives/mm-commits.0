Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BC4C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 23 Dec 2022 17:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiLWR7L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Dec 2022 12:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiLWR7K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Dec 2022 12:59:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEA713D12
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 09:59:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF8B3B80315
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 17:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F86C433D2;
        Fri, 23 Dec 2022 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671818346;
        bh=paXGwzLZocE6sYyFShWqdC8Kx1weo5g0028WmDq+Lqg=;
        h=Date:To:From:Subject:From;
        b=eFt6zJO/LLi22bxKm128Q0jVn/L67J3DpXwgdfl/89cCIRegJgDiHVKsrWW4agG/P
         u6dqX6cLl70cmEb5nSW4r1wNDikxXrTPPGtv/vdLkPy8CuD9J91UzKOAzGbAAxRQAL
         XdVTCpDXm4NH+vK8UZNYUlUvzul6vkrs+c5L0EoA=
Date:   Fri, 23 Dec 2022 09:59:05 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch added to mm-unstable branch
Message-Id: <20221223175906.84F86C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-convert-deactivate_page-to-folio_deactivate-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch

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
Subject: mm-swap-convert-deactivate_page-to-folio_deactivate-fix
Date: Fri Dec 23 09:52:24 AM PST 2022

fix left-over comments, per Yu Zhao

Cc: Yu Zhao <yuzhao@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page-writeback.c~mm-swap-convert-deactivate_page-to-folio_deactivate-fix
+++ a/mm/page-writeback.c
@@ -2846,11 +2846,11 @@ bool folio_mark_dirty(struct folio *foli
 
 	if (likely(mapping)) {
 		/*
-		 * readahead/lru_deactivate_page could remain
+		 * readahead/folio_deactivate could remain
 		 * PG_readahead/PG_reclaim due to race with folio_end_writeback
 		 * About readahead, if the folio is written, the flags would be
 		 * reset. So no problem.
-		 * About lru_deactivate_page, if the folio is redirtied,
+		 * About folio_deactivate, if the folio is redirtied,
 		 * the flag will be reset. So no problem. but if the
 		 * folio is used by readahead it will confuse readahead
 		 * and make it restart the size rampup process. But it's
--- a/mm/vmscan.c~mm-swap-convert-deactivate_page-to-folio_deactivate-fix
+++ a/mm/vmscan.c
@@ -1920,7 +1920,7 @@ retry:
 			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
 				/*
 				 * Immediately reclaim when written back.
-				 * Similar in principle to deactivate_page()
+				 * Similar in principle to folio_deactivate()
 				 * except we already have the folio isolated
 				 * and know it's dirty
 				 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch

