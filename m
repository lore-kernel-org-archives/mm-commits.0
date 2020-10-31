Return-Path: <SRS0=UFsa=EG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0955C388F9
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AF0E206ED
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 19:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604173401;
	bh=muKbBVAdI8Xw6nX/uIeV3DZbn7MqHMHjed38SCiCwUk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=h+QLWNuMVOcE2jvd6IjaYFU9k5Te0IuDOdLDMT8dmmBBFKFLtWai4JfMEMimxfYAJ
	 R30H5+PPyYyWu0mNTnIp175vtB4lUPkhEa7CgGOdz3gwUlZgUfMwI+Grvk9zHeFNF0
	 1LkJou/iUr4VayMwnwANOLYLmE9mE7y9P/CHy2ZY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgJaTnV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 31 Oct 2020 15:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgJaTnU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 31 Oct 2020 15:43:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9BBD206E3;
        Sat, 31 Oct 2020 19:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604173400;
        bh=muKbBVAdI8Xw6nX/uIeV3DZbn7MqHMHjed38SCiCwUk=;
        h=Date:From:To:Subject:From;
        b=CN2ST0rleFEg9KLNIvUHH1+31tQsQ8MYv4X/ZpnR5Q3NI5kimikBFl6ff+2v/pIzd
         KjervMv2A+h2F6U+EKNOvPVci/KYkaokAhGQVq9bXJx9d5rbdfWyyEGvDyMnAFxQZs
         uGnwziWLeg3JVX8GHNkFF4S/Fz0Z9cp1tMKaTbRs=
Date:   Sat, 31 Oct 2020 12:43:19 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, riel@surriel.com, shy828301@gmail.com,
        vbabka@suse.cz, ziy@nvidia.com
Subject:  +
 mm-compaction-count-pages-and-stop-correctly-during-page-isolation-v3.patch
 added to -mm tree
Message-ID: <20201031194319.I3Oaop43q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-count-pages-and-stop-correctly-during-page-isol=
ation-v3
has been added to the -mm tree.  Its filename is
     mm-compaction-count-pages-and-stop-correctly-during-page-isolation-v3.=
patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-count-pages-and=
-stop-correctly-during-page-isolation-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-count-pages-and=
-stop-correctly-during-page-isolation-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Zi Yan <ziy@nvidia.com>
Subject: mm-compaction-count-pages-and-stop-correctly-during-page-isolation=
-v3

Link: https://lkml.kernel.org/r/20201030183809.3616803-1-zi.yan@sent.com
Fixes: 1da2f328fa64 (=E2=80=9Cmm,thp,compaction,cma: allow THP migration fo=
r CMA allocations=E2=80=9D)
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-count-pages-and-stop-correctly-during-p=
age-isolation-v3
+++ a/mm/compaction.c
@@ -1012,8 +1012,8 @@ isolate_migratepages_block(struct compac
=20
 isolate_success:
 		list_add(&page->lru, &cc->migratepages);
-		cc->nr_migratepages +=3D thp_nr_pages(page);
-		nr_isolated +=3D thp_nr_pages(page);
+		cc->nr_migratepages +=3D compound_nr(page);
+		nr_isolated +=3D compound_nr(page);
=20
 		/*
 		 * Avoid isolating too much unless this block is being
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-compaction-count-pages-and-stop-correctly-during-page-isolation.patch
mm-compaction-count-pages-and-stop-correctly-during-page-isolation-v3.patch
mm-compaction-stop-isolation-if-too-many-pages-are-isolated-and-we-have-pag=
es-to-migrate.patch

