Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A3CC43217
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 21:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiKPV5o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 16:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbiKPV5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 16:57:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9F9617E
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 13:57:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62797B81EBC
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 21:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7AEC433C1;
        Wed, 16 Nov 2022 21:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668635834;
        bh=f8DnyN2IfKWvnfakjTF3eueipsAmRdc/BjwOFz+r12g=;
        h=Date:To:From:Subject:From;
        b=Ot4xFY2SlFk11JH4Sg6C7AHl2MZEQFFV5SEU61UOtk6mtLrYVnSYphF7105GjPDtT
         nzxc3z+d8OCm+GC4XdCMhP+Kj7s1Qf38oprRsQtVSvqGFrN0ty4GSU7bf+p5w45BjP
         XlPyjrkYgs8CWVFgJ/kUKSNmgwgBxydA4Mta+mDo=
Date:   Wed, 16 Nov 2022 13:57:13 -0800
To:     mm-commits@vger.kernel.org, vschneid@redhat.com, vbabka@suse.cz,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, sander@svanheule.net, peterz@infradead.org,
        paulmck@kernel.org, linux@rasmusvillemoes.dk,
        klimov.linux@gmail.com, geert@linux-m68k.org, ebiggers@google.com,
        dvyukov@google.com, andriy.shevchenko@linux.intel.com,
        yury.norov@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cpumask-limit-visibility-of-force_nr_cpus.patch added to mm-nonmm-unstable branch
Message-Id: <20221116215713.EF7AEC433C1@smtp.kernel.org>
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
Date: Wed, 16 Nov 2022 09:24:51 -0800

In current form, FORCE_NR_CPUS is visible to all users building their
kernels, even not experts.  It is also set in allmodconfig or
allyesconfig, which is not a correct behavior.

This patch fixes it.  It also changes the parameter short description:
removes implementation details and highlights the effect of the change.

Link: https://lkml.kernel.org/r/20221116172451.274938-1-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/Kconfig~cpumask-limit-visibility-of-force_nr_cpus
+++ a/lib/Kconfig
@@ -529,8 +529,8 @@ config CPUMASK_OFFSTACK
 	  stack overflow.
 
 config FORCE_NR_CPUS
-       bool "NR_CPUS is set to an actual number of CPUs"
-       depends on SMP
+       bool "Set number of CPUs at compile time"
+       depends on SMP && EXPERT && !COMPILE_TEST
        help
          Say Yes if you have NR_CPUS set to an actual number of possible
          CPUs in your system, not to a default value. This forces the core
_

Patches currently in -mm which might be from yury.norov@gmail.com are

cpumask-limit-visibility-of-force_nr_cpus.patch

