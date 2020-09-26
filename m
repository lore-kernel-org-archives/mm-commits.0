Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78B6C4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 04:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 939B32078B
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 04:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601093957;
	bh=9u43UOtPeXYOn2SAd52yJxsE9rs6wq54p1naXXmefTI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=V2MEcCzUsYB7A7wSNzfmKIfY6qR+3ii2aVN8X0cf6+m0rbVsDkFbJU7z8JVuIXtN6
	 q42XRjgnlQ3cfV37AnVvEue2CSXbeDXlnWzGnEzCI8gVr1z9T2eFXB2B6LlNvp1gFA
	 EsTfOFvJGUNdukRa+kAVawiLFdey0+8ss5aw5uc0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbgIZETR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 26 Sep 2020 00:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgIZETQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 26 Sep 2020 00:19:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 666E12080A;
        Sat, 26 Sep 2020 04:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601093955;
        bh=9u43UOtPeXYOn2SAd52yJxsE9rs6wq54p1naXXmefTI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=v3sh1qqiMSmEFOL/yDNG06CSyJqEShYwTy6vEW13fuZvAWNvqjQO04eNosEmTuEBM
         TaNCzJXzmirgMw2x0Vh/jY8cmEViyT1xO6gZ/GHbqGerZtP3D9NxW9q+vKv+bUIRNh
         +7FPzZJSFZK4W5ixn3IC4Yspu2IVzefmiJim80UY=
Date:   Fri, 25 Sep 2020 21:19:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        daniel.m.jordan@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        ziy@nvidia.com
Subject:  [patch 4/9] mm/migrate: correct thp migration stats
Message-ID: <20200926041914.Hj7iz37ld%akpm@linux-foundation.org>
In-Reply-To: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
