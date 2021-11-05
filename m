Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB3AC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15CF061216
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhKESxS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232996AbhKESxR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:53:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D186D6120D;
        Fri,  5 Nov 2021 18:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636138238;
        bh=Ttlu68cLMXflcIwuE1sPEcRA0sO46RhnIjmq7NuMDMM=;
        h=Date:From:To:Subject:From;
        b=A4hlYRpQljaC72XWQDPSmBAXDSygYXGf3hNcfNowrF9Oa4IUqkPXeqM+pvEu8lmt2
         zq+CdNy3IedEPIl4EM9i9R4bySGyY4EPKEWa7A2SS7+BdU0bRtHjKHJfMAMamjQVZa
         VACMDlJA880k2KuzmPpBqGFl70kUuJMtCk7Mi4XE=
Date:   Fri, 05 Nov 2021 11:50:37 -0700
From:   akpm@linux-foundation.org
To:     hulkci@huawei.com, mm-commits@vger.kernel.org, sj@kernel.org,
        yangyingliang@huawei.com
Subject:  [folded-merged]
 mm-damon-introduce-damon-based-reclamation-damon_reclaim-fix.patch removed
 from -mm tree
Message-ID: <20211105185037.eQqm1vOhZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: fix error return code in damon_reclaim_turn()
has been removed from the -mm tree.  Its filename was
     mm-damon-introduce-damon-based-reclamation-damon_reclaim-fix.patch

This patch was dropped because it was folded into mm-damon-introduce-damon-based-reclamation-damon_reclaim.patch

------------------------------------------------------
From: Yang Yingliang <yangyingliang@huawei.com>
Subject: mm/damon: fix error return code in damon_reclaim_turn()

If damon_reclaim_new_scheme() fails, it should return error code in
damon_reclaim_turn()

Link: https://lkml.kernel.org/r/20211025124500.2758060-1-yangyingliang@huawei.com
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-introduce-damon-based-reclamation-damon_reclaim-fix
+++ a/mm/damon/reclaim.c
@@ -292,8 +292,10 @@ static int damon_reclaim_turn(bool on)
 
 	/* Will be freed by 'damon_set_schemes()' below */
 	scheme = damon_reclaim_new_scheme();
-	if (!scheme)
+	if (!scheme) {
+		err = -ENOMEM;
 		goto free_region_out;
+	}
 	err = damon_set_schemes(ctx, &scheme, 1);
 	if (err)
 		goto free_scheme_out;
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

mm-damon-introduce-damon-based-reclamation-damon_reclaim.patch

