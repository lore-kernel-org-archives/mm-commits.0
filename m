Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD979C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9745D610C7
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 21:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhJ0VYp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 17:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244447AbhJ0VXs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 17:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A144C610C7;
        Wed, 27 Oct 2021 21:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635369682;
        bh=XkY68Hmpnw36NOGHAcbpOtCZItp4hWRWeWwzasvdl5s=;
        h=Date:From:To:Subject:From;
        b=rdZ8SfBgF9Wp4Kj9yVBssHvz9mQ5nuQBptDS1oWtFPiFR2hyyhD3LjR0ywkw6whRM
         APyiJZuVal4/KuvZaXh++T8psvfzysCR4WaqlgzsdGUExG/zDToHL7uViSxmIkPrhp
         xdbQP7W8AcqshpS9NO02VyhrbT3Eypocima7qLaA=
Date:   Wed, 27 Oct 2021 14:21:22 -0700
From:   akpm@linux-foundation.org
To:     hulkci@huawei.com, mm-commits@vger.kernel.org, sj@kernel.org,
        yangyingliang@huawei.com
Subject:  +
 mm-damon-introduce-damon-based-reclamation-damon_reclaim-fix.patch added to
 -mm tree
Message-ID: <20211027212122.3d_VpryMI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: fix error return code in damon_reclaim_turn()
has been added to the -mm tree.  Its filename is
     mm-damon-introduce-damon-based-reclamation-damon_reclaim-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-introduce-damon-based-reclamation-damon_reclaim-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-introduce-damon-based-reclamation-damon_reclaim-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-damon-introduce-damon-based-reclamation-damon_reclaim-fix.patch

