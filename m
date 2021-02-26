Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA7DC43381
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374B564F17
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhBZBRa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhBZBRT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2518064F13;
        Fri, 26 Feb 2021 01:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302215;
        bh=aERu7B+meUjS1DkaQS6FJmelVfnIKPgjL4xkn8mlZps=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=h2wVN3HuHinsxkkc8J580tB8AfyKbORrRKdsBG+FmPI5ub3WMY91YezHdnXWgp9mL
         wNPd0q0EXHWEmSGwzkyM3WA8labhSW1RsAtAgVTEEXM6N0ugd5uXXFl81iHvxDJ4LU
         Zh7Uifm1yMwhrLnK7Bgh0v/A4QdCIHnc8U2AlmuQ=
Date:   Thu, 25 Feb 2021 17:16:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benbjiang@tencent.com,
        cl@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, robinlai@tencent.com,
        torvalds@linux-foundation.org
Subject:  [patch 025/118] mm/vmstat.c: erase latency in
 vmstat_shepherd
Message-ID: <20210226011654.UO7WPPOjW%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
