Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18DAC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 873922076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196071;
	bh=n3akit/kS5Ki7INVqk0MzU8of1pDmKLYQp0MI3SprD8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Hvlroll6Dzh+9XfsPwH9J/8ZGtitbSeNoN3oxZMSWbRECLFFQgljhbH23M+xFOpuS
	 CwGwafJ8+HHCRgBZmlMRt4xgiGsjR51fhObeWquPBN5HOE79drSoKhLSmLcLMHpa88
	 YLPvL5xeSuUeB1C6FqsxXyApLfalK5ve1M5vfJFs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgHLBea (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgHLBea (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 854E2206B2;
        Wed, 12 Aug 2020 01:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196069;
        bh=n3akit/kS5Ki7INVqk0MzU8of1pDmKLYQp0MI3SprD8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FDXauKdYbndztCxrzvOrb80z4p+jFEzdSW0t5MUGRXl7OuadNV3U+1mJ7BeLJU+jL
         Goq3RinOPckOc8EH6qQFLtZqDDWM4/ZXDhW/9G0y9yG9y0xS+G3SEqNtqcTwunobPt
         bJK+oxrldcpmnsQmuDk2jd2p+Llz869G+b7EHoEM=
Date:   Tue, 11 Aug 2020 18:34:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, pablo@netfilter.org,
        sbrivio@redhat.com, torvalds@linux-foundation.org,
        yury.norov@gmail.com
Subject:  [patch 080/165] lib/bitmap.c: fix bitmap_cut() for
 partial overlapping case
Message-ID: <20200812013429.C42K7Ccjw%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Subject: lib/bitmap.c: fix bitmap_cut() for partial overlapping case

Patch series "lib: Fix bitmap_cut() for overlaps, add test"


This patch (of 2):

Yury Norov reports that bitmap_cut() will not produce the right outcome if
src and dst partially overlap, with src pointing at some location after
dst, because the memmove() affects src before we store the bits that we
need to keep, that is, the bits preceding the cut -- as long as we the
beginning of the cut is not aligned to a long.

Fix this by storing those bits before the memmove().

Note that this is just a theoretical concern so far, as the only user of
this function, pipapo_drop() from the nftables set back-end implemented in
net/netfilter/nft_set_pipapo.c, always supplies entirely overlapping src
and dst.

Link: http://lkml.kernel.org/r/cover.1592155364.git.sbrivio@redhat.com
Link: http://lkml.kernel.org/r/003e38d4428cd6091ef00b5b03354f1bd7d9091e.1592155364.git.sbrivio@redhat.com
Fixes: 2092767168f0 ("bitmap: Introduce bitmap_cut(): cut bits and shift remaining")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Reported-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/bitmap.c~bitmap-fix-bitmap_cut-for-partial-overlapping-case
+++ a/lib/bitmap.c
@@ -212,13 +212,13 @@ void bitmap_cut(unsigned long *dst, cons
 	unsigned long keep = 0, carry;
 	int i;
 
-	memmove(dst, src, len * sizeof(*dst));
-
 	if (first % BITS_PER_LONG) {
 		keep = src[first / BITS_PER_LONG] &
 		       (~0UL >> (BITS_PER_LONG - first % BITS_PER_LONG));
 	}
 
+	memmove(dst, src, len * sizeof(*dst));
+
 	while (cut--) {
 		for (i = first / BITS_PER_LONG; i < len; i++) {
 			if (i < len - 1)
_
