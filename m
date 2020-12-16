Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FFFC2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D5472333E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbgLPEnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgLPEnu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:50 -0500
Date:   Tue, 15 Dec 2020 20:42:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093775;
        bh=JJ5Sg2ZI07dCtq7Yvrcnj0FXYAYYX7UngAd43G6UgMc=;
        h=From:To:Subject:In-Reply-To:From;
        b=IYKc8g+50te+cNQTPa8qTmojp8gybDjf/AwmaE38sdFXj0gFFlWceHU79JpFeimZq
         ObDtvnka0yBoymuaPH/fGAEOzSjZCwQ41swzxnkLE7Lqgy6SWDs7KJcXv7PXVGrtyV
         buleSCbztHrB/0b4Te+L8CkCvG7RanilY3T2YlN0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yury.norov@gmail.com
Subject:  [patch 11/95] include/linux/bitmap.h: convert
 bitmap_empty() / bitmap_full() to return boolean
Message-ID: <20201216044255._1-vHYtj0%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
