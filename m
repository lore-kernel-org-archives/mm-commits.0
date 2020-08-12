Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADE8C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D747206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195983;
	bh=U6WYtYGlZpZqBiAeJHb7gt4PMq7xNtZnne6KZjX1/2g=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=D9BA80KneLOzWZSfTavov8GCPO8SNEY+ctK58krokIqBTEMStR5IFCcV14A/apTux
	 xg6gb3sCeay8KJglFm51Old0IqcRQIDw30qL7jnRnBcIzSheq4rGXUwNriECbzugV+
	 m/gGWOzf9+Lga+/lquvkOlDNjaC3kTUoZlku9ZRA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgHLBdD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBdD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DD1A207DA;
        Wed, 12 Aug 2020 01:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195982;
        bh=U6WYtYGlZpZqBiAeJHb7gt4PMq7xNtZnne6KZjX1/2g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=umsJjyABxVWIA0ETagaX/wM86rB41DN1unzl83TA1h08A6gfZVCIWCrBnzeIYnQMq
         XVReleJe4IEtasRHwIzk23BqlGGbwpa+JmblgwFagNef1Wl8GeKhPBELB0Qcw5hlTh
         x/YqAbpRCc8fby+skHFJvQWR9w/pD8Dct7mfF6HU=
Date:   Tue, 11 Aug 2020 18:33:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 052/165] mm/memcontrol.c: delete duplicated words
Message-ID: <20200812013302.9mqcup-To%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/memcontrol.c: delete duplicated words

Drop the repeated word "down".

Link: http://lkml.kernel.org/r/20200801173822.14973-6-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrolc-delete-duplicated-words
+++ a/mm/memcontrol.c
@@ -2422,7 +2422,7 @@ static void high_work_func(struct work_s
  *
  * - MEMCG_DELAY_PRECISION_SHIFT: Extra precision bits while translating the
  *   overage ratio to a delay.
- * - MEMCG_DELAY_SCALING_SHIFT: The number of bits to scale down down the
+ * - MEMCG_DELAY_SCALING_SHIFT: The number of bits to scale down the
  *   proposed penalty in order to reduce to a reasonable number of jiffies, and
  *   to produce a reasonable delay curve.
  *
_
