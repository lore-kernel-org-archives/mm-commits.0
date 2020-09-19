Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC6FC43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F8A821707
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600484960;
	bh=6xlATqJz5JZ8aCiaNxSGu7J/HysysTS6ZF6hHdK3kxk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Od+iLf2fcnfC3GRD7vx95JGnD2w4Uy8tQcxBqhZ1nMj9LPD8mv5CsgEiHKZP4A91Q
	 9HNOtbffN593+9Pz0c42YrLweQA9ISBAygf6b4yqN1/1U8BTSUdNZiVz6cchUmrVHQ
	 HnhpgEKb0mRBPw69Vthzxa4HCXI97kqD9P9S+PuU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgISDJU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISDJT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 23:09:19 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1894521534;
        Sat, 19 Sep 2020 03:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600484959;
        bh=6xlATqJz5JZ8aCiaNxSGu7J/HysysTS6ZF6hHdK3kxk=;
        h=Date:From:To:Subject:From;
        b=YdBBOQyQHMXxfZrYrwL0S6Ff/K6n50kMes7xgQ5Bb0SvAsGSitpnmR1MhtWfvhJGm
         p5AOgbywwhgD8qY3bv+D5si7t2FFbWhZ8rJIbD9r2tgBDOsjBMtCk9TcL+PTqCVmWJ
         6/dSQsFUoxrmYlZ1XiHgqgpokRiONyWiTFd1u9ew=
Date:   Fri, 18 Sep 2020 20:09:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, daniel.m.jordan@oracle.com,
        anshuman.khandual@arm.com, ziy@nvidia.com
Subject:  + mm-migrate-correct-thp-migration-stats.patch added to -mm
 tree
Message-ID: <20200919030918.i_AM3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: correct thp migration stats.
has been added to the -mm tree.  Its filename is
     mm-migrate-correct-thp-migration-stats.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-correct-thp-migration-stats.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-correct-thp-migration-stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: correct thp migration stats.

PageTransHuge returns true for both thp and hugetlb, so thp stats was
counting both thp and hugetlb migrations.  Exclude hugetlb migration by
setting is_thp variable right.

Clean up thp handling code too when we are there.

Link: https://lkml.kernel.org/r/20200917210413.1462975-1-zi.yan@sent.com
Fixes: 1a5bae25e3cf ("mm/vmstat: add events for THP migration without split")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
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

mm-migrate-correct-thp-migration-stats.patch

