Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8761FC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24E2D221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709376;
	bh=uZYxhOf1zMfEHUqXVW7juLUNCovdL21s/8wy9htpjqg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qOl8s2f3ES1kZHLUA9di63zILxoRh2Yh7gYhTpxplqkXscJQGn95BKzT6SU4IalZY
	 tfDp0WKCVzXC3HDJDtNAIDnduHGNM0zv3NuEk3YpMG98/V6903pCoVMofQqb5Huw7w
	 M+SnlS0xN/jro+JCzfuHqwypppPK1v0HM/dUPA+Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387543AbgJNVCz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVCz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92EDC206B2;
        Wed, 14 Oct 2020 21:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709373;
        bh=uZYxhOf1zMfEHUqXVW7juLUNCovdL21s/8wy9htpjqg=;
        h=Date:From:To:Subject:From;
        b=qNYu4JBEUTjC/fXPpvzj/Yn7PNtvpv9/owfYYQvIr+POVT17QzxqEoiQmodL9GKDM
         QuBl7PE6DD/KD5oKV6wy9cL4cf3kL+YCLIat7WtWtTbgtCfoiqqTpMPmEQS1fjte8H
         xor6tm/A6KUixy9UXrv97pu6GktdhXbtS7m5yH1U=
Date:   Wed, 14 Oct 2020 14:02:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        yanfei.xu@windriver.com
Subject:  [merged]
 mm-page_allocc-__perform_reclaim-should-return-unsigned-long.patch removed
 from -mm tree
Message-ID: <20201014210253.ZG_iF2qfN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: __perform_reclaim should return 'unsigned long'
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-__perform_reclaim-should-return-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/page_alloc.c: __perform_reclaim should return 'unsigned long'

__perform_reclaim()'s single caller expects it to return 'unsigned long',
hence change its return value and a local variable to 'unsigned long'.

Link: https://lkml.kernel.org/r/20200916022138.16740-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-__perform_reclaim-should-return-unsigned-long
+++ a/mm/page_alloc.c
@@ -4253,13 +4253,12 @@ EXPORT_SYMBOL_GPL(fs_reclaim_release);
 #endif
 
 /* Perform direct synchronous page reclaim */
-static int
+static unsigned long
 __perform_reclaim(gfp_t gfp_mask, unsigned int order,
 					const struct alloc_context *ac)
 {
-	int progress;
 	unsigned int noreclaim_flag;
-	unsigned long pflags;
+	unsigned long pflags, progress;
 
 	cond_resched();
 
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are


