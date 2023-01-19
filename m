Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2E6C004D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 22:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjASW50 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 17:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjASW5A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 17:57:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77B5524C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 14:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39D0461D85
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930A0C433EF;
        Thu, 19 Jan 2023 22:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674168020;
        bh=rgy4ZrmQL3Pn71NGP6nZbM05RYZYwT8+4b4oWlKTfQc=;
        h=Date:To:From:Subject:From;
        b=RZXB1/07VizZ3PBL3Nfmm/QkYqZWGUec/MTXRRQyTn+dI8UkyE34rQGRJ3zOtBvvs
         W9s5IM8/gHSMxzrkcg8tZTwAIqxsfR5u966dJgHd78LnTGC+IeZ7DD1HmeLQ4RSXm9
         E10Z1sw+BCehh+7uX6Mz1445lDvrlUMUkf6GYwWA=
Date:   Thu, 19 Jan 2023 14:40:19 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        peterz@infradead.org, nathan@kernel.org,
        mirsad.todorovac@alu.unizg.hr, ke.wang@unisoc.com,
        catalin.marinas@arm.com, zhaoyang.huang@unisoc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-kmemleaks-kconfig-items-from-lib-to-mm.patch added to mm-unstable branch
Message-Id: <20230119224020.930A0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move KMEMLEAK's Kconfig items from lib to mm
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-kmemleaks-kconfig-items-from-lib-to-mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-kmemleaks-kconfig-items-from-lib-to-mm.patch

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
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: move KMEMLEAK's Kconfig items from lib to mm
Date: Thu, 19 Jan 2023 09:22:24 +0800

Have the kmemleak's source code and Kconfig items be in the same directory.

Link: https://lkml.kernel.org/r/1674091345-14799-1-git-send-email-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/Kconfig.debug~mm-move-kmemleaks-kconfig-items-from-lib-to-mm
+++ a/lib/Kconfig.debug
@@ -743,76 +743,6 @@ config SHRINKER_DEBUG
 	  visibility into the kernel memory shrinkers subsystem.
 	  Disable it to avoid an extra memory footprint.
 
-config HAVE_DEBUG_KMEMLEAK
-	bool
-
-config DEBUG_KMEMLEAK
-	bool "Kernel memory leak detector"
-	depends on DEBUG_KERNEL && HAVE_DEBUG_KMEMLEAK
-	select DEBUG_FS
-	select STACKTRACE if STACKTRACE_SUPPORT
-	select KALLSYMS
-	select CRC32
-	select STACKDEPOT
-	help
-	  Say Y here if you want to enable the memory leak
-	  detector. The memory allocation/freeing is traced in a way
-	  similar to the Boehm's conservative garbage collector, the
-	  difference being that the orphan objects are not freed but
-	  only shown in /sys/kernel/debug/kmemleak. Enabling this
-	  feature will introduce an overhead to memory
-	  allocations. See Documentation/dev-tools/kmemleak.rst for more
-	  details.
-
-	  Enabling DEBUG_SLAB or SLUB_DEBUG may increase the chances
-	  of finding leaks due to the slab objects poisoning.
-
-	  In order to access the kmemleak file, debugfs needs to be
-	  mounted (usually at /sys/kernel/debug).
-
-config DEBUG_KMEMLEAK_MEM_POOL_SIZE
-	int "Kmemleak memory pool size"
-	depends on DEBUG_KMEMLEAK
-	range 200 1000000
-	default 16000
-	help
-	  Kmemleak must track all the memory allocations to avoid
-	  reporting false positives. Since memory may be allocated or
-	  freed before kmemleak is fully initialised, use a static pool
-	  of metadata objects to track such callbacks. After kmemleak is
-	  fully initialised, this memory pool acts as an emergency one
-	  if slab allocations fail.
-
-config DEBUG_KMEMLEAK_TEST
-	tristate "Simple test for the kernel memory leak detector"
-	depends on DEBUG_KMEMLEAK && m
-	help
-	  This option enables a module that explicitly leaks memory.
-
-	  If unsure, say N.
-
-config DEBUG_KMEMLEAK_DEFAULT_OFF
-	bool "Default kmemleak to off"
-	depends on DEBUG_KMEMLEAK
-	help
-	  Say Y here to disable kmemleak by default. It can then be enabled
-	  on the command line via kmemleak=on.
-
-config DEBUG_KMEMLEAK_AUTO_SCAN
-	bool "Enable kmemleak auto scan thread on boot up"
-	default y
-	depends on DEBUG_KMEMLEAK
-	help
-	  Depending on the cpu, kmemleak scan may be cpu intensive and can
-	  stall user tasks at times. This option enables/disables automatic
-	  kmemleak scan at boot up.
-
-	  Say N here to disable kmemleak auto scan thread to stop automatic
-	  scanning. Disabling this option disables automatic reporting of
-	  memory leaks.
-
-	  If unsure, say Y.
-
 config DEBUG_STACK_USAGE
 	bool "Stack utilization instrumentation"
 	depends on DEBUG_KERNEL && !IA64
