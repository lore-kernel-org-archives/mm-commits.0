Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC48CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiGRAdC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiGRAcm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B5013F1C
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA65760FAF
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BB3C385A9;
        Mon, 18 Jul 2022 00:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104360;
        bh=68vsDf5Y3rVMAl7+3jfkbqlE6NLJdY5Temrx02Jribk=;
        h=Date:To:From:Subject:From;
        b=iJO/r6+1QX+YDhWlxK83jpQqJiDgk3OeAiW4pi8ToKX2Ukcr25qijgkEkcx2BUxtn
         ZFAlnNnKTE8BlOQAUZdEt2jyN76x0tgnteTrW74JKms/cscsDGXxB3mA2Nj+ITJsyg
         6laW0JIcNu56f8vZ9w3Eb9tFdfThE1gOmr15G4T0=
Date:   Sun, 17 Jul 2022 17:32:39 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        vschneid@redhat.com, tglx@linutronix.de, peterz@infradead.org,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        elver@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andriy.shevchenko@linux.intel.com, sander@svanheule.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-cacheinfo-move-shared-cache-map-definitions.patch removed from -mm tree
Message-Id: <20220718003240.17BB3C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/cacheinfo: move shared cache map definitions
has been removed from the -mm tree.  Its filename was
     x86-cacheinfo-move-shared-cache-map-definitions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


