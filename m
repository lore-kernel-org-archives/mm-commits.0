Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C3DC43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CEFE61483
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhD3GBP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhD3GBM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ED8C6148E;
        Fri, 30 Apr 2021 06:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762422;
        bh=xDnPQk/EgYDX4dPLLMCy+no7XcCLPZoRFn2dl459wCY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rl8iqTYiEvum/Byy/9n1LCNh20eW5zOwaEAct2/9Rz/8YFU8FNBEbVXuX/cJ089hj
         Yi1lYOlIVOgLYqVuOz6oV7gr8kgsnEyBkR20RlnwfC9mTr1hQdlM5KyhTQerJaRXaY
         v/GfNOWe69VApmSfDNPL3O0JbTMzHo/CLauwTfmc=
Date:   Thu, 29 Apr 2021 23:00:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 139/178] kasan: docs: update error reports section
Message-ID: <20210430060021.Rfma7nv46%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: docs: update error reports section

Update the "Error reports" section in KASAN documentation:

- Mention that bug titles are best-effort.
- Move and reword the part about auxiliary stacks from
  "Implementation details".
- Punctuation, readability, and other minor clean-ups.

Link: https://lkml.kernel.org/r/3531e8fe6972cf39d1954e3643237b19eb21227e.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   46 +++++++++++++++-------------
 1 file changed, 26 insertions(+), 20 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-error-reports-section
+++ a/Documentation/dev-tools/kasan.rst
@@ -60,7 +60,7 @@ physical pages, enable ``CONFIG_PAGE_OWN
 Error reports
 ~~~~~~~~~~~~~
 
-A typical out-of-bounds access generic KASAN report looks like this::
+A typical KASAN report looks like this::
 
     ==================================================================
     BUG: KASAN: slab-out-of-bounds in kmalloc_oob_right+0xa8/0xbc [test_kasan]
@@ -133,33 +133,43 @@ A typical out-of-bounds access generic K
      ffff8801f44ec400: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
     ==================================================================
 
-The header of the report provides a short summary of what kind of bug happened
-and what kind of access caused it. It's followed by a stack trace of the bad
-access, a stack trace of where the accessed memory was allocated (in case bad
-access happens on a slab object), and a stack trace of where the object was
-freed (in case of a use-after-free bug report). Next comes a description of
-the accessed slab object and information about the accessed memory page.
+The report header summarizes what kind of bug happened and what kind of access
+caused it. It is followed by a stack trace of the bad access, a stack trace of
+where the accessed memory was allocated (in case a slab object was accessed),
+and a stack trace of where the object was freed (in case of a use-after-free
+bug report). Next comes a description of the accessed slab object and the
+information about the accessed memory page.
 
-In the last section the report shows memory state around the accessed address.
-Internally KASAN tracks memory state separately for each memory granule, which
+In the end, the report shows the memory state around the accessed address.
+Internally, KASAN tracks memory state separately for each memory granule, which
 is either 8 or 16 aligned bytes depending on KASAN mode. Each number in the
 memory state section of the report shows the state of one of the memory
 granules that surround the accessed address.
 
-For generic KASAN the size of each memory granule is 8. The state of each
+For generic KASAN, the size of each memory granule is 8. The state of each
 granule is encoded in one shadow byte. Those 8 bytes can be accessible,
-partially accessible, freed or be a part of a redzone. KASAN uses the following
-encoding for each shadow byte: 0 means that all 8 bytes of the corresponding
+partially accessible, freed, or be a part of a redzone. KASAN uses the following
+encoding for each shadow byte: 00 means that all 8 bytes of the corresponding
 memory region are accessible; number N (1 <= N <= 7) means that the first N
 bytes are accessible, and other (8 - N) bytes are not; any negative value
 indicates that the entire 8-byte word is inaccessible. KASAN uses different
 negative values to distinguish between different kinds of inaccessible memory
 like redzones or freed memory (see mm/kasan/kasan.h).
 
-In the report above the arrows point to the shadow byte 03, which means that
-the accessed address is partially accessible. For tag-based KASAN modes this
-last report section shows the memory tags around the accessed address
-(see the `Implementation details`_ section).
+In the report above, the arrow points to the shadow byte ``03``, which means
+that the accessed address is partially accessible.
+
+For tag-based KASAN modes, this last report section shows the memory tags around
+the accessed address (see the `Implementation details`_ section).
+
+Note that KASAN bug titles (like ``slab-out-of-bounds`` or ``use-after-free``)
+are best-effort: KASAN prints the most probable bug type based on the limited
+information it has. The actual type of the bug might be different.
+
+Generic KASAN also reports up to two auxiliary call stack traces. These stack
+traces point to places in code that interacted with the object but that are not
+directly present in the bad access stack trace. Currently, this includes
+call_rcu() and workqueue queuing.
 
 Boot parameters
 ~~~~~~~~~~~~~~~
@@ -223,10 +233,6 @@ function calls GCC directly inserts the
 This option significantly enlarges kernel but it gives x1.1-x2 performance
 boost over outline instrumented kernel.
 
-Generic KASAN also reports the last 2 call stacks to creation of work that
-potentially has access to an object. Call stacks for the following are shown:
-call_rcu() and workqueue queuing.
-
 Generic KASAN is the only mode that delays the reuse of freed object via
 quarantine (see mm/kasan/quarantine.c for implementation).
 
_