--- a/mm/Kconfig.debug~mm-move-kmemleaks-kconfig-items-from-lib-to-mm
+++ a/mm/Kconfig.debug
@@ -207,3 +207,73 @@ config PTDUMP_DEBUGFS
 	  kernel.
 
 	  If in doubt, say N.
+
+config HAVE_DEBUG_KMEMLEAK
+	bool
+
+config DEBUG_KMEMLEAK
+	bool "Kernel memory leak detector"
+	depends on DEBUG_KERNEL && HAVE_DEBUG_KMEMLEAK
+	select DEBUG_FS
+	select STACKTRACE if STACKTRACE_SUPPORT
+	select KALLSYMS
+	select CRC32
+	select STACKDEPOT
+	help
+	  Say Y here if you want to enable the memory leak
+	  detector. The memory allocation/freeing is traced in a way
+	  similar to the Boehm's conservative garbage collector, the
+	  difference being that the orphan objects are not freed but
+	  only shown in /sys/kernel/debug/kmemleak. Enabling this
+	  feature will introduce an overhead to memory
+	  allocations. See Documentation/dev-tools/kmemleak.rst for more
+	  details.
+
+	  Enabling DEBUG_SLAB or SLUB_DEBUG may increase the chances
+	  of finding leaks due to the slab objects poisoning.
+
+	  In order to access the kmemleak file, debugfs needs to be
+	  mounted (usually at /sys/kernel/debug).
+
+config DEBUG_KMEMLEAK_MEM_POOL_SIZE
+	int "Kmemleak memory pool size"
+	depends on DEBUG_KMEMLEAK
+	range 200 1000000
+	default 16000
+	help
+	  Kmemleak must track all the memory allocations to avoid
+	  reporting false positives. Since memory may be allocated or
+	  freed before kmemleak is fully initialised, use a static pool
+	  of metadata objects to track such callbacks. After kmemleak is
+	  fully initialised, this memory pool acts as an emergency one
+	  if slab allocations fail.
+
+config DEBUG_KMEMLEAK_TEST
+	tristate "Simple test for the kernel memory leak detector"
+	depends on DEBUG_KMEMLEAK && m
+	help
+	  This option enables a module that explicitly leaks memory.
+
+	  If unsure, say N.
+
+config DEBUG_KMEMLEAK_DEFAULT_OFF
+	bool "Default kmemleak to off"
+	depends on DEBUG_KMEMLEAK
+	help
+	  Say Y here to disable kmemleak by default. It can then be enabled
+	  on the command line via kmemleak=on.
+
+config DEBUG_KMEMLEAK_AUTO_SCAN
+	bool "Enable kmemleak auto scan thread on boot up"
+	default y
+	depends on DEBUG_KMEMLEAK
+	help
+	  Depending on the cpu, kmemleak scan may be cpu intensive and can
+	  stall user tasks at times. This option enables/disables automatic
+	  kmemleak scan at boot up.
+
+	  Say N here to disable kmemleak auto scan thread to stop automatic
+	  scanning. Disabling this option disables automatic reporting of
+	  memory leaks.
+
+	  If unsure, say Y.
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-move-kmemleaks-kconfig-items-from-lib-to-mm.patch
mm-use-stack_depot_early_init-for-kmemleak.patch

