From: akpm@linux-foundation.org
Subject: [merged] xtensa-use-test-e-instead-of-bashism-test-a.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:21 -0700
Message-ID: <20120621192521.6A0EEA00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:59484 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759939Ab2FUTZW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:22 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so63386bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: use "test -e" instead of bashism "test -a"
has been removed from the -mm tree.  Its filename was
     xtensa-use-test-e-instead-of-bashism-test-a.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: xtensa: use "test -e" instead of bashism "test -a"

On Ubuntu, /bin/sh is a symlink to dash, which does not support "test -a".
This causes messages like

    test: 1: -a: unexpected operator
    test: 1: -a: unexpected operator

and link failures like

    (.init.text+0x132): undefined reference to `platform_init'

due to the appropriate platform code not being compiled.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/xtensa/Makefile~xtensa-use-test-e-instead-of-bashism-test-a arch/xtensa/Makefile
--- a/arch/xtensa/Makefile~xtensa-use-test-e-instead-of-bashism-test-a
+++ a/arch/xtensa/Makefile
@@ -68,8 +68,8 @@ endif
 
 # Only build variant and/or platform if it includes a Makefile
 
-buildvar := $(shell test -a $(srctree)/arch/xtensa/variants/$(VARIANT)/Makefile && echo arch/xtensa/variants/$(VARIANT)/)
-buildplf := $(shell test -a $(srctree)/arch/xtensa/platforms/$(PLATFORM)/Makefile && echo arch/xtensa/platforms/$(PLATFORM)/)
+buildvar := $(shell test -e $(srctree)/arch/xtensa/variants/$(VARIANT)/Makefile && echo arch/xtensa/variants/$(VARIANT)/)
+buildplf := $(shell test -e $(srctree)/arch/xtensa/platforms/$(PLATFORM)/Makefile && echo arch/xtensa/platforms/$(PLATFORM)/)
 
 # Find libgcc.a
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c.patch
mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch
mn10300-kernel-internalh-needs-linux-irqreturnh.patch
mn10300-kernel-trapsc-needs-linux-exporth.patch
mn10300-mm-dma-allocc-needs-linux-exporth.patch
mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch

