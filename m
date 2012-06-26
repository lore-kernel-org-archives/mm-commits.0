From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-add-interface-for-disabling-recursion-check.patch removed from -mm tree
Date: Tue, 26 Jun 2012 13:54:44 -0700
Message-ID: <20120626205445.5A721A02C5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:39826 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2FZUyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 16:54:46 -0400
Received: by yhgm50 with SMTP id m50so41686yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 13:54:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuox.liu@intel.com, hpa@zytor.com, mingo@elte.hu, tglx@tglx.de, tony.luck@intel.com, yanmin_zhang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add interface for disabling recursion check
has been removed from the -mm tree.  Its filename was
     printk-add-interface-for-disabling-recursion-check.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: ShuoX Liu <shuox.liu@intel.com>
Subject: printk: add interface for disabling recursion check

In some special scenarios such as Machine Check Exception happening during
a printk, we want to bypass the printk recursion check to print some
important information.  So we add these interfaces to printk.

1) printk_recursion_check_disable() for disabling recursion check
2) printk_recursion_check_enable() for enabling recursion check

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@tglx.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    3 +++
 kernel/printk.c        |   17 ++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff -puN include/linux/printk.h~printk-add-interface-for-disabling-recursion-check include/linux/printk.h
--- a/include/linux/printk.h~printk-add-interface-for-disabling-recursion-check
+++ a/include/linux/printk.h
@@ -49,6 +49,9 @@ static inline void console_verbose(void)
 		console_loglevel = 15;
 }
 
+void printk_recursion_check_disable(void);
+void printk_recursion_check_enable(void);
+
 struct va_format {
 	const char *fmt;
 	va_list *va;
diff -puN kernel/printk.c~printk-add-interface-for-disabling-recursion-check kernel/printk.c
--- a/kernel/printk.c~printk-add-interface-for-disabling-recursion-check
+++ a/kernel/printk.c
@@ -78,6 +78,19 @@ int console_printk[4] = {
 int oops_in_progress;
 EXPORT_SYMBOL(oops_in_progress);
 
+static atomic_t recursion_check_disabled = ATOMIC_INIT(0);
+
+void printk_recursion_check_disable(void)
+{
+	atomic_inc(&recursion_check_disabled);
+}
+
+void printk_recursion_check_enable(void)
+{
+	WARN_ON(atomic_read(&recursion_check_disabled) < 1);
+	atomic_dec(&recursion_check_disabled);
+}
+
 /*
  * console_sem protects the console_drivers list, and also
  * provides serialisation for access to the entire console
@@ -1310,7 +1323,9 @@ asmlinkage int vprintk_emit(int facility
 		 * recursion and return - but flag the recursion so that
 		 * it can be printed at the next appropriate moment:
 		 */
-		if (!oops_in_progress && !lockdep_recursing(current)) {
+		if (!atomic_read(&recursion_check_disabled)
+			&& !oops_in_progress
+			&& !lockdep_recursing(current)) {
 			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
_

Patches currently in -mm which might be from shuox.liu@intel.com are

cpuidle-move-field-disable-from-per-driver-to-per-cpu.patch
x86-mce-use-new-printk-recursion-disabling-interface.patch
x86-mce-use-new-printk-recursion-disabling-interface-fix.patch

