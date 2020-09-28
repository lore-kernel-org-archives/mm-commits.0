Return-Path: <SRS0=DYKa=DF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CADC4741F
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 21:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1972021531
	for <mm-commits@archiver.kernel.org>; Mon, 28 Sep 2020 21:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601327684;
	bh=Gme2FatNJYo3lkEdVcR3XRN2CO41EpQwscs6tR6YgBA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RWZM89QtYGR66Al1Vx3EuZFP1ikd2MTBMh5H/ziNpehWngWzdmNiix9afPSwxSF5W
	 V7pZ1VJl3cW5eYrX2JTXf3ipf4Z5PYlSmwfX5PxXjc9BNE8ZYpKy1OOZ9RUO/djHWa
	 PD3g4EOBiHbTDqBw0agc4liLkoW/3yzkKNivjfbA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgI1VOn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbgI1VOn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 17:14:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2DBB2083B;
        Mon, 28 Sep 2020 21:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601327682;
        bh=Gme2FatNJYo3lkEdVcR3XRN2CO41EpQwscs6tR6YgBA=;
        h=Date:From:To:Subject:From;
        b=DMdFAtSEKIAU2PYLaPLmlbRGYDocpI77sRTAecB4wANZTBqo9/oOJVVQ39byxXGx4
         zPNOUAR2Jzc1rG9j+6ny0p4VFV4QdJ9lm3PZmwN/bl0qhzpwEvEco++irShj0HgoBI
         Lg9EWxAqi6jz/0DROlu+ANu4e063ELotSn5OAeJ8=
Date:   Mon, 28 Sep 2020 14:14:42 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, daniel.m.jordan@oracle.com,
        mm-commits@vger.kernel.org, ziy@nvidia.com
Subject:  [merged] mm-migrate-correct-thp-migration-stats.patch
 removed from -mm tree
Message-ID: <20200928211442.i8SVwx33f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: correct thp migration stats
has been removed from the -mm tree.  Its filename was
     mm-migrate-correct-thp-migration-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: correct thp migration stats

PageTransHuge returns true for both thp and hugetlb, so thp stats was
counting both thp and hugetlb migrations.  Exclude hugetlb migration by
setting is_thp variable right.

Clean up thp handling code too when we are there.

Link: https://lkml.kernel.org/r/20200917210413.1462975-1-zi.yan@sent.com
Fixes: 1a5bae25e3cf ("mm/vmstat: add events for THP migration without split")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-migrate-correct-thp-migration-stats
+++ a/mm/migrate.c
@@ -1446,7 +1446,7 @@ retry:
 			 * Capture required information that might get lost
 			 * during migration.
 			 */
-			is_thp = PageTransHuge(page);
+			is_thp = PageTransHuge(page) && !PageHuge(page);
 			nr_subpages = thp_nr_pages(page);
 			cond_resched();
 
@@ -1472,7 +1472,7 @@ retry:
 				 * we encounter them after the rest of the list
 				 * is processed.
 				 */
-				if (PageTransHuge(page) && !PageHuge(page)) {
+				if (is_thp) {
 					lock_page(page);
 					rc = split_huge_page_to_list(page, from);
 					unlock_page(page);
@@ -1481,8 +1481,7 @@ retry:
 						nr_thp_split++;
 						goto retry;
 					}
-				}
-				if (is_thp) {
+
 					nr_thp_failed++;
 					nr_failed += nr_subpages;
 					goto out;
_

Patches currently in -mm which might be from ziy@nvidia.com are


