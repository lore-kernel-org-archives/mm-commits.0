Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D604C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 20:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiEIUYo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 16:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiEIUYg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 16:24:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BED24DC5E
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 13:08:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9B7D616D2
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 20:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AD6C385B6;
        Mon,  9 May 2022 20:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652126883;
        bh=5ORuPD3vyIX1uPKaUrps5eBKLLyxSDMtGpH6/z7LGNE=;
        h=Date:To:From:Subject:From;
        b=zob6inWlvLRZh2yctKeX6RJujW7GDzMevoKeq9bmILBVwtlpRrJquueAWfjX4FdTa
         Nlrx+n61BUUCCIYnTnUnoetHkux2yDBTkg6NDL8J6ZeVtEGIsMbPPYVoYsHJiDqEa9
         Y6vDzaMpa2s26CliJXiIqtQtKlZ9R220Vyr92SsI=
Date:   Mon, 09 May 2022 13:08:02 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-move-boot-parameters-section-in-documentation.patch added to mm-unstable branch
Message-Id: <20220509200803.26AD6C385B6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move boot parameters section in documentation
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-move-boot-parameters-section-in-documentation.patch

This patch should soon appear in the mm-unstable branch at
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
Subject: kasan: move boot parameters section in documentation

Move the "Boot parameters" section in KASAN documentation next to the
section that describes KASAN build options.

No content changes.

Link: https://lkml.kernel.org/r/ec9c923f35e7c5312836c4624a7f317dc1ee2c1c.1652123204.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |   82 ++++++++++++++--------------
 1 file changed, 41 insertions(+), 41 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-move-boot-parameters-section-in-documentation
+++ a/Documentation/dev-tools/kasan.rst
@@ -94,6 +94,47 @@ To include alloc and free stack traces o
 enable ``CONFIG_STACKTRACE``. To include alloc and free stack traces of affected
 physical pages, enable ``CONFIG_PAGE_OWNER`` and boot with ``page_owner=on``.
 
+Boot parameters
+~~~~~~~~~~~~~~~
+
+KASAN is affected by the generic ``panic_on_warn`` command line parameter.
+When it is enabled, KASAN panics the kernel after printing a bug report.
+
+By default, KASAN prints a bug report only for the first invalid memory access.
+With ``kasan_multi_shot``, KASAN prints a report on every invalid access. This
+effectively disables ``panic_on_warn`` for KASAN reports.
+
+Alternatively, independent of ``panic_on_warn``, the ``kasan.fault=`` boot
+parameter can be used to control panic and reporting behaviour:
+
+- ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
+  report or also panic the kernel (default: ``report``). The panic happens even
+  if ``kasan_multi_shot`` is enabled.
+
+Hardware Tag-Based KASAN mode (see the section about various modes below) is
+intended for use in production as a security mitigation. Therefore, it supports
+additional boot parameters that allow disabling KASAN or controlling features:
+
+- ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
+
+- ``kasan.mode=sync``, ``=async`` or ``=asymm`` controls whether KASAN
+  is configured in synchronous, asynchronous or asymmetric mode of
+  execution (default: ``sync``).
+  Synchronous mode: a bad access is detected immediately when a tag
+  check fault occurs.
+  Asynchronous mode: a bad access detection is delayed. When a tag check
+  fault occurs, the information is stored in hardware (in the TFSR_EL1
+  register for arm64). The kernel periodically checks the hardware and
+  only reports tag faults during these checks.
+  Asymmetric mode: a bad access is detected synchronously on reads and
+  asynchronously on writes.
+
+- ``kasan.vmalloc=off`` or ``=on`` disables or enables tagging of vmalloc
+  allocations (default: ``on``).
+
+- ``kasan.stacktrace=off`` or ``=on`` disables or enables alloc and free stack
+  traces collection (default: ``on``).
+
 Error reports
 ~~~~~~~~~~~~~
 
@@ -208,47 +249,6 @@ traces point to places in code that inte
 directly present in the bad access stack trace. Currently, this includes
 call_rcu() and workqueue queuing.
 
-Boot parameters
-~~~~~~~~~~~~~~~
-
-KASAN is affected by the generic ``panic_on_warn`` command line parameter.
-When it is enabled, KASAN panics the kernel after printing a bug report.
-
-By default, KASAN prints a bug report only for the first invalid memory access.
-With ``kasan_multi_shot``, KASAN prints a report on every invalid access. This
-effectively disables ``panic_on_warn`` for KASAN reports.
-
-Alternatively, independent of ``panic_on_warn``, the ``kasan.fault=`` boot
-parameter can be used to control panic and reporting behaviour:
-
-- ``kasan.fault=report`` or ``=panic`` controls whether to only print a KASAN
-  report or also panic the kernel (default: ``report``). The panic happens even
-  if ``kasan_multi_shot`` is enabled.
-
-Hardware Tag-Based KASAN mode (see the section about various modes below) is
-intended for use in production as a security mitigation. Therefore, it supports
-additional boot parameters that allow disabling KASAN or controlling features:
-
-- ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
-
-- ``kasan.mode=sync``, ``=async`` or ``=asymm`` controls whether KASAN
-  is configured in synchronous, asynchronous or asymmetric mode of
-  execution (default: ``sync``).
-  Synchronous mode: a bad access is detected immediately when a tag
-  check fault occurs.
-  Asynchronous mode: a bad access detection is delayed. When a tag check
-  fault occurs, the information is stored in hardware (in the TFSR_EL1
-  register for arm64). The kernel periodically checks the hardware and
-  only reports tag faults during these checks.
-  Asymmetric mode: a bad access is detected synchronously on reads and
-  asynchronously on writes.
-
-- ``kasan.vmalloc=off`` or ``=on`` disables or enables tagging of vmalloc
-  allocations (default: ``on``).
-
-- ``kasan.stacktrace=off`` or ``=on`` disables or enables alloc and free stack
-  traces collection (default: ``on``).
-
 Implementation details
 ----------------------
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-clean-up-comments-in-internal-kasanh.patch
kasan-use-tabs-to-align-shadow-values.patch
kasan-give-better-names-to-shadow-values.patch
kasan-update-documentation.patch
kasan-move-boot-parameters-section-in-documentation.patch
kasan-clean-up-kconfig-options-descriptions.patch

