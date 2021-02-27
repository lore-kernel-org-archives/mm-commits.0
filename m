Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF5FC433E0
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1D3364F2D
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhB0Can (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhB0CaS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73C5764F35;
        Sat, 27 Feb 2021 02:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392950;
        bh=8JiaX1iSz8sTdueerpL9fGu612linTMpfg478YW5ZCk=;
        h=Date:From:To:Subject:From;
        b=D8JRt8lhSz/7odTPi8PeNGZIZRqY4s57lOtnxU61er8NTxTtgLEAMroOy20JU3uM4
         r8VF+9lb6J86OPTQHojglnXGhOj3Q2z9GO9ZYmZiCGf1A+YCcPG4dHHsoLpdiMmotD
         zqdMQ+n16HN6UivTLv+CK4BHw313aiWY2uciFQyw=
Date:   Fri, 26 Feb 2021 18:29:10 -0800
From:   akpm@linux-foundation.org
To:     benbjiang@tencent.com, cl@linux-foundation.org,
        mm-commits@vger.kernel.org, robinlai@tencent.com
Subject:  [merged]
 mm-vmstatc-erase-latency-in-vmstat_shepherd.patch removed from -mm tree
Message-ID: <20210227022910.LR89jTvMz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: erase latency in vmstat_shepherd
has been removed from the -mm tree.  Its filename was
     mm-vmstatc-erase-latency-in-vmstat_shepherd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Biao <benbjiang@tencent.com>
Subject: mm/vmstat.c: erase latency in vmstat_shepherd

Many 100us+ latencies have been deteceted in vmstat_shepherd() on CPX
platform which has 208 logic cpus.  And vmstat_shepherd is queued every
second, which could make the case worse.

Add schedule point in vmstat_shepherd() to erase the latency.

Link: https://lkml.kernel.org/r/20210111035526.1511-1-benbjiang@tencent.com
Signed-off-by: Jiang Biao <benbjiang@tencent.com>
Reported-by: Bin Lai <robinlai@tencent.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmstat.c~mm-vmstatc-erase-latency-in-vmstat_shepherd
+++ a/mm/vmstat.c
@@ -1980,6 +1980,8 @@ static void vmstat_shepherd(struct work_
 
 		if (!delayed_work_pending(dw) && need_update(cpu))
 			queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+
+		cond_resched();
 	}
 	put_online_cpus();
 
_

Patches currently in -mm which might be from benbjiang@tencent.com are


