Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D58C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09F2061463
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhD3GBZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230119AbhD3GBU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E12061483;
        Fri, 30 Apr 2021 06:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762431;
        bh=jgzE2tiDa0wNCXApx8yiciaIhVNbwBPAlmZWAl/VHvo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hcg36hl28qaG2AaNl5nkxTCFvFPU+GIzptWeG0fuwJEDLBE75x7FiICzhLNSDgt1k
         06tkeyj48iK2La0pDBZnu8axQcHcEtICTdJZqYZ95YF3FmEOtEo2CleNOq+qrEkf1y
         juO87HRb4fcirYwLnjSHtYFiIIcqApr30QzpWtDw=
Date:   Thu, 29 Apr 2021 23:00:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 142/178] kasan: docs: update SW_TAGS
 implementation details section
Message-ID: <20210430060030.KyTAlZGoD%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: docs: update SW_TAGS implementation details section

Update the "Implementation details" section for SW_TAGS KASAN:

- Clarify the introduction sentence.
- Punctuation, readability, and other minor clean-ups.

Link: https://lkml.kernel.org/r/69b9b2e49d8cf789358fa24558be3fc0ce4ee32c.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   39 +++++++++++++---------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-sw_tags-implementation-details-section
+++ a/Documentation/dev-tools/kasan.rst
@@ -244,38 +244,37 @@ quarantine (see mm/kasan/quarantine.c fo
 Software tag-based KASAN
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
-Software tag-based KASAN requires software memory tagging support in the form
-of HWASan-like compiler instrumentation (see HWASan documentation for details).
-
-Software tag-based KASAN is currently only implemented for arm64 architecture.
+Software tag-based KASAN uses a software memory tagging approach to checking
+access validity. It is currently only implemented for the arm64 architecture.
 
 Software tag-based KASAN uses the Top Byte Ignore (TBI) feature of arm64 CPUs
-to store a pointer tag in the top byte of kernel pointers. Like generic KASAN
-it uses shadow memory to store memory tags associated with each 16-byte memory
-cell (therefore it dedicates 1/16th of the kernel memory for shadow memory).
+to store a pointer tag in the top byte of kernel pointers. It uses shadow memory
+to store memory tags associated with each 16-byte memory cell (therefore, it
+dedicates 1/16th of the kernel memory for shadow memory).
 
-On each memory allocation software tag-based KASAN generates a random tag, tags
-the allocated memory with this tag, and embeds this tag into the returned
+On each memory allocation, software tag-based KASAN generates a random tag, tags
+the allocated memory with this tag, and embeds the same tag into the returned
 pointer.
 
 Software tag-based KASAN uses compile-time instrumentation to insert checks
-before each memory access. These checks make sure that tag of the memory that
-is being accessed is equal to tag of the pointer that is used to access this
-memory. In case of a tag mismatch software tag-based KASAN prints a bug report.
+before each memory access. These checks make sure that the tag of the memory
+that is being accessed is equal to the tag of the pointer that is used to access
+this memory. In case of a tag mismatch, software tag-based KASAN prints a bug
+report.
 
-Software tag-based KASAN also has two instrumentation modes (outline, that
-emits callbacks to check memory accesses; and inline, that performs the shadow
+Software tag-based KASAN also has two instrumentation modes (outline, which
+emits callbacks to check memory accesses; and inline, which performs the shadow
 memory checks inline). With outline instrumentation mode, a bug report is
-simply printed from the function that performs the access check. With inline
-instrumentation a brk instruction is emitted by the compiler, and a dedicated
-brk handler is used to print bug reports.
+printed from the function that performs the access check. With inline
+instrumentation, a ``brk`` instruction is emitted by the compiler, and a
+dedicated ``brk`` handler is used to print bug reports.
 
 Software tag-based KASAN uses 0xFF as a match-all pointer tag (accesses through
-pointers with 0xFF pointer tag aren't checked). The value 0xFE is currently
+pointers with the 0xFF pointer tag are not checked). The value 0xFE is currently
 reserved to tag freed memory regions.
 
-Software tag-based KASAN currently only supports tagging of
-kmem_cache_alloc/kmalloc and page_alloc memory.
+Software tag-based KASAN currently only supports tagging of slab and page_alloc
+memory.
 
 Hardware tag-based KASAN
 ~~~~~~~~~~~~~~~~~~~~~~~~
_
