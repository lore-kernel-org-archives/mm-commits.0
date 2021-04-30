Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F6AC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADCCE61483
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhD3GBP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhD3GBI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32B0361481;
        Fri, 30 Apr 2021 06:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762419;
        bh=jzYxBHCg7kOCgTAW3HPr+vjwBOtU6PGok6gJGTeE0xs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gBdnBQq7n3b++0+2wl//+nKlme6rKvudbo2/7Nb+u4TRxV/tkPggoyj2EbeJcXf2+
         58BBctKepXaRcHwOZALz4z6UujVdka2SxDFEYXndhA7/CTMK6JGUSJRLkka4zWDYbc
         OY+lJ0/P6zPQ412TIBFpo38cCWKG2SCNziaBbFL4=
Date:   Thu, 29 Apr 2021 23:00:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 138/178] kasan: docs: update usage section
Message-ID: <20210430060018.MvhAEvhJ-%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: docs: update usage section

Update the "Usage" section in KASAN documentation:

- Add inline code snippet markers.
- Reword the part about stack traces for clarity.
- Other minor clean-ups.

Link: https://lkml.kernel.org/r/48427809cd4b8b5d6bc00926cbe87e2b5081df17.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-usage-section
+++ a/Documentation/dev-tools/kasan.rst
@@ -41,22 +41,21 @@ and riscv architectures, and tag-based K
 Usage
 -----
 
-To enable KASAN configure kernel with::
+To enable KASAN, configure the kernel with::
 
-	  CONFIG_KASAN = y
+	  CONFIG_KASAN=y
 
-and choose between CONFIG_KASAN_GENERIC (to enable generic KASAN),
-CONFIG_KASAN_SW_TAGS (to enable software tag-based KASAN), and
-CONFIG_KASAN_HW_TAGS (to enable hardware tag-based KASAN).
+and choose between ``CONFIG_KASAN_GENERIC`` (to enable generic KASAN),
+``CONFIG_KASAN_SW_TAGS`` (to enable software tag-based KASAN), and
+``CONFIG_KASAN_HW_TAGS`` (to enable hardware tag-based KASAN).
 
-For software modes, you also need to choose between CONFIG_KASAN_OUTLINE and
-CONFIG_KASAN_INLINE. Outline and inline are compiler instrumentation types.
-The former produces smaller binary while the latter is 1.1 - 2 times faster.
+For software modes, also choose between ``CONFIG_KASAN_OUTLINE`` and
+``CONFIG_KASAN_INLINE``. Outline and inline are compiler instrumentation types.
+The former produces a smaller binary while the latter is 1.1-2 times faster.
 
-For better error reports that include stack traces, enable CONFIG_STACKTRACE.
-
-To augment reports with last allocation and freeing stack of the physical page,
-it is recommended to enable also CONFIG_PAGE_OWNER and boot with page_owner=on.
+To include alloc and free stack traces of affected slab objects into reports,
+enable ``CONFIG_STACKTRACE``. To include alloc and free stack traces of affected
+physical pages, enable ``CONFIG_PAGE_OWNER`` and boot with ``page_owner=on``.
 
 Error reports
 ~~~~~~~~~~~~~
_
