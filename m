Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4059C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 21:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C55207FF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 21:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597872594;
	bh=BHyo8Y1ZsxHKEFTEfUdomYxm4tmDp/ILxVXgPB1wUFY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mWL2GlwQ6WNv8V8bSsS2R7BNb6jVtCgk3oI1MSIH7Zr2CzenD5ojsEgcL4wd+8WFu
	 NlzWmunn4H1x4yz4O3cgsxSUYTiZxUSCxoaQcrmWoXRVu4ytHXOiinjlWDjSWGnKyn
	 CPjJNrytC/RmFDXf1o8892I6euidujm2xKxHZ7M4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgHSV3y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 17:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbgHSV3y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 17:29:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB1142067C;
        Wed, 19 Aug 2020 21:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597872593;
        bh=BHyo8Y1ZsxHKEFTEfUdomYxm4tmDp/ILxVXgPB1wUFY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Eu3OeU2x1R1nRbuDonmiFvjdLAyYcKhqxCcDkjrJUhRHJummfPISu629Yihtfq51q
         39Nkg6dK+uO2vzXKjVKsowvesf1sdu0OoUDEkIj264QFZ910AoL9EY7jM+TsTLcnTe
         x1xS2BVH51RVn9zlIRdkKv57zIRLYxvKG9A5RXYs=
Date:   Wed, 19 Aug 2020 14:29:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, keun-o.park@digital14.com,
        mm-commits@vger.kernel.org, thgarnie@chromium.org
Subject:  +
 =?US-ASCII?Q?mm-slub-re-initialize-randomized-freelist-sequence-in-calcu?=
 =?US-ASCII?Q?late=5Fsizes-fix.patch?= added to -mm tree
Message-ID: <20200819212953.zjzLM2Zm-%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix
has been added to the -mm tree.  Its filename is
     mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix

simplification, per Thomas

Cc: Sahara <keun-o.park@digital14.com>
Cc: Thomas Garnier <thgarnie@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/slub.c~mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix
+++ a/mm/slub.c
@@ -3786,8 +3786,7 @@ static int calculate_sizes(struct kmem_c
 	 * free and re-initialize it with re-calculated value.
 	 */
 	if (slab_state >= UP) {
-		if (s->random_seq)
-			cache_random_seq_destroy(s);
+		cache_random_seq_destroy(s);
 		if (init_cache_random_seq(s))
 			return 0;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

