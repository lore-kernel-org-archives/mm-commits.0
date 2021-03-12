Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8E5C4332E
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0482064F78
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhCLSgj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:36:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233841AbhCLSgO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 13:36:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7CC064F66;
        Fri, 12 Mar 2021 18:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615574174;
        bh=79lehbSqnqqok25wQOe4JeHIgMtWjG8MZM2lllvM0Lg=;
        h=Date:From:To:Subject:From;
        b=reCjW8sMbINi4yv2TjQhVxLxf4Ealv4FdvKAoRjHdiaYRKTbvd7RMtuB3eawUj41Q
         DLmJsdHTNuIXxbFbysQf1A0l9+fgUiNZ7VHwg+ClLKWiNDjb/KQ7l9ULJVU3fBeOC/
         F+57hWTNhLJ6Fx1ihH7t2bJ+zF9wka8aszRQho6w=
Date:   Fri, 12 Mar 2021 10:36:13 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  +
 kasan-docs-update-hw_tags-implementation-details-section.patch added to -mm
 tree
Message-ID: <20210312183613.MvO_2_qEX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update HW_TAGS implementation details section
has been added to the -mm tree.  Its filename is
     kasan-docs-update-hw_tags-implementation-details-section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-docs-update-hw_tags-implementation-details-section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-docs-update-hw_tags-implementation-details-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: docs: update HW_TAGS implementation details section

Update the "Implementation details" section for HW_TAGS KASAN:

- Punctuation, readability, and other minor clean-ups.

Link: https://lkml.kernel.org/r/ee2caf4c138cc1fd239822c2abefd5af6c057744.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-hw_tags-implementation-details-section
+++ a/Documentation/dev-tools/kasan.rst
@@ -270,35 +270,35 @@ memory.
 Hardware tag-based KASAN
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
-Hardware tag-based KASAN is similar to the software mode in concept, but uses
+Hardware tag-based KASAN is similar to the software mode in concept but uses
 hardware memory tagging support instead of compiler instrumentation and
 shadow memory.
 
 Hardware tag-based KASAN is currently only implemented for arm64 architecture
 and based on both arm64 Memory Tagging Extension (MTE) introduced in ARMv8.5
-Instruction Set Architecture, and Top Byte Ignore (TBI).
+Instruction Set Architecture and Top Byte Ignore (TBI).
 
 Special arm64 instructions are used to assign memory tags for each allocation.
 Same tags are assigned to pointers to those allocations. On every memory
-access, hardware makes sure that tag of the memory that is being accessed is
-equal to tag of the pointer that is used to access this memory. In case of a
-tag mismatch a fault is generated and a report is printed.
+access, hardware makes sure that the tag of the memory that is being accessed is
+equal to the tag of the pointer that is used to access this memory. In case of a
+tag mismatch, a fault is generated, and a report is printed.
 
 Hardware tag-based KASAN uses 0xFF as a match-all pointer tag (accesses through
-pointers with 0xFF pointer tag aren't checked). The value 0xFE is currently
+pointers with the 0xFF pointer tag are not checked). The value 0xFE is currently
 reserved to tag freed memory regions.
 
-Hardware tag-based KASAN currently only supports tagging of
-kmem_cache_alloc/kmalloc and page_alloc memory.
+Hardware tag-based KASAN currently only supports tagging of slab and page_alloc
+memory.
 
-If the hardware doesn't support MTE (pre ARMv8.5), hardware tag-based KASAN
-won't be enabled. In this case all boot parameters are ignored.
+If the hardware does not support MTE (pre ARMv8.5), hardware tag-based KASAN
+will not be enabled. In this case, all KASAN boot parameters are ignored.
 
-Note, that enabling CONFIG_KASAN_HW_TAGS always results in in-kernel TBI being
-enabled. Even when kasan.mode=off is provided, or when the hardware doesn't
+Note that enabling CONFIG_KASAN_HW_TAGS always results in in-kernel TBI being
+enabled. Even when ``kasan.mode=off`` is provided or when the hardware does not
 support MTE (but supports TBI).
 
-Hardware tag-based KASAN only reports the first found bug. After that MTE tag
+Hardware tag-based KASAN only reports the first found bug. After that, MTE tag
 checking gets disabled.
 
 Shadow memory
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch
kasan-fix-kasan_stack-dependency-for-hw_tags.patch
kasan-fix-per-page-tags-for-non-page_alloc-pages.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_free-with-hw_tags.patch
kasan-docs-clean-up-sections.patch
kasan-docs-update-overview-section.patch
kasan-docs-update-usage-section.patch
kasan-docs-update-error-reports-section.patch
kasan-docs-update-boot-parameters-section.patch
kasan-docs-update-generic-implementation-details-section.patch
kasan-docs-update-sw_tags-implementation-details-section.patch
kasan-docs-update-hw_tags-implementation-details-section.patch
kasan-docs-update-shadow-memory-section.patch
kasan-docs-update-ignoring-accesses-section.patch
kasan-docs-update-tests-section.patch

