Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351A9C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8A3B23138
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbhASUYw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 15:24:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390364AbhASUYq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 15:24:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F04C23104;
        Tue, 19 Jan 2021 20:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611087845;
        bh=HEcpDnMalnLXsPFO3RFHTL9N/e3MTD1LwmL/5t515Xg=;
        h=Date:From:To:Subject:From;
        b=RZgodKmCGuLLsx7j2whJIkp8qmIJQ29WDJ8mi/GgbZHDpyYrzOYbWJRZQ9g3BkaAc
         xx2cl+8KvVqc9OeRwkQA2gggTPfcCxG5l7Z9bhtO0jVOKP9wozGBniJjMBSfklcR2I
         9oSxMqE9aClOTVGrgkETRlrrX61lajwlz2GQJk0w=
Date:   Tue, 19 Jan 2021 12:24:04 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org
Subject:  + mm-add-kernel-electric-fence-infrastructure-fix-5.patch
 added to -mm tree
Message-ID: <20210119202404.obe-0CVfI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: add missing copyright and description headers
has been added to the -mm tree.  Its filename is
     mm-add-kernel-electric-fence-infrastructure-fix-5.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-kernel-electric-fence-infrastructure-fix-5.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-kernel-electric-fence-infrastructure-fix-5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: add missing copyright and description headers

Add missing copyright and description headers to KFENCE source files.

Link: https://lkml.kernel.org/r/20210118092159.145934-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfence.h |    6 ++++++
 mm/kfence/core.c       |    5 +++++
 mm/kfence/kfence.h     |    6 ++++++
 mm/kfence/report.c     |    5 +++++
 4 files changed, 22 insertions(+)

--- a/include/linux/kfence.h~mm-add-kernel-electric-fence-infrastructure-fix-5
+++ a/include/linux/kfence.h
@@ -1,4 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Kernel Electric-Fence (KFENCE). Public interface for allocator and fault
+ * handler integration. For more info see Documentation/dev-tools/kfence.rst.
+ *
+ * Copyright (C) 2020, Google LLC.
+ */
 
 #ifndef _LINUX_KFENCE_H
 #define _LINUX_KFENCE_H
--- a/mm/kfence/core.c~mm-add-kernel-electric-fence-infrastructure-fix-5
+++ a/mm/kfence/core.c
@@ -1,4 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * KFENCE guarded object allocator and fault handling.
+ *
+ * Copyright (C) 2020, Google LLC.
+ */
 
 #define pr_fmt(fmt) "kfence: " fmt
 
--- a/mm/kfence/kfence.h~mm-add-kernel-electric-fence-infrastructure-fix-5
+++ a/mm/kfence/kfence.h
@@ -1,4 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Kernel Electric-Fence (KFENCE). For more info please see
+ * Documentation/dev-tools/kfence.rst.
+ *
+ * Copyright (C) 2020, Google LLC.
+ */
 
 #ifndef MM_KFENCE_KFENCE_H
 #define MM_KFENCE_KFENCE_H
--- a/mm/kfence/report.c~mm-add-kernel-electric-fence-infrastructure-fix-5
+++ a/mm/kfence/report.c
@@ -1,4 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * KFENCE reporting.
+ *
+ * Copyright (C) 2020, Google LLC.
+ */
 
 #include <stdarg.h>
 
_

Patches currently in -mm which might be from elver@google.com are

mm-add-kernel-electric-fence-infrastructure-fix.patch
mm-add-kernel-electric-fence-infrastructure-fix-2.patch
mm-add-kernel-electric-fence-infrastructure-fix-3.patch
mm-add-kernel-electric-fence-infrastructure-fix-4.patch
mm-add-kernel-electric-fence-infrastructure-fix-5.patch
x86-kfence-enable-kfence-for-x86-fix.patch
arm64-kfence-enable-kfence-for-arm64.patch
arm64-kfence-enable-kfence-for-arm64-fix.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-documentation-add-kfence-documentation-fix.patch
kfence-add-test-suite.patch
kfence-add-test-suite-fix.patch
kfence-add-test-suite-fix-2.patch
maintainers-add-entry-for-kfence.patch

