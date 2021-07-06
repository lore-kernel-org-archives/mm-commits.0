Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BADC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DED061C7F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhGFTUy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231748AbhGFTUy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:20:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65E8E61C7C;
        Tue,  6 Jul 2021 19:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599094;
        bh=SSOpqhocZE7NBH80k/WHAv9h9h7Se1FfuCvttf/3iIY=;
        h=Date:From:To:Subject:From;
        b=okR/iygyemdf6/mU/MXBkal9H60Bj5QmDz8XpZx4wdz2oytArKEOKe1uXMn9HVzHz
         BqmSvnCgQVEI/DQ+M4tW1MHtKvswQ71VuuwFqU+1QdLILcv+dZ1v3dptQr9O2f+oC/
         SdK06XToycm1H0aPOL+JTFs1dq4AHabR5n3Em6ww=
Date:   Tue, 06 Jul 2021 12:18:14 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org, yuzhao@google.com
Subject:  [merged]
 include-trace-events-vmscanh-remove-mm_vmscan_inactive_list_is_low.patch
 removed from -mm tree
Message-ID: <20210706191814.H3onNfbMi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/trace/events/vmscan.h: remove mm_vmscan_inactive_list_is_low
has been removed from the -mm tree.  Its filename was
     include-trace-events-vmscanh-remove-mm_vmscan_inactive_list_is_low.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yuzhao@google.com are


