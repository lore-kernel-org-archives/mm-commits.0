From: akpm@linux-foundation.org
Subject: - uml-fix-boot-crash.patch removed from -mm tree
Date: Wed, 23 Jul 2008 14:02:51 -0700
Message-ID: <200807232102.m6NL2pDS011794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363AbYGWVDH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 17:03:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     uml: fix boot crash
has been removed from the -mm tree.  Its filename was
     uml-fix-boot-crash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix boot crash
From: Jeff Dike <jdike@addtoit.com>

My copying of linux/init.h didn't go far enough.  The definition of __used
singled out gcc minor version 3, but didn't care what the major version
was.  This broke when unit-at-a-time was added and gcc started throwing
out initcalls.

This results in an early boot crash when ptrace tries to initialize a
process with an empty, uninitialized register set.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/init.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/um/include/init.h~uml-fix-boot-crash arch/um/include/init.h
--- a/arch/um/include/init.h~uml-fix-boot-crash
+++ a/arch/um/include/init.h
@@ -45,6 +45,8 @@ typedef void (*exitcall_t)(void);
 # define __section(S) __attribute__ ((__section__(#S)))
 #endif
 
+#if __GNUC__ == 3
+
 #if __GNUC_MINOR__ >= 3
 # define __used			__attribute__((__used__))
 #else
@@ -52,6 +54,12 @@ typedef void (*exitcall_t)(void);
 #endif
 
 #else
+#if __GNUC__ == 4
+# define __used			__attribute__((__used__))
+#endif
+#endif
+
+#else
 #include <linux/compiler.h>
 #endif
 /* These are for everybody (although not all archs will actually
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-next.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch
kernel-call-constructors-uml-fix-1.patch
kernel-call-constructors-uml-fix-2.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
um-use-generic-show_mem.patch

