Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8DCC43334
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 20:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiGBUjw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Jul 2022 16:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGBUjv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Jul 2022 16:39:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D057F659F
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 13:39:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE3FC6104E
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 20:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE1EC34114;
        Sat,  2 Jul 2022 20:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656794388;
        bh=v9nLmI+lLWrP4i4PuG2v9fzCRL1YKjzHroyJFIjJDuI=;
        h=Date:To:From:Subject:From;
        b=cmK6tg5MSvgiFECAq6BgDzhtG3LxZuXEzK/fI3lfR4rRhm1MWIHbt/imjqCD5w8kQ
         Ee2r9zd+cj+QoytjQ4TD3ATdkpKFDXLgMxE0lyn3fJT2Z+eiDdhAE6MvwvsQaPAQ5O
         oyz6W0ItkzzIYTzfrvAAnCSJ8pxNTFBjAOFDuEWY=
Date:   Sat, 02 Jul 2022 13:39:47 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        vschneid@redhat.com, tglx@linutronix.de, peterz@infradead.org,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        elver@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andriy.shevchenko@linux.intel.com, sander@svanheule.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cpumask-add-up-optimised-for_each__cpu-versions.patch added to mm-nonmm-unstable branch
Message-Id: <20220702203948.4CE1EC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: add UP optimised for_each_*_cpu versions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cpumask-add-up-optimised-for_each__cpu-versions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cpumask-add-up-optimised-for_each__cpu-versions.patch

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
Subject: cpumask: add UP optimised for_each_*_cpu versions
Date: Sat, 2 Jul 2022 18:08:27 +0200

On uniprocessor builds, the following loops will always run over a mask
that contains one enabled CPU (cpu0):

    - for_each_possible_cpu
    - for_each_online_cpu
    - for_each_present_cpu

Provide uniprocessor-specific macros for these loops, that always run
exactly once.

Link: https://lkml.kernel.org/r/3a92869b902a075b97be5d1452c9c6badbbff0df.1656777646.git.sander@svanheule.net
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/cpumask.h~cpumask-add-up-optimised-for_each__cpu-versions
+++ a/include/linux/cpumask.h
@@ -750,9 +750,16 @@ extern const DECLARE_BITMAP(cpu_all_bits
 /* First bits of cpu_bit_bitmap are in fact unset. */
 #define cpu_none_mask to_cpumask(cpu_bit_bitmap[0])
 
+#if NR_CPUS == 1
+/* Uniprocessor: the possible/online/present masks are always "1" */
+#define for_each_possible_cpu(cpu)	for ((cpu) = 0; (cpu) < 1; (cpu)++)
+#define for_each_online_cpu(cpu)	for ((cpu) = 0; (cpu) < 1; (cpu)++)
+#define for_each_present_cpu(cpu)	for ((cpu) = 0; (cpu) < 1; (cpu)++)
+#else
 #define for_each_possible_cpu(cpu) for_each_cpu((cpu), cpu_possible_mask)
 #define for_each_online_cpu(cpu)   for_each_cpu((cpu), cpu_online_mask)
 #define for_each_present_cpu(cpu)  for_each_cpu((cpu), cpu_present_mask)
+#endif
 
 /* Wrappers for arch boot code to manipulate normally-constant masks */
 void init_cpu_present(const struct cpumask *src);
_

Patches currently in -mm which might be from sander@svanheule.net are

x86-cacheinfo-move-shared-cache-map-definitions.patch
cpumask-fix-invalid-uniprocessor-mask-assumption.patch
lib-test-introduce-cpumask-kunit-test-suite.patch
cpumask-add-up-optimised-for_each__cpu-versions.patch
cpumask-update-cpumask_next_wrap-signature.patch

