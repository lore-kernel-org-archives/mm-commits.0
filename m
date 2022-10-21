Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF1AC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 01:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJUByh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 21:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiJUByc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 21:54:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D4D64FF
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 18:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D4961D92
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 01:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EF4C433C1;
        Fri, 21 Oct 2022 01:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666317263;
        bh=qb88sNcGpg4pD7bxp7cQX5bD3pORdkFHxLbeUY+c0G0=;
        h=Date:To:From:Subject:From;
        b=KY2bv71Qc3DBM55lA6lD+3RBwiLg7bkuOXDQud3JEfYdxWGqCmRdLfDLQx8BBeQl2
         LcTkWWxDjCJobZ3MpI6JOd/mQPpYZBM/XGmxu+ymQZ7bRK8eo24rnW6fCzLABolH4V
         tUXF+4EcPKXkmd+KXjZCeJslHoNKhNR/qT/5BMdQ=
Date:   Thu, 20 Oct 2022 18:54:22 -0700
To:     mm-commits@vger.kernel.org, vschneid@redhat.com, vbabka@suse.cz,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, sander@svanheule.net, peterz@infradead.org,
        paulmck@kernel.org, linux@rasmusvillemoes.dk,
        klimov.linux@gmail.com, geert@linux-m68k.org, ebiggers@google.com,
        dvyukov@google.com, andriy.shevchenko@linux.intel.com,
        yury.norov@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cpumask-limit-visibility-of-force_nr_cpus.patch added to mm-nonmm-unstable branch
Message-Id: <20221021015423.D9EF4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: limit visibility of FORCE_NR_CPUS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cpumask-limit-visibility-of-force_nr_cpus.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cpumask-limit-visibility-of-force_nr_cpus.patch

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
From: Yury Norov <yury.norov@gmail.com>
Subject: cpumask: limit visibility of FORCE_NR_CPUS
Date: Wed, 19 Oct 2022 15:59:39 -0700

In current form, FORCE_NR_CPUS is visible to all users building their
kernels, even not experts.  It is also set in allmodconfig or
allyesconfig, which is not a correct behavior.

The 'choice' and unused config UNFORCE_NR_CPUS are used to ensure that
auto-generated configs that try to enable as much options as possible,
like allmodconfig, don't enable FORCE_NR_CPUS.

Link: https://lkml.kernel.org/r/20221019225939.1646349-1-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Klimov <klimov.linux@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sander Vanheule <sander@svanheule.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

--- a/lib/Kconfig~cpumask-limit-visibility-of-force_nr_cpus
+++ a/lib/Kconfig
@@ -528,14 +528,31 @@ config CPUMASK_OFFSTACK
 	  them on the stack.  This is a bit more expensive, but avoids
 	  stack overflow.
 
+choice
+	prompt "Number of CPUs detection method"
+	default UNFORCE_NR_CPUS
+	depends on SMP && EXPERT
+	help
+	  Select between boot-time and compile-time detection of number
+	  of CPUs. If it's possible to provide exact number of CPUs at
+	  compile-time, kernel code may be optimized better.
+	  For general-purpose kernel, choose "boot time" option.
+
+config UNFORCE_NR_CPUS
+	bool "Set number of CPUs at boot time"
+	help
+	  Choose it if you build general-purpose kernel and want to rely
+	  on kernel to detect actual number of CPUs.
+
 config FORCE_NR_CPUS
-       bool "NR_CPUS is set to an actual number of CPUs"
-       depends on SMP
-       help
-         Say Yes if you have NR_CPUS set to an actual number of possible
-         CPUs in your system, not to a default value. This forces the core
-         code to rely on compile-time value and optimize kernel routines
-         better.
+	bool "Set number of CPUs at compile time"
+	help
+	  Choose it if NR_CPUS corresponds to an actual number of
+	  possible CPUs in your system. This forces the core code
+	  to rely on compile-time value and optimize kernel routines
+	  better.
+
+endchoice
 
 config CPU_RMAP
 	bool
_

Patches currently in -mm which might be from yury.norov@gmail.com are

cpumask-limit-visibility-of-force_nr_cpus.patch

