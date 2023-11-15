Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9A4C2BB3F
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 23:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjKOX2D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 18:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjKOX2C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 18:28:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CBE18B
        for <mm-commits@vger.kernel.org>; Wed, 15 Nov 2023 15:27:59 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3705C433C8;
        Wed, 15 Nov 2023 23:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700090878;
        bh=YNXBgitmn8D2V/Lk2ImpbLSlFFU62B7Uj9tVzp3HKco=;
        h=Date:To:From:Subject:From;
        b=2h4n/jevYSljW84z+teUTpzIOSJxqOWNs3kRuOImWZtcmyg34iaLn3Ud3w5PqPPgf
         WnJPgKsi2uQJAaEi42COmy0m/XOSY6I1QC5mFfHDa0lUz26aAuW5H0yoTUrIGYQWaM
         x6yxRfigKux1J8S47YGv/Q2p5sN3UYcAV+fR/Y3s=
Date:   Wed, 15 Nov 2023 15:27:58 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, shr@devkernel.io,
        riel@surriel.com, hannes@cmpxchg.org, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-for-negative-counter-nr_file_hugepages-fix.patch removed from -mm tree
Message-Id: <20231115232758.D3705C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-for-negative-counter-nr_file_hugepages-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-for-negative-counter-nr_file_hugepages-fix.patch

This patch was dropped because it was folded into mm-fix-for-negative-counter-nr_file_hugepages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-for-negative-counter-nr_file_hugepages-fix
Date: Mon Nov  6 11:44:47 AM PST 2023

whitespace fix

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/huge_memory.c~mm-fix-for-negative-counter-nr_file_hugepages-fix
+++ a/mm/huge_memory.c
@@ -2773,7 +2773,6 @@ int split_huge_page_to_list(struct page
 				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
 							-nr);
 			} else if (folio_test_pmd_mappable(folio)) {
-
 				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
 							-nr);
 				filemap_nr_thps_dec(mapping);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-for-negative-counter-nr_file_hugepages.patch
maintainers-add-andrew-morton-for-lib.patch
mm-memoryc-zap_pte_range-print-bad-swap-entry.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

