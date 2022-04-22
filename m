Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083EFC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 22:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiDVWJN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiDVWIJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 18:08:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3AD7B564
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 13:54:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20733B82D82
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 20:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DF4C385A0;
        Fri, 22 Apr 2022 20:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650660853;
        bh=55clj9qaxAjQvhj8ZyjH43tAYeY2OyvsgFnO4Ed6REc=;
        h=Date:To:From:Subject:From;
        b=EPBMbGRygQwk8K8Y+4wjaMkvxVnqzW+Ly61VFx3Ci9nIrtBAy6rKxSdpMe3CxJj3R
         rizFvwT1FoLlkkECQdPhWMwoPAW/1TcwBdosysBA5630hngj+h+60vyTOjb4izEIL1
         TINqVSRAPTmD2qPX42xJBdZnS0L6lrIDs7gufl+I=
Date:   Fri, 22 Apr 2022 13:54:13 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org, axboe@kernel.dk,
        chenwandun@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio.patch added to -mm tree
Message-Id: <20220422205413.C4DF4C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rework calculation of bdi_min_ratio in bdi_set_min_ratio
has been added to the -mm tree.  Its filename is
     mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm: rework calculation of bdi_min_ratio in bdi_set_min_ratio

In function bdi_set_min_ratio, min_ratio is unsigned int, it will
result underflow when setting min_ratio below bdi->min_ratio, it
is confusing. Rework it, no functional change.

Link: https://lkml.kernel.org/r/20220422095159.2858305-1-chenwandun@huawei.com
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/page-writeback.c~mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio
+++ a/mm/page-writeback.c
@@ -650,18 +650,25 @@ static unsigned int bdi_min_ratio;
 
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 {
+	unsigned int delta;
 	int ret = 0;
 
 	spin_lock_bh(&bdi_lock);
 	if (min_ratio > bdi->max_ratio) {
 		ret = -EINVAL;
 	} else {
-		min_ratio -= bdi->min_ratio;
-		if (bdi_min_ratio + min_ratio < 100) {
-			bdi_min_ratio += min_ratio;
-			bdi->min_ratio += min_ratio;
+		if (min_ratio < bdi->min_ratio) {
+			delta = bdi->min_ratio - min_ratio;
+			bdi_min_ratio -= delta;
+			bdi->min_ratio = min_ratio;
 		} else {
-			ret = -EINVAL;
+			delta = min_ratio - bdi->min_ratio;
+			if (bdi_min_ratio + delta < 100) {
+				bdi_min_ratio += delta;
+				bdi->min_ratio = min_ratio;
+			} else {
+				ret = -EINVAL;
+			}
 		}
 	}
 	spin_unlock_bh(&bdi_lock);
_

Patches currently in -mm which might be from chenwandun@huawei.com are

mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio.patch
mm-page_alloc-simplify-update-of-pgdat-in-wake_all_kswapds.patch

