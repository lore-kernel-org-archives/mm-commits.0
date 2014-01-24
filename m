From: akpm@linux-foundation.org
Subject: [merged]
 printk-cache-mark-printk_once-test-variable-__read_mostly.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:00:55 -0800
Message-ID: <52e2b867.PI7vkGSjwPxfHJR7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, james.hogan@imgtec.com, fengguang.wu@intel.com, joe@perches.com

Subject: [merged] printk-cache-mark-printk_once-test-variable-__read_mostly.patch removed from -mm tree
To: joe@perches.com,fengguang.wu@intel.com,james.hogan@imgtec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:55 -0800


The patch titled
     Subject: printk/cache: mark printk_once test variable __read_mostly
has been removed from the -mm tree.  Its filename was
     printk-cache-mark-printk_once-test-variable-__read_mostly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk/cache: mark printk_once test variable __read_mostly

Add #include <linux/cache.h> to define __read_mostly.

Convert cache.h to use uapi/linux/kernel.h instead
of linux/kernel.h to avoid recursive #includes.

Convert the ALIGN macro to __ALIGN_KERNEL.

printk_once only sets the bool variable tested
once so mark it __read_mostly.

Neaten the alignment so it matches the rest of the
pr_<level>_once #defines too.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/processor.h |    1 +
 include/linux/cache.h             |    4 ++--
 include/linux/printk.h            |   19 ++++++++++---------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff -puN arch/ia64/include/asm/processor.h~printk-cache-mark-printk_once-test-variable-__read_mostly arch/ia64/include/asm/processor.h
--- a/arch/ia64/include/asm/processor.h~printk-cache-mark-printk_once-test-variable-__read_mostly
+++ a/arch/ia64/include/asm/processor.h
@@ -71,6 +71,7 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 #include <linux/types.h>
+#include <linux/bitops.h>
 
 #include <asm/fpu.h>
 #include <asm/page.h>
diff -puN include/linux/cache.h~printk-cache-mark-printk_once-test-variable-__read_mostly include/linux/cache.h
--- a/include/linux/cache.h~printk-cache-mark-printk_once-test-variable-__read_mostly
+++ a/include/linux/cache.h
@@ -1,11 +1,11 @@
 #ifndef __LINUX_CACHE_H
 #define __LINUX_CACHE_H
 
-#include <linux/kernel.h>
+#include <uapi/linux/kernel.h>
 #include <asm/cache.h>
 
 #ifndef L1_CACHE_ALIGN
-#define L1_CACHE_ALIGN(x) ALIGN(x, L1_CACHE_BYTES)
+#define L1_CACHE_ALIGN(x) __ALIGN_KERNEL(x, L1_CACHE_BYTES)
 #endif
 
 #ifndef SMP_CACHE_BYTES
diff -puN include/linux/printk.h~printk-cache-mark-printk_once-test-variable-__read_mostly include/linux/printk.h
--- a/include/linux/printk.h~printk-cache-mark-printk_once-test-variable-__read_mostly
+++ a/include/linux/printk.h
@@ -5,6 +5,7 @@
 #include <linux/init.h>
 #include <linux/kern_levels.h>
 #include <linux/linkage.h>
+#include <linux/cache.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
@@ -253,17 +254,17 @@ extern asmlinkage void dump_stack(void)
  */
 
 #ifdef CONFIG_PRINTK
-#define printk_once(fmt, ...)			\
-({						\
-	static bool __print_once;		\
-						\
-	if (!__print_once) {			\
-		__print_once = true;		\
-		printk(fmt, ##__VA_ARGS__);	\
-	}					\
+#define printk_once(fmt, ...)					\
+({								\
+	static bool __print_once __read_mostly;			\
+								\
+	if (!__print_once) {					\
+		__print_once = true;				\
+		printk(fmt, ##__VA_ARGS__);			\
+	}							\
 })
 #else
-#define printk_once(fmt, ...)			\
+#define printk_once(fmt, ...)					\
 	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

