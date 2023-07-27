Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091DAC04A94
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 15:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjG0Pcx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 11:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjG0Pcw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 11:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BB81BD5
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 08:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5034161EC0
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 15:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6B5C433C9;
        Thu, 27 Jul 2023 15:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690471970;
        bh=8nJ9VwqrHsvDC7Wfp2yVaW/mAX7qLiWS0JjDB5MXrHk=;
        h=Date:To:From:Subject:From;
        b=HyNyzqQ7HRPz4CUydYKypbs43fNPeX6Qkj+HOet7T0ZSyhgzBmD6NAwzDjUdIfNrd
         IaSg3cYfgBaUNDoMI3An639aieDbkoLn9rdL5SAfxgBaq2LH9yEckOcrn420TQsayr
         mHUkHsJGdxPgDSFloAkyACd/5z7i3y8uSp3mLxtg=
Date:   Thu, 27 Jul 2023 08:32:47 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        fengwei.yin@intel.com, david@redhat.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch removed from -mm tree
Message-Id: <20230727153250.9B6B5C433C9@smtp.kernel.org>
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
Date: Thu, 20 Jul 2023 12:29:53 +0100

Patch series "Optimize large folio interaction with deferred split" v3.

A small series in support of my work to enable the use of large folios for
anonymous memory (known as "FLEXIBLE_THP" or "LARGE_ANON_FOLIO") [1].  It
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

Link: https://lkml.kernel.org/r/20230720112955.643283-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20230720112955.643283-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Huang, Ying <ying.huang@intel.com>
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

mm-implement-folio_remove_rmap_range.patch
mm-batch-zap-large-anonymous-folio-pte-mappings.patch
selftests-line-buffer-test-programs-stdout.patch
selftests-line-buffer-test-programs-stdout-fix.patch
selftests-mm-skip-soft-dirty-tests-on-arm64.patch
selftests-mm-enable-mrelease_test-for-arm64.patch
selftests-mm-fix-thuge-gen-test-bugs.patch
selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch
selftests-mm-make-migration-test-robust-to-failure.patch
selftests-mm-optionally-pass-duration-to-transhuge-stress.patch
selftests-mm-run-all-tests-from-run_vmtestssh.patch

