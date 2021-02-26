Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E1DC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AFAD60202
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhBZAow (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:32896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232138AbhBZAoo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:44:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B445864F2B;
        Fri, 26 Feb 2021 00:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300244;
        bh=y4es54+X8DGVRpZ0ceg9K4nTHsXB4xjcW9v9tkF4cJo=;
        h=Date:From:To:Subject:From;
        b=l54vYLnmMil8HCgR/L6kkU0mo2XhxmBmHKFHBx0MAiFdq+X4N+hY5ldJmeAmAnz4c
         Gx1PR4kn5TvGfv2BdcU0v8PDo1GFm8UhCRONN47Sx6RmUB52pQaYO5bTL/pjswnrYw
         13LFmzUxI36iVQKOk3F8LlUmTCtMeccRTs56V52M=
Date:   Thu, 25 Feb 2021 16:44:03 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-add-kernel-electric-fence-infrastructure-fix-5.patch removed from -mm
 tree
Message-ID: <20210226004403.tQ9VLRlFc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: add missing copyright and description headers
has been removed from the -mm tree.  Its filename was
     mm-add-kernel-electric-fence-infrastructure-fix-5.patch

This patch was dropped because it was folded into mm-add-kernel-electric-fence-infrastructure.patch

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

mm-add-kernel-electric-fence-infrastructure.patch
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
kfence-report-sensitive-information-based-on-no_hash_pointers.patch

