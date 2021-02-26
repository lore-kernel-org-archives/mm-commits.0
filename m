Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6FFC43381
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D624764F35
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhBZBWl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhBZBWQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4209B64F21;
        Fri, 26 Feb 2021 01:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302478;
        bh=E6Onz8b7748teRxbJX1mitClQ/q5sF49slCl0Tk/krs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DvfeOHnFSk5DhOuRLigtZdFtIf5p1lt4OV0RR/fl8rLfayXRxKLFHlDZ9a36OD4rv
         zB4zGi322pO86MoKFel/TmSc7kqsy7co8JeAY7tc1AKOlu82EVGcYgd4CIRfHPnNwY
         /+ccGy9zLCWuBMeKoWU4ZNzX/b2lZQ37dU8tY3zA=
Date:   Thu, 25 Feb 2021 17:21:17 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjhuang@iluvatar.ai,
        torvalds@linux-foundation.org
Subject:  [patch 092/118] lib/genalloc.c: change return type to
 unsigned long for bitmap_set_ll
Message-ID: <20210226012117.QK0oTujwY%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Huang Shijie <sjhuang@iluvatar.ai>
Subject: lib/genalloc.c: change return type to unsigned long for bitmap_set_ll

Just as bitmap_clear_ll(), change return type to unsigned long
for bitmap_set_ll to avoid the possible overflow in future.

Link: https://lkml.kernel.org/r/20210105031644.2771-1-sjhuang@iluvatar.ai
Signed-off-by: Huang Shijie <sjhuang@iluvatar.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/genalloc.c~lib-genalloc-change-return-type-to-unsigned-long-for-bitmap_set_ll
+++ a/lib/genalloc.c
@@ -81,7 +81,8 @@ static int clear_bits_ll(unsigned long *
  * users set the same bit, one user will return remain bits, otherwise
  * return 0.
  */
-static int bitmap_set_ll(unsigned long *map, unsigned long start, unsigned long nr)
+static unsigned long
+bitmap_set_ll(unsigned long *map, unsigned long start, unsigned long nr)
 {
 	unsigned long *p = map + BIT_WORD(start);
 	const unsigned long size = start + nr;
_
