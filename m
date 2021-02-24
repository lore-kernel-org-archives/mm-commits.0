Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4C5C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9984864F0E
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbhBXUHi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:07:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235242AbhBXUG6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:06:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82C8364F3A;
        Wed, 24 Feb 2021 20:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197196;
        bh=S0oS6KcS8t0bMJvL3VnGBGEPzhOsu8h+HkMYXUqvW2Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TE75duOwfU7grRNPC5L5rn88ZXXmNTHGlKwSw2RYcogd+nCWEY+ehZ84wp2h+5OuK
         5HulX7QCutHP7ZAtOlk0qypcGFstnZIuK/vqDYUwgOuMm418CvOEV4qmZmPhyAqUVw
         NZazUqx6XOjZjVhjqUFLyFrr8+uOYBhyu8/due/s=
Date:   Wed, 24 Feb 2021 12:06:35 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nathan@kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 109/173] mm/gfp: add kernel-doc for gfp_t
Message-ID: <20210224200635.7ADCBJmnK%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/gfp: add kernel-doc for gfp_t

The generated html will link to the definition of the gfp_t automatically
once we define it.  Move the one-paragraph overview of GFP flags from the
documentation directory into gfp.h and pull gfp.h into the documentation.

This generates warnings with clang
(https://lkml.kernel.org/r/20210219195509.GA59987@24bbad8f3778), so
use a #if 0 to hide it from the compiler for now.

Link: https://lkml.kernel.org/r/20210215204909.3824509-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20210220003049.GZ2858050@casper.infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    7 ++-----
 include/linux/gfp.h               |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/Documentation/core-api/mm-api.rst~mm-gfp-add-kernel-doc-for-gfp_t
+++ a/Documentation/core-api/mm-api.rst
@@ -19,11 +19,8 @@ User Space Memory Access
 Memory Allocation Controls
 ==========================
 
-Functions which need to allocate memory often use GFP flags to express
-how that memory should be allocated. The GFP acronym stands for "get
-free pages", the underlying memory allocation function. Not every GFP
-flag is allowed to every function which may allocate memory. Most
-users will want to use a plain ``GFP_KERNEL``.
+.. kernel-doc:: include/linux/gfp.h
+   :internal:
 
 .. kernel-doc:: include/linux/gfp.h
    :doc: Page mobility and placement hints
--- a/include/linux/gfp.h~mm-gfp-add-kernel-doc-for-gfp_t
+++ a/include/linux/gfp.h
@@ -8,6 +8,20 @@
 #include <linux/linkage.h>
 #include <linux/topology.h>
 
+/* The typedef is in types.h but we want the documentation here */
+#if 0
+/**
+ * typedef gfp_t - Memory allocation flags.
+ *
+ * GFP flags are commonly used throughout Linux to indicate how memory
+ * should be allocated.  The GFP acronym stands for get_free_pages(),
+ * the underlying memory allocation function.  Not every GFP flag is
+ * supported by every function which may allocate memory.  Most users
+ * will want to use a plain ``GFP_KERNEL``.
+ */
+typedef unsigned int __bitwise gfp_t;
+#endif
+
 struct vm_area_struct;
 
 /*
_
