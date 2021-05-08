Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCCCC43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57508613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWp1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWp0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:45:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E2596100C;
        Sat,  8 May 2021 22:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513864;
        bh=L2myNEOYLIReBC6uX1pSh2FJWHUhMXzNH5QRCvjH1w4=;
        h=Date:From:To:Subject:From;
        b=wk3p4EbtVqgEKvHV9RhT0TS9oHe3R4gx9kFqlq2wOCmzrWDXl10apd1DITz/5FBGB
         XFa8pJnlDiJUb5G97zvd/6zM30cyS2IrraIaYps2VF+0jL6nKlPdHMak6sp8jkPdHj
         HXIQq2L/sxYlrqhMRDPUDuwtCqymzwuDl9N55nh4=
Date:   Sat, 08 May 2021 15:44:24 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org
Subject:  [merged] kasan-docs-update-boot-parameters-section.patch
 removed from -mm tree
Message-ID: <20210508224424.3AttMP9M8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: docs: update boot parameters section
has been removed from the -mm tree.  Its filename was
     kasan-docs-update-boot-parameters-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: docs: update boot parameters section

Update the "Boot parameters" section in KASAN documentation:

- Mention panic_on_warn.
- Mention kasan_multi_shot and its interaction with panic_on_warn.
- Clarify kasan.fault=panic interaction with panic_on_warn.
- A readability clean-up.

Link: https://lkml.kernel.org/r/01364952f15789948f0627d6733b5cdf5209f83a.1615559068.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-docs-update-boot-parameters-section
+++ a/Documentation/dev-tools/kasan.rst
@@ -174,10 +174,16 @@ call_rcu() and workqueue queuing.
 Boot parameters
 ~~~~~~~~~~~~~~~
 
+KASAN is affected by the generic ``panic_on_warn`` command line parameter.
+When it is enabled, KASAN panics the kernel after printing a bug report.
+
+By default, KASAN prints a bug report only for the first invalid memory access.
+With ``kasan_multi_shot``, KASAN prints a report on every invalid access. This
+effectively disables ``panic_on_warn`` for KASAN reports.
+
 Hardware tag-based KASAN mode (see the section about various modes below) is
 intended for use in production as a security mitigation. Therefore, it supports
-boot parameters that allow to disable KASAN competely or otherwise control
-particular KASAN features.
+boot parameters that allow disabling KASAN or controlling its features.
 
 - ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
 
@@ -194,8 +200,8 @@ particular KASAN features.
   traces collection (default: ``on``).
 
 - ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
-  report or also panic the kernel (default: ``report``). Note, that tag
-  checking gets disabled after the first reported bug.
+  report or also panic the kernel (default: ``report``). The panic happens even
+  if ``kasan_multi_shot`` is enabled.
 
 Implementation details
 ----------------------
_

Patches currently in -mm which might be from andreyknvl@google.com are


