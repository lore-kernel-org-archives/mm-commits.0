From: akpm@linux-foundation.org
Subject: + printk-cache-mark-printk_once-test-variable-__read_mostly.patch added to -mm tree
Date: Tue, 05 Nov 2013 16:06:26 -0800
Message-ID: <52798802.JwHTLyL27OeFYKt8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab3KFAG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 19:06:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, james.hogan@imgtec.com, joe@perches.com

Subject: + printk-cache-mark-printk_once-test-variable-__read_mostly.patch added to -mm tree
To: joe@perches.com,james.hogan@imgtec.com
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 16:06:26 -0800


The patch titled
     Subject: printk/cache: Mark printk_once test variable __read_mostly
has been added to the -mm tree.  Its filename is
     printk-cache-mark-printk_once-test-variable-__read_mostly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-cache-mark-printk_once-test-variable-__read_mostly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-cache-mark-printk_once-test-variable-__read_mostly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk/cache: Mark printk_once test variable __read_mostly

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cache.h  |    4 ++--
 include/linux/printk.h |   19 ++++++++++---------
 2 files changed, 12 insertions(+), 11 deletions(-)

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
@@ -251,17 +252,17 @@ extern asmlinkage void dump_stack(void)
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

kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
vsprintf-check-real-user-group-id-for-%pk.patch
printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
get_maintainerpl-incomplete-output.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
checkpatch-improve-return-is-not-a-function-test.patch
checkpatch-add-check-for-sscanf-without-return-use.patch
checkpatch-add-check-for-sscanf-without-return-use-v2.patch
drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

