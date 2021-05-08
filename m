Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F091C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2333661402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhEHWpi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhEHWpd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:45:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89F50613C5;
        Sat,  8 May 2021 22:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513870;
        bh=/G0kpeG3BpYT14ICUgPgFpH1o9zIENXIB1GABxeowMQ=;
        h=Date:From:To:Subject:From;
        b=p6k/CVlfKaeMF//cX7tRRZa0R63v2Z4u4DaI3suDPhBipllxVWtAhCpYagXPnwhkM
         yF+RucI9rcaw4L+ACtklZ8FnW7fw07U5N6LPfsRuTgOtPjY2WI0eCDpCfKrYqtMK3O
         FRijZrEcLhPqVrJV4pp8MMDywJaRm9/44pon8hIM=
Date:   Sat, 08 May 2021 15:44:30 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged]
 kasan-docs-update-hw_tags-implementation-details-section.patch removed from
 -mm tree
Message-ID: <20210508224430.JOxWxO_ZB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update HW_TAGS implementation details section
has been removed from the -mm tree.  Its filename was
     kasan-docs-update-hw_tags-implementation-details-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -279,35 +279,35 @@ memory.
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


