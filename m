Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9536AC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D7AC206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196007;
	bh=A/KvW+AHn+gU8zgEfPlxEGXCmUpd3qPenWo+otcRTss=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=13TC42ZCWjKxCivFdOlk/Yd/+vI+YhuLEpZsR2Ep222GK/8yy2RtJYVjlYOJYCF9o
	 8SjG34oCLI9dIcIPURDmUCbeijWuPj181KvrLuvQYZPeR45d/UKQPyMnAJimWiA89I
	 HQSUOBnLxRxvu6qmAKfMEB2ogQyPDZQJNs68t13s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHLBd1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgHLBd0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 609EF2076C;
        Wed, 12 Aug 2020 01:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196006;
        bh=A/KvW+AHn+gU8zgEfPlxEGXCmUpd3qPenWo+otcRTss=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fXqnrrwWKoo2nClbE9wA9gZLZFlJ+4x535bfVF7i6VjVNI45SNbov4i0N2LTAW1ni
         gz5f2HBu5EDSRwDuO4dlbdRo+e0W2i0XvfCDiuyjnIrcOZK2Um0EnEOMpfekw9RTQ8
         PeBsLS0b840KVxIQ8Wn5RdKXyDx635PLu+7eNnXE=
Date:   Tue, 11 Aug 2020 18:33:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 060/165] mm/vmscan.c: delete or fix duplicated
 words
Message-ID: <20200812013326.lo99qqhki%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/vmscan.c: delete or fix duplicated words

Drop the repeated word "marked".
Change "time time" to "same time".

Link: http://lkml.kernel.org/r/20200801173822.14973-14-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscanc-delete-or-fix-duplicated-words
+++ a/mm/vmscan.c
@@ -2798,7 +2798,7 @@ again:
 			set_bit(PGDAT_DIRTY, &pgdat->flags);
 
 		/*
-		 * If kswapd scans pages marked marked for immediate
+		 * If kswapd scans pages marked for immediate
 		 * reclaim and under writeback (nr_immediate), it
 		 * implies that pages are cycling through the LRU
 		 * faster than they are written so also forcibly stall.
@@ -3373,7 +3373,7 @@ static bool pgdat_watermark_boosted(pg_d
 	/*
 	 * Check for watermark boosts top-down as the higher zones
 	 * are more likely to be boosted. Both watermarks and boosts
-	 * should not be checked at the time time as reclaim would
+	 * should not be checked at the same time as reclaim would
 	 * start prematurely when there is no boosting and a lower
 	 * zone is balanced.
 	 */
_
