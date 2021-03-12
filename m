Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF0AAC433E6
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EA3664F69
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhCLSgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233580AbhCLSgD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 13:36:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAC7D64F5D;
        Fri, 12 Mar 2021 18:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615574163;
        bh=9QWcwIt7hzwjaQ+pyHyKaKuM4zibdESwvuIleH2y/jY=;
        h=Date:From:To:Subject:From;
        b=HeUiAqrb75hHjT7OBUVzhNTuzcG0U8Q/Don69peaJ59frBwLXWqo3LiH5HvNcPhDP
         MZtNG0JpWD708rTV6OBAHpgbYgcDq86ktI5q0WP1ZJOl9oZd+NouIvJ6iCCbBlUAj6
         4TzU1x2KPpvK9Tgm6/5OMuG2XR+taHG4WGxiEYh8=
Date:   Fri, 12 Mar 2021 10:36:02 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  + kasan-docs-update-usage-section.patch added to -mm tree
Message-ID: <20210312183602.TasUy-GHt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update usage section
has been added to the -mm tree.  Its filename is
     kasan-docs-update-usage-section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-docs-update-usage-section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-docs-update-usage-section.patch

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

