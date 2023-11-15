Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F38C5AE4A
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 23:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjKOXa4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 18:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbjKOXav (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 18:30:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A7218B;
        Wed, 15 Nov 2023 15:30:47 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DF2C433C9;
        Wed, 15 Nov 2023 23:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700091047;
        bh=frawxDI6pFC4U1i3NrbTABbYzQCmAnshlQ2wM5qQOBs=;
        h=Date:To:From:Subject:From;
        b=1/9fYDpVa9W+fgxzSOTxo6PzMr5nL5sPwswS9x+hjF+AVTIKBMl7vsmXCOqatiQZQ
         kz0p8gdGu5fvMa0Zdc0GtvJYRUotAJS+hJBjCvVbeLSW5bl6x4xP2wgEj7/Gvc9lRx
         df9IDvZx+aup5X8dUbFutx1Br0U36Kwa1UrvnxEI=
Date:   Wed, 15 Nov 2023 15:30:47 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, shy828301@gmail.com, riel@surriel.com,
        hannes@cmpxchg.org, david@redhat.com, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-for-negative-counter-nr_file_hugepages.patch removed from -mm tree
Message-Id: <20231115233047.B5DF2C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix for negative counter: nr_file_hugepages
has been removed from the -mm tree.  Its filename was
     mm-fix-for-negative-counter-nr_file_hugepages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: fix for negative counter: nr_file_hugepages
Date: Mon, 6 Nov 2023 10:19:18 -0800

While qualifiying the 6.4 release, the following warning was detected in
messages:

vmstat_refresh: nr_file_hugepages -15664

The warning is caused by the incorrect updating of the NR_FILE_THPS
counter in the function split_huge_page_to_list.  The if case is checking
for folio_test_swapbacked, but the else case is missing the check for
folio_test_pmd_mappable.  The other functions that manipulate the counter
like __filemap_add_folio and filemap_unaccount_folio have the
corresponding check.

I have a test case, which reproduces the problem. It can be found here:
  https://github.com/sroeschus/testcase/blob/main/vmstat_refresh/madv.c

The test case reproduces on an XFS filesystem. Running the same test
case on a BTRFS filesystem does not reproduce the problem.

AFAIK version 6.1 until 6.6 are affected by this problem.

[akpm@linux-foundation.org: whitespace fix]
[shr@devkernel.io: test for folio_test_pmd_mappable()]
  Link: https://lkml.kernel.org/r/20231108171517.2436103-1-shr@devkernel.io
Link: https://lkml.kernel.org/r/20231106181918.1091043-1-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Co-debugged-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-fix-for-negative-counter-nr_file_hugepages
+++ a/mm/huge_memory.c
@@ -2769,13 +2769,15 @@ int split_huge_page_to_list(struct page
 			int nr = folio_nr_pages(folio);
 
 			xas_split(&xas, folio, folio_order(folio));
-			if (folio_test_swapbacked(folio)) {
-				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS,
-							-nr);
-			} else {
-				__lruvec_stat_mod_folio(folio, NR_FILE_THPS,
-							-nr);
-				filemap_nr_thps_dec(mapping);
+			if (folio_test_pmd_mappable(folio)) {
+				if (folio_test_swapbacked(folio)) {
+					__lruvec_stat_mod_folio(folio,
+							NR_SHMEM_THPS, -nr);
+				} else {
+					__lruvec_stat_mod_folio(folio,
+							NR_FILE_THPS, -nr);
+					filemap_nr_thps_dec(mapping);
+				}
 			}
 		}
 
_

Patches currently in -mm which might be from shr@devkernel.io are


