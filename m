From: akpm@linux-foundation.org
Subject: [merged]
 printk-correct-timeout-comment-neaten-module_parm_desc.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:22:00 -0800
Message-ID: <54de5ce8./WNNyrWrT6pfD81z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbbBMUWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: correct timeout comment, neaten MODULE_PARM_DESC
has been removed from the -mm tree.  Its filename was
     printk-correct-timeout-comment-neaten-module_parm_desc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: correct timeout comment, neaten MODULE_PARM_DESC

Neaten the MODULE_PARAM_DESC message.
Use 30 seconds in the comment for the zap console locks timeout.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/printk/printk.c~printk-correct-timeout-comment-neaten-module_parm_desc kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-correct-timeout-comment-neaten-module_parm_desc
+++ a/kernel/printk/printk.c
@@ -935,8 +935,8 @@ static int __init ignore_loglevel_setup(
 
 early_param("ignore_loglevel", ignore_loglevel_setup);
 module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
-	"print all kernel messages to the console.");
+MODULE_PARM_DESC(ignore_loglevel,
+		 "ignore loglevel setting (prints all kernel messages to the console)");
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
@@ -1419,16 +1419,16 @@ static void call_console_drivers(int lev
 }
 
 /*
- * Zap console related locks when oopsing. Only zap at most once
- * every 10 seconds, to leave time for slow consoles to print a
- * full oops.
+ * Zap console related locks when oopsing.
+ * To leave time for slow consoles to print a full oops,
+ * only zap at most once every 30 seconds.
  */
 static void zap_locks(void)
 {
 	static unsigned long oops_timestamp;
 
 	if (time_after_eq(jiffies, oops_timestamp) &&
-			!time_after(jiffies, oops_timestamp + 30 * HZ))
+	    !time_after(jiffies, oops_timestamp + 30 * HZ))
 		return;
 
 	oops_timestamp = jiffies;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
checkpatch-improve-octal-permissions-tests.patch
checkpatch-ignore-__pure-attribute.patch
checkpatch-fix-unnecessary_kern_level-false-positive.patch
checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch
checkpatch-allow-comments-in-macros-tested-for-single-statements.patch
checkpatch-update-git-commit-message.patch
checkpatch-add-likely-unlikely-comparison-misuse-test.patch
checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch
checkpatch-add-types-for-other-os-typedefs.patch
checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces.patch
checkpatch-improve-seq_print-seq_puts-suggestion.patch
checkpatch-improve-no-space-necessary-after-cast-test.patch
checkpatch-neaten-printk_ratelimited-message-position.patch
checkpatch-add-strict-test-for-spaces-around-arithmetic.patch
checkpatch-make-sure-a-commit-reference-description-uses-parentheses.patch
checkpatch-try-to-avoid-poor-patch-subject-lines.patch
checkpatch-add-of_device_id-to-structs-that-should-be-const.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

