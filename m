Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C80C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74B3022CB9
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbhAXFC2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Jan 2021 00:02:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbhAXFC1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 Jan 2021 00:02:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EEB722D0A;
        Sun, 24 Jan 2021 05:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611464491;
        bh=8sisABn7gSo+xcEawYIqH20q74qHvkB3s8ArZTq5WK0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Lo+HRAQfPyZCP6N/UuQy1TVi4hEkT2+G8Eb15MzACv80agOd1PhGRDSb4BpLfw2ZI
         2FI7Qw/Vzjn/6wn5qFvTqCuWRAtrZf1ytcBNvgHYMtZtbmRNP4VKJH00tOREEQdpHb
         36O393w43s7H4a+Y2D33HXTPHx6bYS4cfYGYIdFE=
Date:   Sat, 23 Jan 2021 21:01:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dan.j.williams@intel.com,
        dvyukov@google.com, glider@google.com, lecopzer.chen@mediatek.com,
        lecopzer@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 08/19] kasan: fix incorrect arguments passing in
 kasan_add_zero_shadow
Message-ID: <20210124050129.QK6ho8-jT%akpm@linux-foundation.org>
In-Reply-To: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lecopzer Chen <lecopzer@gmail.com>
Subject: kasan: fix incorrect arguments passing in kasan_add_zero_shadow

kasan_remove_zero_shadow() shall use original virtual address, start and
size, instead of shadow address.

Link: https://lkml.kernel.org/r/20210103063847.5963-1-lecopzer@gmail.com
Fixes: 0207df4fa1a86 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/kasan/init.c~kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow
+++ a/mm/kasan/init.c
@@ -486,7 +486,6 @@ int kasan_add_zero_shadow(void *start, u
 
 	ret = kasan_populate_early_shadow(shadow_start, shadow_end);
 	if (ret)
-		kasan_remove_zero_shadow(shadow_start,
-					size >> KASAN_SHADOW_SCALE_SHIFT);
+		kasan_remove_zero_shadow(start, size);
 	return ret;
 }
_
