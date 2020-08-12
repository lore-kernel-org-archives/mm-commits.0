Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7992C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A30BC207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266236;
	bh=Q24f0qs4KI/2BtGTXI+iVR20oWxOJnrHlSYRTU3HB/Y=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DEr645X77KI6ZsqxvLzGIEiIuUdogWy/8BiyKpWaXzjqTWMZqRszT7NSP0je4FjMT
	 QieopxuQUFK1WmqXPpV1j1Wg+dME06+AVVVkDJtREJ+WYPN1Lb7bkN14ZQ8XccBKYv
	 V+KYu6wbczwAWUdfv+hpxzl/vP7B3L9cnU+J0itM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgHLVD4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgHLVD4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9894120774;
        Wed, 12 Aug 2020 21:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266235;
        bh=Q24f0qs4KI/2BtGTXI+iVR20oWxOJnrHlSYRTU3HB/Y=;
        h=Date:From:To:Subject:From;
        b=IHgfAPLS7o0B6KqJkKs0whzG7/r/NYzjUbextyf8AUjPVoRSM0hGQwm3oOK+TyTNi
         TWVJ1gnVkOb6GVUUnvron9sZF/FjodFq1If4GahUqY0ZciyO1yYOKID0l2rtuyktcj
         NJaWCk7ciwX2zL5fUz9v+Xf3WtQI5zpReyT+Jm5E=
Date:   Wed, 12 Aug 2020 14:03:55 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, pablo@netfilter.org,
        sbrivio@redhat.com, yury.norov@gmail.com
Subject:  [merged]
 bitmap-fix-bitmap_cut-for-partial-overlapping-case.patch removed from -mm
 tree
Message-ID: <20200812210355.8bhGpW4TA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: fix bitmap_cut() for partial overlapping case
has been removed from the -mm tree.  Its filename was
     bitmap-fix-bitmap_cut-for-partial-overlapping-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sbrivio@redhat.com are


