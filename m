Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3784C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiLAAR5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiLAARE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:17:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AD899511
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:14:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6BF261941
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBD8C433D6;
        Thu,  1 Dec 2022 00:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853645;
        bh=uY0j0FlSAT+of8eCtyvudcCiFSsP/S1H5P9t9JeST2E=;
        h=Date:To:From:Subject:From;
        b=tTJdBs5k3+TEjUxrDNN4q/tSS3SqXfOVEeh886Yy01b06UuTJxlOqFuryH/s3G3Ok
         4P/Qm1OlWqZ2XO9TysAMUSTols1N57nkroQbRTyYE3J+yqgpM48DHOLQfQxHlFWWYT
         QYIw1BX0NoY+MxP4dJ5U7xfjzZ6zf2/dTuDbSkzM=
Date:   Wed, 30 Nov 2022 16:14:04 -0800
To:     mm-commits@vger.kernel.org, vschneid@redhat.com, vbabka@suse.cz,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, sander@svanheule.net, peterz@infradead.org,
        paulmck@kernel.org, linux@rasmusvillemoes.dk,
        klimov.linux@gmail.com, geert@linux-m68k.org, ebiggers@google.com,
        dvyukov@google.com, andriy.shevchenko@linux.intel.com,
        yury.norov@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] cpumask-limit-visibility-of-force_nr_cpus.patch removed from -mm tree
Message-Id: <20221201001405.1DBD8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: cpumask: limit visibility of FORCE_NR_CPUS
has been removed from the -mm tree.  Its filename was
     cpumask-limit-visibility-of-force_nr_cpus.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


