From: akpm@linux-foundation.org
Subject: - vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:32 -0700
Message-ID: <200810182311.m9INBW3n027744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbYJRXLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, kyle@mcmartin.ca, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     vsprintf: use new vsprintf symbolic function pointer format
has been removed from the -mm tree.  Its filename was
     vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vsprintf: use new vsprintf symbolic function pointer format
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use the '%pF' format to get rid of an "#ifdef DEBUG" and make some printks
atomic.

This removes the last in-tree uses of print_fn_descriptor_symbol().  I
marked print_fn_descriptor_symbol() deprecated and scheduled it for
removal next year to give time for out-of-tree modules to be updated.

parisc's print_fn_descriptor_symbol() is currently broken there (it needs
to dereference the function pointer similar to ia64 and power).  This
patch shouldn't make anything worse, but it means we need to fix
dereference_function_descriptor() instead of print_fn_descriptor_symbol()
to get meaningful initcall_debug output.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    9 +++++++++
 drivers/base/power/main.c                  |    7 ++-----
 include/linux/kallsyms.h                   |    8 +++-----
 3 files changed, 14 insertions(+), 10 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~vsprintf-use-new-vsprintf-symbolic-function-pointer-format Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~vsprintf-use-new-vsprintf-symbolic-function-pointer-format
+++ a/Documentation/feature-removal-schedule.txt
@@ -294,6 +294,15 @@ Who:	Jiri Slaby <jirislaby@gmail.com>
 
 ---------------------------
 
+What: print_fn_descriptor_symbol()
+When: October 2009
+Why:  The %pF vsprintf format provides the same functionality in a
+      simpler way.  print_fn_descriptor_symbol() is deprecated but
+      still present to give out-of-tree modules time to change.
+Who:  Bjorn Helgaas <bjorn.helgaas@hp.com>
+
+---------------------------
+
 What:	/sys/o2cb symlink
 When:	January 2010
 Why:	/sys/fs/o2cb is the proper location for this information - /sys/o2cb
diff -puN drivers/base/power/main.c~vsprintf-use-new-vsprintf-symbolic-function-pointer-format drivers/base/power/main.c
--- a/drivers/base/power/main.c~vsprintf-use-new-vsprintf-symbolic-function-pointer-format
+++ a/drivers/base/power/main.c
@@ -778,10 +778,7 @@ EXPORT_SYMBOL_GPL(device_suspend);
 
 void __suspend_report_result(const char *function, void *fn, int ret)
 {
-	if (ret) {
-		printk(KERN_ERR "%s(): ", function);
-		print_fn_descriptor_symbol("%s returns ", fn);
-		printk("%d\n", ret);
-	}
+	if (ret)
+		printk(KERN_ERR "%s(): %pF returns %d\n", function, fn, ret);
 }
 EXPORT_SYMBOL_GPL(__suspend_report_result);
diff -puN include/linux/kallsyms.h~vsprintf-use-new-vsprintf-symbolic-function-pointer-format include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~vsprintf-use-new-vsprintf-symbolic-function-pointer-format
+++ a/include/linux/kallsyms.h
@@ -93,12 +93,10 @@ static inline void print_symbol(const ch
 }
 
 /*
- * Pretty-print a function pointer.
- *
- * ia64 and ppc64 function pointers are really function descriptors,
- * which contain a pointer the real address.
+ * Pretty-print a function pointer.  This function is deprecated.
+ * Please use the "%pF" vsprintf format instead.
  */
-static inline void print_fn_descriptor_symbol(const char *fmt, void *addr)
+static inline void __deprecated print_fn_descriptor_symbol(const char *fmt, void *addr)
 {
 #if defined(CONFIG_IA64) || defined(CONFIG_PPC64)
 	addr = *(void **)addr;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
rtc-cmos-export-second-nvram-bank.patch

