Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE46C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjDRXd0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDRXd0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C00072A9
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB08962CA1
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01706C433D2;
        Tue, 18 Apr 2023 23:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860804;
        bh=PZJT9WsJqRdF96SgI3y6GesUkHU6i86L0JChGx/3G7k=;
        h=Date:To:From:Subject:From;
        b=DdQ57XW+RgXmB3PK60phufqrGaH5CW/TGq5uYuzoPCjBxD9+ubDvKV8Ygk2QLH1gd
         wz2HJRHVGLhOP7XjWHfrKOTElAlwvzmkH5NZhW9MO2i022of75PPUJTMVRQNivtBgN
         JdrjEl55rn0nrL1nPD3EDcRxrzhIZXuyRcpkrcrw=
Date:   Tue, 18 Apr 2023 16:33:23 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, sj@kernel.org,
        rppt@kernel.org, oliver.sang@intel.com, geert+renesas@glider.be,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-arch_has_descending_max_zone_pfns-static.patch removed from -mm tree
Message-Id: <20230418233324.01706C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make arch_has_descending_max_zone_pfns() static
has been removed from the -mm tree.  Its filename was
     mm-make-arch_has_descending_max_zone_pfns-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: make arch_has_descending_max_zone_pfns() static
Date: Fri, 14 Apr 2023 10:03:53 +0200

clang produces a build failure on x86 for some randconfig builds after a
change that moves around code to mm/mm_init.c:

Cannot find symbol for section 2: .text.
mm/mm_init.o: failed

I have not been able to figure out why this happens, but the __weak
annotation on arch_has_descending_max_zone_pfns() is the trigger here.

Removing the weak function in favor of an open-coded Kconfig option check
avoids the problem and becomes clearer as well as better to optimize by
the compiler.

[arnd@arndb.de: fix logic bug]
  Link: https://lkml.kernel.org/r/20230415081904.969049-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20230414080418.110236-1-arnd@kernel.org
Fixes: 9420f89db2dd ("mm: move most of core MM initialization to mm/mm_init.c")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: SeongJae Park <sj@kernel.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c |    5 -----
 include/linux/mm.h |    1 -
 mm/mm_init.c       |    4 ++--
 3 files changed, 2 insertions(+), 8 deletions(-)

--- a/arch/arc/mm/init.c~mm-make-arch_has_descending_max_zone_pfns-static
+++ a/arch/arc/mm/init.c
@@ -74,11 +74,6 @@ void __init early_init_dt_add_memory_arc
 		base, TO_MB(size), !in_use ? "Not used":"");
 }
 
-bool arch_has_descending_max_zone_pfns(void)
-{
-	return !IS_ENABLED(CONFIG_ARC_HAS_PAE40);
-}
-
 /*
  * First memory setup routine called from setup_arch()
  * 1. setup swapper's mm @init_mm
--- a/include/linux/mm.h~mm-make-arch_has_descending_max_zone_pfns-static
+++ a/include/linux/mm.h
@@ -3035,7 +3035,6 @@ extern void setup_per_cpu_pageset(void);
 extern int min_free_kbytes;
 extern int watermark_boost_factor;
 extern int watermark_scale_factor;
-extern bool arch_has_descending_max_zone_pfns(void);
 
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
--- a/mm/mm_init.c~mm-make-arch_has_descending_max_zone_pfns-static
+++ a/mm/mm_init.c
@@ -1752,9 +1752,9 @@ static void __init free_area_init_memory
  * Some architectures, e.g. ARC may have ZONE_HIGHMEM below ZONE_NORMAL. For
  * such cases we allow max_zone_pfn sorted in the descending order
  */
-bool __weak arch_has_descending_max_zone_pfns(void)
+static bool arch_has_descending_max_zone_pfns(void)
 {
-	return false;
+	return IS_ENABLED(CONFIG_ARC) && !IS_ENABLED(CONFIG_ARC_HAS_PAE40);
 }
 
 /**
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-remove-hwasan-kernel-mem-intrinsic-prefix=1-for-clang-14.patch
ocfs2-reduce-ioctl-stack-usage.patch

