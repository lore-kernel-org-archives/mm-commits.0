Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB056C7619A
	for <mm-commits@archiver.kernel.org>; Thu, 30 Mar 2023 20:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjC3UKX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Mar 2023 16:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjC3UKW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Mar 2023 16:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE851043D
        for <mm-commits@vger.kernel.org>; Thu, 30 Mar 2023 13:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B91E8B82A20
        for <mm-commits@vger.kernel.org>; Thu, 30 Mar 2023 20:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BCBC433D2;
        Thu, 30 Mar 2023 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680207017;
        bh=hNc778e716m3ZIzbDuRPV+fnzCA80kPoSvqhHQL4En8=;
        h=Date:To:From:Subject:From;
        b=uH2B4X4lvLV+XWFZ/xkxHaJeg7UIO9jEp1a3+gGEO3KPM0EjgthPgFb9z9uPkRf5N
         61RrKRLW9DnZQWhCA193UI9zddUwJBsesyV5s6Zvl28167KC5l1tDr4d4HyBO5ZJau
         Xg8wgO8EP1N0MoTuYQQw/MSB5i5NP5h8ZJ0nqI1k=
Date:   Thu, 30 Mar 2023 13:10:16 -0700
To:     mm-commits@vger.kernel.org, ye.xingchen@zte.com.cn,
        ojeda@kernel.org, me@kloenk.dev, mark.rutland@arm.com,
        jgg@ziepe.ca, gregkh@linuxfoundation.org, catalin.marinas@arm.com,
        arnd@arndb.de, alex.williamson@redhat.com, alex.gaynor@gmail.com,
        akrowiak@linux.ibm.com, gehao@kylinos.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmemleak-test-optimize-kmemleak_testc-build-flow.patch added to mm-unstable branch
Message-Id: <20230330201017.73BCBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak-test: fix kmemleak_test.c build logic
has been added to the -mm mm-unstable branch.  Its filename is
     kmemleak-test-optimize-kmemleak_testc-build-flow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmemleak-test-optimize-kmemleak_testc-build-flow.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: kmemleak-test: fix kmemleak_test.c build logic
Date: Thu, 30 Mar 2023 14:09:04 +0800

kmemleak-test.c was moved to the samples directory in 1abbef4f51724
("mm,kmemleak-test.c: move kmemleak-test.c to samples dir").

If CONFIG_DEBUG_KMEMLEAK_TEST=m and CONFIG_SAMPLES is unset,
kmemleak-test.c will be unnecessarily compiled.

So move the entry for CONFIG_DEBUG_KMEMLEAK_TEST from mm/Kconfig and add a
new CONFIG_SAMPLE_KMEMLEAK in samples/ to control whether kmemleak-test.c
is built or not.

Link: https://lkml.kernel.org/r/20230330060904.292975-1-gehao@kylinos.cn
Fixes: 1abbef4f51724 ("mm,kmemleak-test.c: move kmemleak-test.c to samples dir")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Finn Behrens <me@kloenk.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: Ye Xingchen <ye.xingchen@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug          |    8 --------
 samples/Kconfig           |    7 +++++++
 samples/Makefile          |    2 +-
 samples/kmemleak/Makefile |    2 +-
 4 files changed, 9 insertions(+), 10 deletions(-)

--- a/mm/Kconfig.debug~kmemleak-test-optimize-kmemleak_testc-build-flow
+++ a/mm/Kconfig.debug
@@ -249,14 +249,6 @@ config DEBUG_KMEMLEAK_MEM_POOL_SIZE
 	  fully initialised, this memory pool acts as an emergency one
 	  if slab allocations fail.
 
-config DEBUG_KMEMLEAK_TEST
-	tristate "Simple test for the kernel memory leak detector"
-	depends on DEBUG_KMEMLEAK && m
-	help
-	  This option enables a module that explicitly leaks memory.
-
-	  If unsure, say N.
-
 config DEBUG_KMEMLEAK_DEFAULT_OFF
 	bool "Default kmemleak to off"
 	depends on DEBUG_KMEMLEAK
--- a/samples/Kconfig~kmemleak-test-optimize-kmemleak_testc-build-flow
+++ a/samples/Kconfig
@@ -273,6 +273,13 @@ config SAMPLE_CORESIGHT_SYSCFG
 	  This demonstrates how a user may create their own CoreSight
 	  configurations and easily load them into the system at runtime.
 
+config SAMPLE_KMEMLEAK
+        tristate "Simple test for the kernel memory leak detector"
+        depends on DEBUG_KMEMLEAK && m
+        help
+          Build a sample program which have explicitly leaks memory to test
+          kmemleak
+
 source "samples/rust/Kconfig"
 
 endif # SAMPLES
--- a/samples/kmemleak/Makefile~kmemleak-test-optimize-kmemleak_testc-build-flow
+++ a/samples/kmemleak/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
+obj-$(CONFIG_SAMPLE_KMEMLEAK) += kmemleak-test.o
--- a/samples/Makefile~kmemleak-test-optimize-kmemleak_testc-build-flow
+++ a/samples/Makefile
@@ -33,7 +33,7 @@ subdir-$(CONFIG_SAMPLE_VFS)		+= vfs
 obj-$(CONFIG_SAMPLE_INTEL_MEI)		+= mei/
 subdir-$(CONFIG_SAMPLE_WATCHDOG)	+= watchdog
 subdir-$(CONFIG_SAMPLE_WATCH_QUEUE)	+= watch_queue
-obj-$(CONFIG_DEBUG_KMEMLEAK_TEST)	+= kmemleak/
+obj-$(CONFIG_SAMPLE_KMEMLEAK)		+= kmemleak/
 obj-$(CONFIG_SAMPLE_CORESIGHT_SYSCFG)	+= coresight/
 obj-$(CONFIG_SAMPLE_FPROBE)		+= fprobe/
 obj-$(CONFIG_SAMPLES_RUST)		+= rust/
_

Patches currently in -mm which might be from gehao@kylinos.cn are

kmemleak-test-optimize-kmemleak_testc-build-flow.patch

