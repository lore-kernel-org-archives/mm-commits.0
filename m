Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2793DC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 03:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiCZD0q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 23:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiCZD0o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 23:26:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0756A15E8BF
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:25:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 755C3619B2
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 03:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5536C340F0;
        Sat, 26 Mar 2022 03:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648265107;
        bh=D6o7Og0+aLYEhy4i/do1rGHQo6LXvq/yG0RqqmwlGbs=;
        h=Date:To:From:Subject:From;
        b=EZNspqy7Kz2MoNWlFCzZBDBd55cgSJh3KzXtkhDNAqjtY00miMqv3GX3bLPtcRtN3
         dSxJuAYqPZeIrrSaY94mwXgjAkI/qXAoZUKAtMy9KMqvEi8PADjEJycdU4mXlm3GGU
         sXwQazY4YbiQnM0MIgygnwlsMfTuDmEnHIuxsIkc=
Date:   Fri, 25 Mar 2022 20:25:07 -0700
To:     mm-commits@vger.kernel.org, masahiroy@kernel.org,
        keescook@chromium.org, linux@rasmusvillemoes.dk,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-remove-more-config__value-indirections.patch added to -mm tree
Message-Id: <20220326032507.C5536C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: remove more CONFIG_..._VALUE indirections
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-remove-more-config__value-indirections.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-kconfigdebug-remove-more-config__value-indirections.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfigdebug-remove-more-config__value-indirections.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/Kconfig.debug: remove more CONFIG_..._VALUE indirections

As in "kernel/panic.c: remove CONFIG_PANIC_ON_OOPS_VALUE indirection",
use the IS_ENABLED() helper rather than having a hidden config option.

Link: https://lkml.kernel.org/r/20220321121301.1389693-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    2 +-
 kernel/watchdog.c  |    4 ++--
 lib/Kconfig.debug  |   21 ---------------------
 3 files changed, 3 insertions(+), 24 deletions(-)

--- a/kernel/hung_task.c~lib-kconfigdebug-remove-more-config__value-indirections
+++ a/kernel/hung_task.c
@@ -73,7 +73,7 @@ static unsigned int __read_mostly sysctl
  * hung task is detected:
  */
 unsigned int __read_mostly sysctl_hung_task_panic =
-				CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE;
+				IS_ENABLED(CONFIG_BOOTPARAM_HUNG_TASK_PANIC);
 
 static int
 hung_task_panic(struct notifier_block *this, unsigned long event, void *ptr)
--- a/kernel/watchdog.c~lib-kconfigdebug-remove-more-config__value-indirections
+++ a/kernel/watchdog.c
@@ -57,7 +57,7 @@ int __read_mostly sysctl_hardlockup_all_
  * Should we panic when a soft-lockup or hard-lockup occurs:
  */
 unsigned int __read_mostly hardlockup_panic =
-			CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE;
+			IS_ENABLED(CONFIG_BOOTPARAM_HARDLOCKUP_PANIC);
 /*
  * We may not want to enable hard lockup detection by default in all cases,
  * for example when running the kernel as a guest on a hypervisor. In these
@@ -168,7 +168,7 @@ static struct cpumask watchdog_allowed_m
 
 /* Global variables, exported for sysctl */
 unsigned int __read_mostly softlockup_panic =
-			CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE;
+			IS_ENABLED(CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC);
 
 static bool softlockup_initialized __read_mostly;
 static u64 __read_mostly sample_period;
--- a/lib/Kconfig.debug~lib-kconfigdebug-remove-more-config__value-indirections
+++ a/lib/Kconfig.debug
@@ -1071,13 +1071,6 @@ config BOOTPARAM_SOFTLOCKUP_PANIC
 
 	  Say N if unsure.
 
-config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
-	int
-	depends on SOFTLOCKUP_DETECTOR
-	range 0 1
-	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
-	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
-
 config HARDLOCKUP_DETECTOR_PERF
 	bool
 	select SOFTLOCKUP_DETECTOR
@@ -1119,13 +1112,6 @@ config BOOTPARAM_HARDLOCKUP_PANIC
 
 	  Say N if unsure.
 
-config BOOTPARAM_HARDLOCKUP_PANIC_VALUE
-	int
-	depends on HARDLOCKUP_DETECTOR
-	range 0 1
-	default 0 if !BOOTPARAM_HARDLOCKUP_PANIC
-	default 1 if BOOTPARAM_HARDLOCKUP_PANIC
-
 config DETECT_HUNG_TASK
 	bool "Detect Hung Tasks"
 	depends on DEBUG_KERNEL
@@ -1173,13 +1159,6 @@ config BOOTPARAM_HUNG_TASK_PANIC
 
 	  Say N if unsure.
 
-config BOOTPARAM_HUNG_TASK_PANIC_VALUE
-	int
-	depends on DETECT_HUNG_TASK
-	range 0 1
-	default 0 if !BOOTPARAM_HUNG_TASK_PANIC
-	default 1 if BOOTPARAM_HUNG_TASK_PANIC
-
 config WQ_WATCHDOG
 	bool "Detect Workqueue Stalls"
 	depends on DEBUG_KERNEL
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-kconfigdebug-remove-more-config__value-indirections.patch

