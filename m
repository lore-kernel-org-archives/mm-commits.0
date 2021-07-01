Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE51C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 952EF61467
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbhGABwW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABwW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEB7561466;
        Thu,  1 Jul 2021 01:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104192;
        bh=UaiPca7gs407bkmCVK4bU9Y93+uF2oRhgy/5oNT0hcI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Rn3JLFPAmIikthGgjrQQpdkqhrsICZYskSpyop+a97rJ2ygqFeFsFNBKYVQsXvadB
         vpy1qknnNy2PnE6ipBKLuskEeLLJ73SJxl5rAXrBRybnBciFEjQ5DbxBfrFv8iG5IE
         49eA+bLKOSRqNpMoP6pVnMtRR+asXeCMzeW94mwQ=
Date:   Wed, 30 Jun 2021 18:49:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yuzhao@google.com
Subject:  [patch 050/192] include/trace/events/vmscan.h: remove
 mm_vmscan_inactive_list_is_low
Message-ID: <20210701014951.I2J96pCkx%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yu Zhao <yuzhao@google.com>
Subject: include/trace/events/vmscan.h: remove mm_vmscan_inactive_list_is_low

mm_vmscan_inactive_list_is_low has no users after commit b91ac374346b
("mm: vmscan: enforce inactive:active ratio at the reclaim root").

Remove it.

Link: https://lkml.kernel.org/r/20210614194554.2683395-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   41 --------------------------------
 1 file changed, 41 deletions(-)

--- a/include/trace/events/vmscan.h~include-trace-events-vmscanh-remove-mm_vmscan_inactive_list_is_low
+++ a/include/trace/events/vmscan.h
@@ -423,47 +423,6 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
-TRACE_EVENT(mm_vmscan_inactive_list_is_low,
-
-	TP_PROTO(int nid, int reclaim_idx,
-		unsigned long total_inactive, unsigned long inactive,
-		unsigned long total_active, unsigned long active,
-		unsigned long ratio, int file),
-
-	TP_ARGS(nid, reclaim_idx, total_inactive, inactive, total_active, active, ratio, file),
-
-	TP_STRUCT__entry(
-		__field(int, nid)
-		__field(int, reclaim_idx)
-		__field(unsigned long, total_inactive)
-		__field(unsigned long, inactive)
-		__field(unsigned long, total_active)
-		__field(unsigned long, active)
-		__field(unsigned long, ratio)
-		__field(int, reclaim_flags)
-	),
-
-	TP_fast_assign(
-		__entry->nid = nid;
-		__entry->reclaim_idx = reclaim_idx;
-		__entry->total_inactive = total_inactive;
-		__entry->inactive = inactive;
-		__entry->total_active = total_active;
-		__entry->active = active;
-		__entry->ratio = ratio;
-		__entry->reclaim_flags = trace_reclaim_flags(file) &
-					 RECLAIM_WB_LRU;
-	),
-
-	TP_printk("nid=%d reclaim_idx=%d total_inactive=%ld inactive=%ld total_active=%ld active=%ld ratio=%ld flags=%s",
-		__entry->nid,
-		__entry->reclaim_idx,
-		__entry->total_inactive, __entry->inactive,
-		__entry->total_active, __entry->active,
-		__entry->ratio,
-		show_reclaim_flags(__entry->reclaim_flags))
-);
-
 TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
 	TP_PROTO(int nid, int order, gfp_t gfp_flags),
_
