Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C2CC2B9F4
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 23:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5C5061350
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 23:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhFNXbW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 19:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhFNXbW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 19:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94E7F6128B;
        Mon, 14 Jun 2021 23:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623713348;
        bh=jE12Pc57QsFr72z6Xy0/jpHmcJIVWCbkU2hPMyV02gk=;
        h=Date:From:To:Subject:From;
        b=ON3eDtKWhdE5aSNJB5+iA9YrDGym0ObBXQ4sm2boti+ambvDA+cBt5d/VKzeHPsvg
         OwSJuJ29FY4iogg645cpUx8EuCyTQrVgROkUoB3/JrMyvcNV1lvg+qcLLGcMQkD85B
         UMpYZMlmJG1Y+Y4Ik+KySnYWH10Oa5hsUxKTd2Qo=
Date:   Mon, 14 Jun 2021 16:29:08 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org, yuzhao@google.com
Subject:  +
 include-trace-events-vmscanh-remove-mm_vmscan_inactive_list_is_low.patch
 added to -mm tree
Message-ID: <20210614232908.rSwdAlcFO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/trace/events/vmscan.h: remove mm_vmscan_inactive_list_is_low
has been added to the -mm tree.  Its filename is
     include-trace-events-vmscanh-remove-mm_vmscan_inactive_list_is_low.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-trace-events-vmscanh-remove-mm_vmscan_inactive_list_is_low.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-trace-events-vmscanh-remove-mm_vmscan_inactive_list_is_low.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmscanc-fix-potential-deadlock-in-reclaim_pages.patch
include-trace-events-vmscanh-remove-mm_vmscan_inactive_list_is_low.patch

