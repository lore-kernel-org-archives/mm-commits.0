Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252FDC433E4
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCDB422D6D
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781520;
	bh=c30aFQFpb1sGFaKvC5jFfBVWw3bdwgKOtSCm3G7VIcc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=V4/NEEfbUDyQukV4JkE8RTqLBRMcks+cNdGEIeTRUdD/jnLGnWdgh7/sgrgaVdA16
	 /Sxo/V0N/gdaU560cXm94aKWWrqeEeiYthHoHIjqt0iJhPN0DFpMtUbx/iRTy0XFte
	 JbVoGO0LJZxjC3mR42ZDSJIh7IOXAuPSzQQWjBys=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHGGZS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AD2422CAF;
        Fri,  7 Aug 2020 06:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781517;
        bh=c30aFQFpb1sGFaKvC5jFfBVWw3bdwgKOtSCm3G7VIcc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R0MUdeMpN+dayT6jPvcBA8nL/6rYgPSLwPgZSOGOpoZQloRTurtR5vlduN/BQdup7
         /ylG79r2baF2SLYsL+KMv80xRj/XBP8yeHaA9W56s9OGFDXQave9vl27NlGkENWh64
         eLZUKf6LycRqlsYGaQ2LmCq9qYRRyQskRASwnlTY=
Date:   Thu, 06 Aug 2020 23:25:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hughd@google.com, hughd@googlecom, linux-mm@kvack.org,
        liwang@redhat.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 141/163] mm, page_alloc: use unlikely() in
 task_capc()
Message-ID: <20200807062516.PB8FpOrnh%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: use unlikely() in task_capc()

Hugh noted that task_capc() could use unlikely(), as most of the time
there is no capture in progress and we are in page freeing hot path. 
Indeed adding unlikely() produces assembly that better matches the
assumption and moves all the tests away from the hot path.

I have also noticed that we don't need to test for cc->direct_compaction
as the only place we set current->task_capture is compact_zone_order()
which also always sets cc->direct_compaction true.

Link: http://lkml.kernel.org/r/4a24f7af-3aa5-6e80-4ae6-8f253b562039@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@googlecom>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Li Wang <liwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-unlikely-in-task_capc
+++ a/mm/page_alloc.c
@@ -813,11 +813,10 @@ static inline struct capture_control *ta
 {
 	struct capture_control *capc = current->capture_control;
 
-	return capc &&
+	return unlikely(capc) &&
 		!(current->flags & PF_KTHREAD) &&
 		!capc->page &&
-		capc->cc->zone == zone &&
-		capc->cc->direct_compaction ? capc : NULL;
+		capc->cc->zone == zone ? capc : NULL;
 }
 
 static inline bool
_
