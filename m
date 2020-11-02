Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96946C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4881E21D91
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604278952;
	bh=Hnt63VLJGdry7jyNhcB54dUyy41zGJcBIexQev/YCac=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TO8qtrSOpF2NOAWNbo82Y6Q7Kx6Npm2cU5DAhGbEUqBeWGVxz5OxhTW/KdLkAVYDC
	 kekP23Q9Nrx4qVaDVJRli9e5GhUDruBtIdWi+xn/4gGjltSCxfuawbsMXIkA6xjZRQ
	 bMUFenuzSboK0qKzD/PnUbCi0tEe9LRfZiiYkawM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgKBBCc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:02:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBCb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:02:31 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E1D721707;
        Mon,  2 Nov 2020 01:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604278949;
        bh=Hnt63VLJGdry7jyNhcB54dUyy41zGJcBIexQev/YCac=;
        h=Date:From:To:Subject:From;
        b=PXCxLgB1DDdc4vKjcpk0Ao6XxHA8ZWzpacmB0zk/qBduwODaiuOn/GseMrvlb6vor
         wa88ZBD5y2rBdA8R73Q7bkmY0C9E5FnzrtU9Su5r2qQX3ger6FcFiIduX0BqardvO1
         SucEuu+Kxg2MxSek0kBlnLXZSzbYas27MBXlnVRc=
Date:   Sun, 01 Nov 2020 17:02:29 -0800
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, riel@surriel.com, shy828301@gmail.com,
        vbabka@suse.cz, ziy@nvidia.com
Subject:  [folded-merged]
 mm-compaction-count-pages-and-stop-correctly-during-page-isolation-v3.patch
 removed from -mm tree
Message-ID: <20201102010229.ZoUiwYIKW%akpm@linux-foundation.org>
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
has been removed from the -mm tree.  Its filename was
     mm-compaction-count-pages-and-stop-correctly-during-page-isolation-v3.=
patch

This patch was dropped because it was folded into mm-compaction-count-pages=
-and-stop-correctly-during-page-isolation.patch

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
mm-compaction-stop-isolation-if-too-many-pages-are-isolated-and-we-have-pag=
es-to-migrate.patch

