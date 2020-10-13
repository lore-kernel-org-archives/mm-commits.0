Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CE0C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 236B722246
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633420;
	bh=WGnmi9mAf2C/DobI1Es+t829I+zCkkB1mrr4P42tt6I=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=MUmAg1KxYBDdok94K3BLOgfHsFLV34LWwg2kgmGXg5BgJbOH2UfXh/OzOlhL7B+ht
	 Mfbd5iM3ayZsun35R1KZaeKu/S+iezPpuiqdGl8zfY9D6h3tAFU4UsWDVzawzKTs8H
	 GRJ3rnb593uozrLE7SndDxemcwRSikbKYLNwCjx0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388695AbgJMX47 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMX47 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE9652223F;
        Tue, 13 Oct 2020 23:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633419;
        bh=WGnmi9mAf2C/DobI1Es+t829I+zCkkB1mrr4P42tt6I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0MYb0i0+l4eGoC0Gd7m7JhJ+NDX68DYzjTEPQtVSFZPkPl9XXb5j3isQUWgpkw4Yh
         O5FcKDqQqetAS7zfc5V1ckI0Ao5R5uCWvaO19E9sDzAfWPV8UW/4dOmrrrh8M601AE
         QvgKtOslEJIfo60hm35XMEaX3gEn5JtQv/XMKhrM=
Date:   Tue, 13 Oct 2020 16:56:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mateusznosek0@gmail.com, mgorman@suse.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 156/181] mm/compaction.c: micro-optimization
 remove unnecessary branch
Message-ID: <20201013235658.mJxIcj5ip%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/compaction.c: micro-optimization remove unnecessary branch

The same code can work both for 'zone->compact_considered > defer_limit'
and 'zone->compact_considered >= defer_limit'.  In the latter there is one
branch less which is more effective considering performance.

Link: https://lkml.kernel.org/r/20200913190448.28649-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compactionc-micro-optimization-remove-unnecessary-branch
+++ a/mm/compaction.c
@@ -180,11 +180,10 @@ bool compaction_deferred(struct zone *zo
 		return false;
 
 	/* Avoid possible overflow */
-	if (++zone->compact_considered > defer_limit)
+	if (++zone->compact_considered >= defer_limit) {
 		zone->compact_considered = defer_limit;
-
-	if (zone->compact_considered >= defer_limit)
 		return false;
+	}
 
 	trace_mm_compaction_deferred(zone, order);
 
_
