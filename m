Return-Path: <SRS0=Ir1+=BV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB37C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 11 Aug 2020 22:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF75420756
	for <mm-commits@archiver.kernel.org>; Tue, 11 Aug 2020 22:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597184434;
	bh=6Kxb5syDjCzjbQksWCx6Z02FhvOcuxlcV/Jwo36NQJE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=CMGsL8qFORb5sGfc3xyvq3l1brEVaJ/DUKYiZszvDnY1y07Q2WD7hOdJ5b0xmYXKw
	 hRcaBccJU2JtODZYYOKh8s+1qyKH6zCBvMcUDSi+sQ9dLlO52RLX4+SL/fFJ5fiAhh
	 xwUq0ut44tDTMUpf1RfY6g9aCeFXzE+l/5D0zyZw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgHKWUe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 18:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbgHKWUe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 18:20:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9923E206DC;
        Tue, 11 Aug 2020 22:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597184433;
        bh=6Kxb5syDjCzjbQksWCx6Z02FhvOcuxlcV/Jwo36NQJE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RJTpwuFTubaHem+wC2KG55Dr9faTU3s1W/SWCtXy7r2Ia93MfCU+49zPRYr500RKG
         2H9W5NOogWz7UXU9E69yyENFwyA5ROTBdndf8atbtueHPN0zKmswZQWaPosFmPk75u
         C6I13ZpGXHGDa9yALEbBSq7qDuwxaTf3NsHdexXM=
Date:   Tue, 11 Aug 2020 15:20:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        ziy@nvidia.com
Subject:  +
 mm-vmstat-add-events-for-thp-migration-without-split-v4.patch added to -mm
 tree
Message-ID: <20200811222033.dklJlrZ29%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-add-events-for-thp-migration-without-split-v4
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-events-for-thp-migration-without-split-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-events-for-thp-migration-without-split-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-events-for-thp-migration-without-split-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm-vmstat-add-events-for-thp-migration-without-split-v4

s/thp_nr_pages/hpage_nr_pages/

Link: http://lkml.kernel.org/r/1594287583-16568-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-vmstat-add-events-for-thp-migration-without-split-v4
+++ a/mm/migrate.c
@@ -1446,7 +1446,7 @@ retry:
 			 * during migration.
 			 */
 			is_thp = PageTransHuge(page);
-			nr_subpages = thp_nr_pages(page);
+			nr_subpages = hpage_nr_pages(page);
 			cond_resched();
 
 			if (PageHuge(page))
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-vmstat-add-events-for-thp-migration-without-split.patch
mm-vmstat-add-events-for-thp-migration-without-split-v4.patch

