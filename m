Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9325AC433E0
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65C1322CB2
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 05:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbhAXFCp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Jan 2021 00:02:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbhAXFCd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 Jan 2021 00:02:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A34522D37;
        Sun, 24 Jan 2021 05:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611464506;
        bh=yKNN4Z5OscCqwPYjf8+qmsc/A/D8Skjewqd9GATmXlg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=m9RponltuKB+Zwq+BDrDUQIhyC0fvQwQnX0h4wtXGNT3TlZ8+c9hn1Uou0BF5D0kl
         NTjWEA0xxDHIXa/LVBHTeGXZA41MWuV1nVUkxzzmNLNRoWI8WnvpOod9wO0R6o/xfj
         q2qvSL0M2wpugJvl54bq9jeji1JzrqSNJhZlNGvE=
Date:   Sat, 23 Jan 2021 21:01:43 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [patch 11/19] kasan, mm: fix resetting page_alloc tags
 for HW_TAGS
Message-ID: <20210124050143.UF-3I8lr9%akpm@linux-foundation.org>
In-Reply-To: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: fix resetting page_alloc tags for HW_TAGS

A previous commit added resetting KASAN page tags to
kernel_init_free_pages() to avoid false-positives due to accesses to
metadata with the hardware tag-based mode.

That commit did reset page tags before the metadata access, but didn't
restore them after.  As the result, KASAN fails to detect bad accesses to
page_alloc allocations on some configurations.

Fix this by recovering the tag after the metadata access.

Link: https://lkml.kernel.org/r/02b5bcd692e912c27d484030f666b350ad7e4ae4.1611074450.git.andreyknvl@google.com
Fixes: aa1ef4d7b3f6 ("kasan, mm: reset tags when accessing metadata")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~kasan-mm-fix-resetting-page_alloc-tags-for-hw_tags
+++ a/mm/page_alloc.c
@@ -1207,8 +1207,10 @@ static void kernel_init_free_pages(struc
 	/* s390's use of memset() could override KASAN redzones. */
 	kasan_disable_current();
 	for (i = 0; i < numpages; i++) {
+		u8 tag = page_kasan_tag(page + i);
 		page_kasan_tag_reset(page + i);
 		clear_highpage(page + i);
+		page_kasan_tag_set(page + i, tag);
 	}
 	kasan_enable_current();
 }
_
