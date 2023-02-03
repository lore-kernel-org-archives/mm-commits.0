Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0159C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjBCGnW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjBCGle (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672715FD3
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0048861DA8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F39C433EF;
        Fri,  3 Feb 2023 06:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406288;
        bh=KJLAOq9p8zp6i898ZbWkBYuXP/A5xhZBSaJAtBYpdAo=;
        h=Date:To:From:Subject:From;
        b=BB0W1OYjAWmrDkW378+p95qZNGZhs90A3SqA13J3AYfUcCrpm659uhAUdROGpwGID
         OzV5hPQuy61YLYAimXcpqCz/x6T1KpPbh3xNBY5sEbTKNOYCC+NJ17XSCkTrSiIIio
         LHmGhJqX5puwEYDsTMUS2YhmCIBo/LJFxOGVDWhw=
Date:   Thu, 02 Feb 2023 22:38:07 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        peterz@infradead.org, nathan@kernel.org,
        mirsad.todorovac@alu.unizg.hr, ke.wang@unisoc.com,
        catalin.marinas@arm.com, zhaoyang.huang@unisoc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-kmemleaks-kconfig-items-from-lib-to-mm.patch removed from -mm tree
Message-Id: <20230203063808.55F39C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move KMEMLEAK's Kconfig items from lib to mm
has been removed from the -mm tree.  Its filename was
     mm-move-kmemleaks-kconfig-items-from-lib-to-mm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -743,77 +743,6 @@ config SHRINKER_DEBUG
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
-	select STACKDEPOT_ALWAYS_INIT if !DEBUG_KMEMLEAK_DEFAULT_OFF
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
@@ -207,3 +207,75 @@ config PTDUMP_DEBUGFS
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
+	select STACKDEPOT_ALWAYS_INIT if !DEBUG_KMEMLEAK_DEFAULT_OFF
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
+
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are


