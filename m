Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4D6C77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjDRXeL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjDRXd7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC35B9008
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E1C6639F5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3385C4339B;
        Tue, 18 Apr 2023 23:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860834;
        bh=SX8btnR+xEEt5ZaBAGbQXG0ET9XzJdQ49HNTjpJhK40=;
        h=Date:To:From:Subject:From;
        b=oVS/mFs37ZTBOjJRNG0T1+8iXZUe0pl1Q6sGUL5VXXIrIZrzp3E1LEqZuzdFEpFby
         Jc+E+UYAfw3oAsAukffHGIAYZS1SG45pfsMF/rXp4Jo+hS3IhBSqUJVpUijGhrF8vy
         MhMc0vLFcHv/guJ6DO/4PCPtkktNqCwc2STbAw/Q=
Date:   Tue, 18 Apr 2023 16:33:54 -0700
To:     mm-commits@vger.kernel.org, ye.xingchen@zte.com.cn,
        ojeda@kernel.org, me@kloenk.dev, mark.rutland@arm.com,
        jgg@ziepe.ca, gregkh@linuxfoundation.org, catalin.marinas@arm.com,
        arnd@arndb.de, alex.williamson@redhat.com, alex.gaynor@gmail.com,
        akrowiak@linux.ibm.com, gehao@kylinos.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmemleak-test-optimize-kmemleak_testc-build-flow.patch removed from -mm tree
Message-Id: <20230418233354.B3385C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmemleak-test: fix kmemleak_test.c build logic
has been removed from the -mm tree.  Its filename was
     kmemleak-test-optimize-kmemleak_testc-build-flow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


