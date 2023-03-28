Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81CFCC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjC1XWM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjC1XVx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE3B30F8
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 182C7B81F57
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF529C433EF;
        Tue, 28 Mar 2023 23:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045702;
        bh=2YP8xLAGC0nFFcgeLXsNi8QOm9BzYcnE1VEAerHrTsc=;
        h=Date:To:From:Subject:From;
        b=cjjQHhKZwSnv9ZCI98vGo868Xqww19ZNbADGzicTDIaR8qNSDhA3X7Epz655ovna7
         FMykIFI37INcZedp7GbRkvwGSrP3HIvuxZXq8RG0+AVCDMiOnCbJtdbF+O+aq5wTAX
         pIZptHVW7YVx9l2x85JZclREEd32WFO2z66kpDpE=
Date:   Tue, 28 Mar 2023 16:21:42 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, shuah@kernel.org,
        david@redhat.com, ziy@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-split-huge-page-tests.patch removed from -mm tree
Message-Id: <20230328232142.AF529C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix split huge page tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-split-huge-page-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: fix split huge page tests
Date: Mon, 6 Mar 2023 11:09:07 -0500

Fix two inputs to check_anon_huge() and one if condition, so the tests
work as expected.

Link: https://lkml.kernel.org/r/20230306160907.16804-1-zi.yan@sent.com
Fixes: c07c343cda8e ("selftests/vm: dedup THP helpers")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Tested-by: Zach O'Keefe <zokeefe@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-fix-split-huge-page-tests
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -106,7 +106,7 @@ void split_pmd_thp(void)
 	for (i = 0; i < len; i++)
 		one_page[i] = (char)i;
 
-	if (!check_huge_anon(one_page, 1, pmd_pagesize)) {
+	if (!check_huge_anon(one_page, 4, pmd_pagesize)) {
 		printf("No THP is allocated\n");
 		exit(EXIT_FAILURE);
 	}
@@ -122,7 +122,7 @@ void split_pmd_thp(void)
 		}
 
 
-	if (check_huge_anon(one_page, 0, pmd_pagesize)) {
+	if (!check_huge_anon(one_page, 0, pmd_pagesize)) {
 		printf("Still AnonHugePages not split\n");
 		exit(EXIT_FAILURE);
 	}
@@ -169,7 +169,7 @@ void split_pte_mapped_thp(void)
 	for (i = 0; i < len; i++)
 		one_page[i] = (char)i;
 
-	if (!check_huge_anon(one_page, 1, pmd_pagesize)) {
+	if (!check_huge_anon(one_page, 4, pmd_pagesize)) {
 		printf("No THP is allocated\n");
 		exit(EXIT_FAILURE);
 	}
_

Patches currently in -mm which might be from ziy@nvidia.com are


