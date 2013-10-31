From: akpm@linux-foundation.org
Subject: [merged]
 printk-pr_debug_ratelimited-check-state-first-to-reduce-callbacks-suppressed-messages.patch removed from -mm tree
Date: Thu, 31 Oct 2013 11:00:09 -0700
Message-ID: <52729aa9.Mz8eIlsPHd9xRxnG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3JaSAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 14:00:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, krzysiek@podlesie.net, jbaron@akamai.com, gregkh@linuxfoundation.org, balbi@ti.com, joe@perches.com

Subject: [merged] printk-pr_debug_ratelimited-check-state-first-to-reduce-callbacks-suppressed-messages.patch removed from -mm tree
To: joe@perches.com,balbi@ti.com,gregkh@linuxfoundation.org,jbaron@akamai.com,krzysiek@podlesie.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 11:00:09 -0700


The patch titled
     Subject: printk: pr_debug_ratelimited: check state first to reduce "callbacks suppressed" messages
has been removed from the -mm tree.  Its filename was
     printk-pr_debug_ratelimited-check-state-first-to-reduce-callbacks-suppressed-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: pr_debug_ratelimited: check state first to reduce "callbacks suppressed" messages

pr_debug_ratelimited should be coded similarly to dev_dbg_ratelimited to
reduce the "callbacks suppressed" messages.

Add #include <linux/dynamic_debug.h> to printk.h.  Unfortunately, this new
#include must be after the prototype/declaration of function printk.

It may be better to split out these _ratelimited declarations into a
separate file one day.

Any use of these pr_<foo>_ratelimited functions must also have another
specific #include <ratelimited.h>.  Most users have this done indirectly
via #include <linux/kernel.h>

printk.h may not #include <linux/ratelimit.h> as it causes circular
dependencies and compilation failures.

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN include/linux/printk.h~printk-pr_debug_ratelimited-check-state-first-to-reduce-callbacks-suppressed-messages include/linux/printk.h
--- a/include/linux/printk.h~printk-pr_debug_ratelimited-check-state-first-to-reduce-callbacks-suppressed-messages
+++ a/include/linux/printk.h
@@ -233,6 +233,8 @@ extern asmlinkage void dump_stack(void)
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
+#include <linux/dynamic_debug.h>
+
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(CONFIG_DYNAMIC_DEBUG)
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
@@ -343,7 +345,19 @@ extern asmlinkage void dump_stack(void)
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG)
+/* descriptor check is first to prevent flooding with "callbacks suppressed" */
+#define pr_debug_ratelimited(fmt, ...)					\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT) &&	\
+	    __ratelimit(&_rs))						\
+		__dynamic_pr_debug(&descriptor, fmt, ##__VA_ARGS__);	\
+} while (0)
+#elif defined(DEBUG)
 #define pr_debug_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
_

Patches currently in -mm which might be from joe@perches.com are

kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
vsprintf-check-real-user-group-id-for-%pk.patch
get_maintainerpl-incomplete-output.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
checkpatch-add-check-for-sscanf-without-return-use.patch
checkpatch-add-check-for-sscanf-without-return-use-v2.patch
drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

