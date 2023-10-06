Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A039E94108
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjJFTSG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbjJFTSF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:18:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D06095
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:18:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E117C433C9;
        Fri,  6 Oct 2023 19:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619882;
        bh=8Y5TJXdrb/ydbopOJvTWOk0b4Qd65f8CZ+xE0YaKNxI=;
        h=Date:To:From:Subject:From;
        b=k2VZXGgfxNXavFuINYbW1oIL7botg+PLGP+SYnK4De/NxH/QpPvaG2jkaXGjWqv5S
         lvM/517E+UxxFYb1RPuExxGIA2SPHVcK6IvfQ34nE0PTqDRIT8Vb5BtOwC592q9m7W
         f+hFKrUUw3X/TaXgwL+ayH1AIDnN51Yckrx+NcJM=
Date:   Fri, 06 Oct 2023 12:18:00 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-san-drop-the-from-article-titles.patch added to mm-unstable branch
Message-Id: <20231006191802.8E117C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: *san: drop "the" from article titles
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-san-drop-the-from-article-titles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-san-drop-the-from-article-titles.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: Documentation: *san: drop "the" from article titles
Date: Fri, 6 Oct 2023 17:18:46 +0200

Drop "the" from the titles of documentation articles for KASAN, KCSAN,
and KMSAN, as it is redundant.

Also add SPDX-License-Identifier for kasan.rst.

Link: https://lkml.kernel.org/r/1c4eb354a3a7b8ab56bf0c2fc6157c22050793ca.1696605143.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    7 +++++--
 Documentation/dev-tools/kcsan.rst |    4 ++--
 Documentation/dev-tools/kmsan.rst |    6 +++---
 3 files changed, 10 insertions(+), 7 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~documentation-san-drop-the-from-article-titles
+++ a/Documentation/dev-tools/kasan.rst
@@ -1,5 +1,8 @@
-The Kernel Address Sanitizer (KASAN)
-====================================
+.. SPDX-License-Identifier: GPL-2.0
+.. Copyright (C) 2023, Google LLC.
+
+Kernel Address Sanitizer (KASAN)
+================================
 
 Overview
 --------
--- a/Documentation/dev-tools/kcsan.rst~documentation-san-drop-the-from-article-titles
+++ a/Documentation/dev-tools/kcsan.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 .. Copyright (C) 2019, Google LLC.
 
-The Kernel Concurrency Sanitizer (KCSAN)
-========================================
+Kernel Concurrency Sanitizer (KCSAN)
+====================================
 
 The Kernel Concurrency Sanitizer (KCSAN) is a dynamic race detector, which
 relies on compile-time instrumentation, and uses a watchpoint-based sampling
--- a/Documentation/dev-tools/kmsan.rst~documentation-san-drop-the-from-article-titles
+++ a/Documentation/dev-tools/kmsan.rst
@@ -1,9 +1,9 @@
 .. SPDX-License-Identifier: GPL-2.0
 .. Copyright (C) 2022, Google LLC.
 
-===================================
-The Kernel Memory Sanitizer (KMSAN)
-===================================
+===============================
+Kernel Memory Sanitizer (KMSAN)
+===============================
 
 KMSAN is a dynamic error detector aimed at finding uses of uninitialized
 values. It is based on compiler instrumentation, and is quite similar to the
_

Patches currently in -mm which might be from andreyknvl@google.com are

arm64-kasan-update-comment-in-kasan_init.patch
kasan-unify-printk-prefixes.patch
kasan-use-unchecked-__memset-internally.patch
kasan-fix-and-update-kunit_expect_kasan_fail-comment.patch
documentation-san-drop-the-from-article-titles.patch

