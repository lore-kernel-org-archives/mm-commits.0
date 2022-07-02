Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14775C43334
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 20:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiGBUjo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Jul 2022 16:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGBUjo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Jul 2022 16:39:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E89E6567
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 13:39:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2BBDB80189
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 20:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D57BC34114;
        Sat,  2 Jul 2022 20:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656794380;
        bh=be8qP11GaDciLgYUGceZK9fn5f/55n4exSYC9DmcRMU=;
        h=Date:To:From:Subject:From;
        b=feadTWrzauGYB3duAvnTYUanM9Pc+E29a9uGHdWZxp86JD0xiNa9CginUAbwI0Dms
         jU6mwf+Z2MmDlA3zGZwvG/g6WZT8NuilninhBxsCInKsmtTwRT9QrfEL6wM7uDFqI8
         fSqsG+uqOB9mYiH+OSD1Y4v79VY32Veja9M+RLJ4=
Date:   Sat, 02 Jul 2022 13:39:39 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        vschneid@redhat.com, tglx@linutronix.de, peterz@infradead.org,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        elver@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andriy.shevchenko@linux.intel.com, sander@svanheule.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-cacheinfo-move-shared-cache-map-definitions.patch added to mm-nonmm-unstable branch
Message-Id: <20220702203940.8D57BC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/cacheinfo: move shared cache map definitions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-cacheinfo-move-shared-cache-map-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-cacheinfo-move-shared-cache-map-definitions.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sander Vanheule <sander@svanheule.net>
Subject: x86/cacheinfo: move shared cache map definitions
Date: Sat, 2 Jul 2022 18:08:24 +0200

Patch series "cpumask: Fix invalid uniprocessor assumptions", v4.

On uniprocessor builds, it is currently assumed that any cpumask will
contain the single CPU: cpu0.  This assumption is used to provide
optimised implementations.

The current assumption also appears to be wrong, by ignoring the fact that
users can provide empty cpumasks.  This can result in bugs as explained in
[1] - for_each_cpu() will run one iteration of the loop even when passed
an empty cpumask.

This series introduces some basic tests, and updates the optimisations for
uniprocessor builds.

The x86 patch was written after the kernel test robot [2] ran into a
failed build.  I have tried to list the files potentially affected by the
changes to cpumask.h, in an attempt to find any other cases that fail on
!SMP.  I've gone through some of the files manually, and ran a few cross
builds, but nothing else popped up.  I (build) checked about half of the
potientally affected files, but I do not have the resources to do them
all.  I hope we can fix other issues if/when they pop up later.

[1] https://lore.kernel.org/all/20220530082552.46113-1-sander@svanheule.net/
[2] https://lore.kernel.org/all/202206060858.wA0FOzRy-lkp@intel.com/


This patch (of 5):

The maps to keep track of shared caches between CPUs on SMP systems are
declared in asm/smp.h, among them specifically cpu_llc_shared_map.  These
maps are externally defined in cpu/smpboot.c.  The latter is only compiled
on CONFIG_SMP=y, which means the declared extern symbols from asm/smp.h do
not have a corresponding definition on uniprocessor builds.

The inline cpu_llc_shared_mask() function from asm/smp.h refers to the map
declaration mentioned above.  This function is referenced in cacheinfo.c
inside for_each_cpu() loop macros, to provide cpumask for the loop.  On
uniprocessor builds, the symbol for the cpu_llc_shared_map does not exist.
However, the current implementation of for_each_cpu() also (wrongly)
ignores the provided mask.

By sheer luck, the compiler thus optimises out this unused reference to
cpu_llc_shared_map, and the linker therefore does not require the
cpu_llc_shared_mask to actually exist on uniprocessor builds.  Only on SMP
bulids does smpboot.o exist to provide the required symbols.

To no longer rely on compiler optimisations for successful uniprocessor
builds, move the definitions of cpu_llc_shared_map and cpu_l2c_shared_map
from smpboot.c to cacheinfo.c.

Link: https://lkml.kernel.org/r/cover.1656777646.git.sander@svanheule.net
Link: https://lkml.kernel.org/r/e8167ddb570f56744a3dc12c2149a660a324d969.1656777646.git.sander@svanheule.net
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cacheinfo.c |    6 ++++++
 arch/x86/kernel/smpboot.c       |    4 ----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/cacheinfo.c~x86-cacheinfo-move-shared-cache-map-definitions
+++ a/arch/x86/kernel/cpu/cacheinfo.c
@@ -29,6 +29,12 @@
 #define LVL_3		4
 #define LVL_TRACE	5
 
+/* Shared last level cache maps */
+DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
+
+/* Shared L2 cache maps */
+DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_l2c_shared_map);
+
 struct _cache_table {
 	unsigned char descriptor;
 	char cache_type;
--- a/arch/x86/kernel/smpboot.c~x86-cacheinfo-move-shared-cache-map-definitions
+++ a/arch/x86/kernel/smpboot.c
@@ -95,10 +95,6 @@ EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_die_map);
 EXPORT_PER_CPU_SYMBOL(cpu_die_map);
 
-DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
-
-DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_l2c_shared_map);
-
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
_

Patches currently in -mm which might be from sander@svanheule.net are

x86-cacheinfo-move-shared-cache-map-definitions.patch
cpumask-fix-invalid-uniprocessor-mask-assumption.patch
lib-test-introduce-cpumask-kunit-test-suite.patch
cpumask-add-up-optimised-for_each__cpu-versions.patch
cpumask-update-cpumask_next_wrap-signature.patch

