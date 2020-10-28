Return-Path: <SRS0=1Kf1=EE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C89C5517A
	for <mm-commits@archiver.kernel.org>; Thu, 29 Oct 2020 02:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17D8421D47
	for <mm-commits@archiver.kernel.org>; Thu, 29 Oct 2020 02:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603937143;
	bh=XM3Put0cslX1U3W6tP5qqX0oxEoxShjTAXqar1afeaE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gaperW0RhQ6nxIygpb74DzyG50k+YEalAwL9u8PxJHbKTq39c0dCzas2yJwCxqTWa
	 j65Z+QzmhaCidfSL8InwHaowAym61wGz/StYWNASl+u4GfXshHtuJB5T9hcDSg2Gth
	 TmgTGJaJ6XXtTmhs1OE0GpzyBuS66/sCU8/djkpc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgJ2CFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 22:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbgJ1ViY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 17:38:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCA8424680;
        Wed, 28 Oct 2020 21:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603921104;
        bh=XM3Put0cslX1U3W6tP5qqX0oxEoxShjTAXqar1afeaE=;
        h=Date:From:To:Subject:From;
        b=foPlFLaITVZRI+XuMk2o1ZWN5D0lfgBsid/Pi+QSRvxxr1w+P++x9T4ncatu0v2/8
         JQ9K9DT6TbVg0u/3rU/KdUWQt7vUX03xAOHeY5EUjcH2YZ4BEgilayexl5KO9ZnV7h
         hn/FUKW17OdldZXxc7WK9pAox6R++fSprAAcDqeo=
Date:   Wed, 28 Oct 2020 14:38:23 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, yury.norov@gmail.com
Subject:  +
 bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch added to
 -mm tree
Message-ID: <20201028213823.1XkJKvC6H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bitmap.h: convert bitmap_empty() / bitmap_full() to return boolean
has been added to the -mm tree.  Its filename is
     bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/bitmap.h: convert bitmap_empty() / bitmap_full() to return boolean

There is no need to return int type out of boolean expression.

Link: https://lkml.kernel.org/r/20201027180936.20806-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/bitmap.h~bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean
+++ a/include/linux/bitmap.h
@@ -379,7 +379,7 @@ static inline int bitmap_subset(const un
 		return __bitmap_subset(src1, src2, nbits);
 }
 
-static inline int bitmap_empty(const unsigned long *src, unsigned nbits)
+static inline bool bitmap_empty(const unsigned long *src, unsigned nbits)
 {
 	if (small_const_nbits(nbits))
 		return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
@@ -387,7 +387,7 @@ static inline int bitmap_empty(const uns
 	return find_first_bit(src, nbits) == nbits;
 }
 
-static inline int bitmap_full(const unsigned long *src, unsigned int nbits)
+static inline bool bitmap_full(const unsigned long *src, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return ! (~(*src) & BITMAP_LAST_WORD_MASK(nbits));
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-mathematical-helpers.patch
bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch

