Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFECDC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbiEJEPC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235971AbiEJEOe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2090238D4D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EC50B817CC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E08C385C2;
        Tue, 10 May 2022 04:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155834;
        bh=1EHOaZbCm8L7K704VLVvaY427/t4Qh/fVRGgOb+pQDQ=;
        h=Date:To:From:Subject:From;
        b=MlKdWtEzJ+ArWceMX1HaJG7Uy1I1MlsQ6WhMHKytnxls6207GHZWuikPKyWT64XeZ
         Q/U4CoYVvzOVMBNUdKm/od3iJDAO/3frwMwgW05q4r8kY1oeLXH8KwQOws4gsm5iDd
         +VJx9W8w0y/UjQpkLSVwJS6SWrjxwUhNnzjRprmY=
Date:   Mon, 09 May 2022 21:10:34 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org, axboe@kernel.dk,
        chenwandun@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio.patch removed from -mm tree
Message-Id: <20220510041034.D6E08C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rework calculation of bdi_min_ratio in bdi_set_min_ratio
has been removed from the -mm tree.  Its filename was
     mm-rework-calculation-of-bdi_min_ratio-in-bdi_set_min_ratio.patch

This patch was dropped because it was merged into mm-stable

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


