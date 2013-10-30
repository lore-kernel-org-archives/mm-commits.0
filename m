From: akpm@linux-foundation.org
Subject: [failures]
 printk-mark-printk_once-test-variable-__read_mostly.patch removed from -mm
 tree
Date: Wed, 30 Oct 2013 13:48:46 -0700
Message-ID: <527170ae.kEA2IR/n8EPhtXIV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3J3Usq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 16:48:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [failures] printk-mark-printk_once-test-variable-__read_mostly.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 13:48:46 -0700


The patch titled
     Subject: printk: mark printk_once test variable __read_mostly
has been removed from the -mm tree.  Its filename was
     printk-mark-printk_once-test-variable-__read_mostly.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: mark printk_once test variable __read_mostly

It's only set once so mark it __read_mostly.

Neaten the alignment so it matches the rest of the pr_<level>_once
#defines too.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/printk.h~printk-mark-printk_once-test-variable-__read_mostly include/linux/printk.h
--- a/include/linux/printk.h~printk-mark-printk_once-test-variable-__read_mostly
+++ a/include/linux/printk.h
@@ -251,17 +251,17 @@ extern asmlinkage void dump_stack(void)
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

