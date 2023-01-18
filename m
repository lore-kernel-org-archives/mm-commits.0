Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D422C32793
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjARV7j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjARV7i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:59:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07405EFAC
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:59:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3437E61A6A
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB80C433EF;
        Wed, 18 Jan 2023 21:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674079176;
        bh=bMplgPkpBTyJSsaQHGoLft5rQ+vuGdgVWGIsSeryAtI=;
        h=Date:To:From:Subject:From;
        b=l7Cui7hEmw3OTgsTfpviSKsTO6Vet4PGxg7dBs/yZhCeLejoK/+nrvLHUzZYwgICL
         b+859j8yTpBmp1dBZWfX42p7pGKVLry2mvAuJMWDe+UhcZOnsASfxHutAztnIarWqE
         C2DhrsKdK/j+/oyvVlvNvLXDFRG5zkf5et6m1q7g=
Date:   Wed, 18 Jan 2023 13:59:36 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        nathan@kernel.org, mirsad.todorovac@alu.unizg.hr,
        ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        catalin.marinas@arm.com, zhaoyang.huang@unisoc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-use-stack_depot_early_init-for-kmemleak.patch removed from -mm tree
Message-Id: <20230118215936.7AB80C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use stack_depot_early_init for kmemleak
has been removed from the -mm tree.  Its filename was
     mm-use-stack_depot_early_init-for-kmemleak.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: use stack_depot_early_init for kmemleak
Date: Tue, 17 Jan 2023 16:11:52 +0800

Mirsad report bellow error which caused by stack_depot_init failed in
kvcalloc.  Solve this by having stackdepot use stack_depot_early_init. 
Extra Kconfig also done by moving kmemleak stuff to mm/Kconfig.debug.

On 1/4/23 17:08, Mirsad Goran Todorovac wrote:
I hate to bring bad news again, but there seems to be a problem with the output of /sys/kernel/debug/kmemleak:

[root@pc-mtodorov ~]# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff951c118568b0 (size 16):
comm "kworker/u12:2", pid 56, jiffies 4294893952 (age 4356.548s)
    hex dump (first 16 bytes):
      6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00 memstick0.......
    backtrace:
 [root@pc-mtodorov ~]#
   Apparently, backtrace of called functions on the stack is no longer printed with the list of memory leaks.
 This appeared on Lenovo desktop 10TX000VCR, with AlmaLinux 8.7 and BIOS version M22KT49A (11/10/2022)
 and 6.2-rc1 and 6.2-rc2 builds.
 This worked on 6.1 with the same CONFIG_KMEMLEAK=y and MGLRU enabled on a vanilla mainstream kernel
 from Mr. Torvalds' tree. I don't know if this is deliberate feature for some reason or a bug.
 Please find attached the config, lshw and kmemleak output.

Link: https://lkml.kernel.org/r/1673943112-8620-1-git-send-email-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/Kconfig.debug~mm-use-stack_depot_early_init-for-kmemleak
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
--- a/mm/Kconfig.debug~mm-use-stack_depot_early_init-for-kmemleak
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
--- a/mm/kmemleak.c~mm-use-stack_depot_early_init-for-kmemleak
+++ a/mm/kmemleak.c
@@ -2070,8 +2070,10 @@ static int __init kmemleak_boot_config(c
 		return -EINVAL;
 	if (strcmp(str, "off") == 0)
 		kmemleak_disable();
-	else if (strcmp(str, "on") == 0)
+	else if (strcmp(str, "on") == 0) {
 		kmemleak_skip_disable = 1;
+		stack_depot_want_early_init();
+	}
 	else
 		return -EINVAL;
 	return 0;
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-move-kmemleaks-kconfig-items-from-lib-to-mm.patch

