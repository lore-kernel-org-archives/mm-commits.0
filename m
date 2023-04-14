Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191FEC77B72
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 20:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjDNU0J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 16:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDNU0I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 16:26:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF0010B
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 13:26:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34480644E6
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 20:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870ECC433EF;
        Fri, 14 Apr 2023 20:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681503966;
        bh=smEyU7I2mreS/1FXFwHrwcMoz4Nsk1QWKAOguJVrpQ8=;
        h=Date:To:From:Subject:From;
        b=xbOrBRv9fRY3McXtVaUYrR4R6+GKxO7CIFMYnE7QG87Kpswt2gld0EcOq0tUW68nL
         K+EO9Rm0cwJgTGTqV65YiJ2DP6hDfaPIaeGpu57HOxAPpw4syPCarBevpmU8kPSgEp
         RpnPmgfvMO1ki+4QHVOdLZuyoKkXsQxFfJnUv818=
Date:   Fri, 14 Apr 2023 13:26:05 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-arch_has_descending_max_zone_pfns-static.patch added to mm-unstable branch
Message-Id: <20230414202606.870ECC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make arch_has_descending_max_zone_pfns() static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-arch_has_descending_max_zone_pfns-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-arch_has_descending_max_zone_pfns-static.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: make arch_has_descending_max_zone_pfns() static
Date: Fri, 14 Apr 2023 10:03:53 +0200

clang produces a build failure on x86 for some randconfig builds
after a change that moves around code to mm/mm_init.c:

Cannot find symbol for section 2: .text.
mm/mm_init.o: failed

I have not been able to figure out why this happens, but the __weak
annotation on arch_has_descending_max_zone_pfns() is the trigger here.

Removing the weak function in favor of an open-coded Kconfig option
check avoids the problem and becomes clearer as well as better to
optimize by the compiler.

Link: https://lkml.kernel.org/r/20230414080418.110236-1-arnd@kernel.org
Fixes: 9420f89db2dd ("mm: move most of core MM initialization to mm/mm_init.c")
Cc: llvm@lists.linux.dev
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
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
+	return !IS_ENABLED(CONFIG_ARC_HAS_PAE40);
 }
 
 /**
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-make-arch_has_descending_max_zone_pfns-static.patch

