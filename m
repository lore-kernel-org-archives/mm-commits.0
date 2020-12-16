Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D327C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5872C233FE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgLPRJh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:09:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbgLPRJg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:09:36 -0500
Date:   Wed, 16 Dec 2020 09:08:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138519;
        bh=fOO8Fc1IIxwF1l3OLCGA3u3wyLPpL09n6ngfkPy9Ung=;
        h=From:To:Subject:From;
        b=c1OS60YxVq6W6X7NdgYCKteApFwIXy3Uf8tedZOnxo/vCkExjEhwEx/b8CztwGo3u
         KjFXHhQvrkLH4X28X28H9Ari7PSqkNDzg2445CoU5+PcE8wTLo2CHJ8ZrXePWIuBAW
         t/F7NdcdgbB6T+TWsWTD7lCdODeB0xRDRapeLw3k=
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, yury.norov@gmail.com
Subject:  [merged]
 bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch removed
 from -mm tree
Message-ID: <20201216170839.cYyMbB-mH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bitmap.h: convert bitmap_empty() / bitmap_full() to return boolean
has been removed from the -mm tree.  Its filename was
     bitmap-convert-bitmap_empty-bitmap_full-to-return-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


