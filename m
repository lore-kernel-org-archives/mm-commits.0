Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5F3C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FE7F61483
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhD3GBQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230326AbhD3GBN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C3226147E;
        Fri, 30 Apr 2021 06:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762425;
        bh=yYyjM1gx3YPkkoyq1XFB/4PjlVjd7cWZ6bxnz6ngS3c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=chuqCoIiu9HoyEDfRQidykRWvZohbZGMmV9v5kyJ9W0ODBbitnns1P88MQ/wX9VMG
         ql4CG0ZF86xY0aAIWVwiDtlgpdeKY+p2cOOHao2wZO6U3zoOaANlelquGPl5h7HhED
         WdmTYncRemv2nJIBDQti5YRPAz1gl7F0MU7A4Vr8=
Date:   Thu, 29 Apr 2021 23:00:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 140/178] kasan: docs: update boot parameters
 section
Message-ID: <20210430060024.6yRWN_SCu%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
