From: akpm@linux-foundation.org
Subject: - i386-fix-cmpxchg-warning.patch removed from -mm tree
Date: Wed, 28 Mar 2007 13:27:32 -0700
Message-ID: <200703282027.l2SKRWp8019330@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58417 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965757AbXC1U1g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 16:27:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     i386: fix cmpxchg warning
has been removed from the -mm tree.  Its filename was
     i386-fix-cmpxchg-warning.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: i386: fix cmpxchg warning
From: Jeff Dike <jdike@addtoit.com>

I started getting warnings from atomic.h about cmpxchg not having a prototype.
 It's declared in system.h, so including that fixes the UML build warnings and
has no noticable ill effects on the i386 build.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/atomic.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/asm-i386/atomic.h~i386-fix-cmpxchg-warning include/asm-i386/atomic.h
--- a/include/asm-i386/atomic.h~i386-fix-cmpxchg-warning
+++ a/include/asm-i386/atomic.h
@@ -3,6 +3,7 @@
 
 #include <linux/compiler.h>
 #include <asm/processor.h>
+#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-fix-epoll.patch
uml-fix-static-linking.patch
uml-use-correct-register-file-size-everywhere.patch
uml-fix-i-o-hang-when-multiple-devices-are-in-use.patch
i386-fix-cmpxchg-warning.patch
uml-fix-device-unplug-crash.patch
uml-irq-locking-fixes.patch
uml-fix-compilation-problems.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
fix-utrace-utrace-tracehook-um.patch
