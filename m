From: akpm@linux-foundation.org
Subject: + i386-fix-cmpxchg-warning.patch added to -mm tree
Date: Tue, 27 Mar 2007 13:32:28 -0700
Message-ID: <200703272032.l2RKWSDI027091@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42047 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965379AbXC0Uce (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 16:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     i386: fix cmpxchg warning
has been added to the -mm tree.  Its filename is
     i386-fix-cmpxchg-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
i386-fix-cmpxchg-warning.patch
uml-fix-device-unplug-crash.patch
uml-irq-locking-fixes.patch
uml-fix-compilation-problems.patch
