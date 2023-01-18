Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60248C32793
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 22:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjARWAp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjARWAo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 17:00:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92D75EFAC
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 14:00:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5708961A73
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 22:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6B2C433D2;
        Wed, 18 Jan 2023 22:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674079241;
        bh=aPt8qKSyw3xjRXMPaKkOQJhtrSgHhdKc2xxGYLNx4K4=;
        h=Date:To:From:Subject:From;
        b=WtyIv7My+TGYtiO4otsm6Msexif669TG0YdTZaviAUe3w7x+wjprADKbThy0kFBIV
         /i3X8GaHid4dOFyLk8t6p3Uy4LWbC7HMeaMB1dBuS0KXc7a37N2wA1v9KjMQ+WM1/K
         ExWWDRO6w8+NCxCYb/Fl5R4a+Y6j//EVZ0/LUsis=
Date:   Wed, 18 Jan 2023 14:00:41 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        nathan@kernel.org, mirsad.todorovac@alu.unizg.hr,
        ke.wang@unisoc.com, catalin.marinas@arm.com,
        zhaoyang.huang@unisoc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-kmemleaks-kconfig-items-from-lib-to-mm.patch added to mm-unstable branch
Message-Id: <20230118220041.AF6B2C433D2@smtp.kernel.org>
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
Date: Wed, 18 Jan 2023 10:35:27 +0800

Have the kmemleak's source code and Kconfig items be in the same directory.

Link: https://lkml.kernel.org/r/1674009327-23493-1-git-send-email-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   70 --------------------------------------------
 mm/Kconfig.debug  |   70 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 70 deletions(-)

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

