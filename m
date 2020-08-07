Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DECC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41E0322CF6
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781543;
	bh=pyG99N82HO9rFPrBYnc6mprIk9LW2rPMq09vEowJOIs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dbSKGonGKE7Jvv7FP7WcL3FYiLKG34H08PGCYtRSMhzB4+lwR05GdBhaQByBjyTi+
	 kNF4f5cis4xEWR2eqWV2sozbpwmcOecKw7lsh2lou0JwhLPsFKwF+LGsThWj6gNAR/
	 X8c5EMNpUNFxRY1G4gtSXrjP+JzQhHQ+vmkWeEvU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHGGZn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CA3E22CAE;
        Fri,  7 Aug 2020 06:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781542;
        bh=pyG99N82HO9rFPrBYnc6mprIk9LW2rPMq09vEowJOIs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=isn4F7fFEOK0bVNH924Rebe1MUVLO4tfR65eJTcRZKCOy8tp5dUTzIySg5T4SZHKx
         SAnW0GYw+C3/j+SfNiPdZpkKRR/r/KQ/mgO7OfYuUz7gKfz3wda2QB10ySxvmbMh8q
         kamCMRKAIVXQslJqN2HuEHdAwAwUHmFEC7e4ep7k=
Date:   Thu, 06 Aug 2020 23:25:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mgorman@suse.de,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 148/163] mm/page_alloc.c: replace the definition
 of NR_MIGRATETYPE_BITS with PB_migratetype_bits
Message-ID: <20200807062541.JFMzNVDYc%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/page_alloc.c: replace the definition of NR_MIGRATETYPE_BITS with PB_migratetype_bits

We already have the definition of PB_migratetype_bits and current
NR_MIGRATETYPE_BITS looks like a cyclic definition.

Just use PB_migratetype_bits is enough.

Link: http://lkml.kernel.org/r/20200623124201.8199-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits
+++ a/include/linux/mmzone.h
@@ -88,8 +88,7 @@ static inline bool is_migrate_movable(in
 
 extern int page_group_by_mobility_disabled;
 
-#define NR_MIGRATETYPE_BITS (PB_migrate_end - PB_migrate + 1)
-#define MIGRATETYPE_MASK ((1UL << NR_MIGRATETYPE_BITS) - 1)
+#define MIGRATETYPE_MASK ((1UL << PB_migratetype_bits) - 1)
 
 #define get_pageblock_migratetype(page)					\
 	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
_
