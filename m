Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892A0C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiLAAKd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiLAAIh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:08:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30D55B86B
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A48CB81AD6
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F561C433B5;
        Thu,  1 Dec 2022 00:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852976;
        bh=MJL2w8CpSbrtb+KCia+zqC4ktxQJNM0g03m5Me5ynrY=;
        h=Date:To:From:Subject:From;
        b=Eenn1KXmd8LsVcRSt20wBLt9VC3wynVbfKL9HXgQPhQIfn4EMWft6F4BpFhsbnLDT
         wSofR/spc34FDegN++LvbaZjksSidqSvXmvpijkZ9JoQOO4YPmBlMoTV9l0PxQgy2q
         TS+0uFKbAEq1IA37tg9TKIJ/YuBFYLNEWneoTzQg=
Date:   Wed, 30 Nov 2022 16:02:55 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-bdi_get_min_bytes-function.patch removed from -mm tree
Message-Id: <20221201000256.1F561C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add bdi_get_min_bytes() function
has been removed from the -mm tree.  Its filename was
     mm-add-bdi_get_min_bytes-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: add bdi_get_min_bytes() function
Date: Fri, 18 Nov 2022 16:52:05 -0800

This adds a function to return the specified value for min_bytes. It
converts the stored min_ratio of the bdi to the corresponding bytes
value. This is an approximation as it is based on the value that is
returned by global_dirty_limits(), which can change. The returned
value can be different than the value when the min_bytes value was set.

Link: https://lkml.kernel.org/r/20221119005215.3052436-11-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |    5 +++++
 2 files changed, 6 insertions(+)

--- a/include/linux/backing-dev.h~mm-add-bdi_get_min_bytes-function
+++ a/include/linux/backing-dev.h
@@ -105,6 +105,7 @@ static inline unsigned long wb_stat_erro
 /* BDI ratio is expressed as part per 1000000 for finer granularity. */
 #define BDI_RATIO_SCALE 10000
 
+u64 bdi_get_min_bytes(struct backing_dev_info *bdi);
 u64 bdi_get_max_bytes(struct backing_dev_info *bdi);
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio);
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
--- a/mm/page-writeback.c~mm-add-bdi_get_min_bytes-function
+++ a/mm/page-writeback.c
@@ -740,6 +740,11 @@ int bdi_set_max_ratio(struct backing_dev
 }
 EXPORT_SYMBOL(bdi_set_max_ratio);
 
+u64 bdi_get_min_bytes(struct backing_dev_info *bdi)
+{
+	return bdi_get_bytes(bdi->min_ratio);
+}
+
 u64 bdi_get_max_bytes(struct backing_dev_info *bdi)
 {
 	return bdi_get_bytes(bdi->max_ratio);
_

Patches currently in -mm which might be from shr@devkernel.io are


