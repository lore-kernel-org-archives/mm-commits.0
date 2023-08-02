Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A77C001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 19:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjHBTaY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 15:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjHBTaX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 15:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392D6123
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 12:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B318B61AB9
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 19:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06034C433C7;
        Wed,  2 Aug 2023 19:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691004621;
        bh=AC1xYK3X1GQRINRypz0yFVqCkewS8VpSqm5ByUSeVDs=;
        h=Date:To:From:Subject:From;
        b=Zs5e3RDMCPlnht6JHCO8p+eEt+fg++pGb7VGLzAcZKHQCc8rpxslbu2qpBzKfCRvZ
         /iFmToc9KTg0xClDsGQ1+CY4+6VLsJuF5nXTyGLGso+fKtsXOvgwybBHBd7XOtBGz5
         nmk7pclduPOK5aRFwEGO2pjhSR/SBvwNY/3FItio=
Date:   Wed, 02 Aug 2023 12:30:20 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        nathan@kernel.org, gerald.schaefer@linux.ibm.com,
        fengwei.yin@intel.com, david@redhat.com, agordeev@linux.ibm.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch removed from -mm tree
Message-Id: <20230802193021.06034C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: allow deferred splitting of arbitrary large anon folios
has been removed from the -mm tree.  Its filename was
     mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: allow deferred splitting of arbitrary large anon folios
Date: Thu, 27 Jul 2023 15:18:35 +0100

Patch series "Optimize large folio interaction with deferred split", v4.

A small series in support of my work to enable the use of large folios for
anonymous memory (known as "FLEXIBLE_THP" or "LARGE_ANON_FOLIO") [5].  It
first makes it possible to add large, non-pmd-mappable folios to the
deferred split queue.  Then it modifies zap_pte_range() to batch-remove
spans of physically contiguous pages from the rmap, which means that in
the common case, we elide the need to ever put the folio on the deferred
split queue, thus reducing lock contention and improving performance.

This becomes more visible once we have lots of large anonymous folios in
the system, and Huang Ying has suggested solving this needs to be a
prerequisit for merging the main FLEXIBLE_THP/LARGE_ANON_FOLIO work.


This patch (of 3):
In preparation for the introduction of large folios for anonymous memory,
we would like to be able to split them when they have unmapped subpages,
in order to free those unused pages under memory pressure.  So remove the
artificial requirement that the large folio needed to be at least
PMD-sized.

Link: https://lkml.kernel.org/r/20230727141837.3386072-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20230727141837.3386072-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-allow-deferred-splitting-of-arbitrary-large-anon-folios
+++ a/mm/rmap.c
@@ -1414,11 +1414,11 @@ void page_remove_rmap(struct page *page,
 		__lruvec_stat_mod_folio(folio, idx, -nr);
 
 		/*
-		 * Queue anon THP for deferred split if at least one
+		 * Queue anon large folio for deferred split if at least one
 		 * page of the folio is unmapped and at least one page
 		 * is still mapped.
 		 */
-		if (folio_test_pmd_mappable(folio) && folio_test_anon(folio))
+		if (folio_test_large(folio) && folio_test_anon(folio))
 			if (!compound || nr < nr_pmdmapped)
 				deferred_split_folio(folio);
 	}
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-line-buffer-test-programs-stdout.patch
selftests-line-buffer-test-programs-stdout-fix.patch
selftests-mm-skip-soft-dirty-tests-on-arm64.patch
selftests-mm-enable-mrelease_test-for-arm64.patch
selftests-mm-fix-thuge-gen-test-bugs.patch
selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch
selftests-mm-make-migration-test-robust-to-failure.patch
selftests-mm-optionally-pass-duration-to-transhuge-stress.patch
selftests-mm-run-all-tests-from-run_vmtestssh.patch
mm-implement-folio_remove_rmap_range.patch
mm-batch-zap-large-anonymous-folio-pte-mappings.patch

