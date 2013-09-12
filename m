From: akpm@linux-foundation.org
Subject: [merged]
 revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:41:07 -0700
Message-ID: <523218d3.RfwHRU+bRlFyOXvw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3ILTlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org, david.daney@cavium.com, akpm@linux-foundation.org

Subject: [merged] revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch removed from -mm tree
To: akpm@linux-foundation.org,david.daney@cavium.com,geert@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:07 -0700


The patch titled
     Subject: include/linux/smp.h:on_each_cpu(): switch back to a C function
has been removed from the -mm tree.  Its filename was
     revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/smp.h:on_each_cpu(): switch back to a C function

Revert c846ef7deba2d4f751 ("include/linux/smp.h:on_each_cpu(): switch back
to a macro").  It turns out that the problematic linux/irqflags.h include
was fixed within ia64 and mn10300.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Daney <david.daney@cavium.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN include/linux/smp.h~revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro include/linux/smp.h
--- a/include/linux/smp.h~revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro
+++ a/include/linux/smp.h
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <linux/irqflags.h>
 
 extern void cpu_idle(void);
 
@@ -139,14 +140,17 @@ static inline int up_smp_call_function(s
 }
 #define smp_call_function(func, info, wait) \
 			(up_smp_call_function(func, info))
-#define on_each_cpu(func, info, wait)		\
-	({					\
-		unsigned long __flags;		\
-		local_irq_save(__flags);	\
-		func(info);			\
-		local_irq_restore(__flags);	\
-		0;				\
-	})
+
+static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	func(info);
+	local_irq_restore(flags);
+	return 0;
+}
+
 /*
  * Note we still need to test the mask even for UP
  * because we actually can get an empty mask from
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
mm.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

