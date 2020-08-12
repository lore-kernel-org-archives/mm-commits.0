Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C53C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5296020774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266193;
	bh=zbV0AJP9sEX7BFJUZQ8Ocy/aWguZtVhVjJmgGqsyz2s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=AUrSFXZBt5UdubAKe7n7Ta5SFdXDRXEV57ikXYHyIPpY9/tt7HWTH+tSerMrwcL+p
	 wJqUIHahBTjZVkudcXB2dKDkRu/2C0L3OtUAIlgTtkMmLSzW91ISrxuRvym+DPiX3b
	 5o1j6JazILTYbXp4UzrfSEH89QsJm7yUaAZtyg0Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHLVDN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgHLVDM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E81A20774;
        Wed, 12 Aug 2020 21:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266191;
        bh=zbV0AJP9sEX7BFJUZQ8Ocy/aWguZtVhVjJmgGqsyz2s=;
        h=Date:From:To:Subject:From;
        b=hIPSXnM5wS6tKtZiSEcL73ryWsu1WCxXDTCUb4n49ES9qUB44Kc+qXBn5plSr6Eh6
         Pce5vgSBcx5XjAM9uHJPyYzuB5Bdeo58GuB4E9aTK8KVra1ITDeOe9znj53r94X3fF
         3LIB6QHd1N45tb/Sy4N6oCM/lJFrZib8REGfrJJE=
Date:   Wed, 12 Aug 2020 14:03:11 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-vmscanc-delete-or-fix-duplicated-words.patch
 removed from -mm tree
Message-ID: <20200812210311.V8trLslzS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: delete or fix duplicated words
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-delete-or-fix-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are


