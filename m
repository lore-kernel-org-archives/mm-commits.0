From: akpm@linux-foundation.org
Subject: + vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch added to -mm tree
Date: Tue, 26 Aug 2008 17:41:43 -0700
Message-ID: <200808270041.m7R0fhx6003654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbYH0Alw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 20:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, kyle@mcmartin.ca, rjw@sisk.pl


The patch titled
     vsprintf: use new vsprintf symbolic function pointer format
has been added to the -mm tree.  Its filename is
     vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 drivers/base/power/main.c                  |    7 ++-----
 drivers/pci/quirks.c                       |    5 +----
 include/linux/kallsyms.h                   |    8 +++-----
 init/main.c                                |   14 ++++++--------
 5 files changed, 20 insertions(+), 22 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~vsprintf-use-new-vsprintf-symbolic-function-pointer-format Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~vsprintf-use-new-vsprintf-symbolic-function-pointer-format
+++ a/Documentation/feature-removal-schedule.txt
@@ -302,3 +302,11 @@ Why:  Accounting can now be enabled/disa
       controlled by a kernel/module/sysfs/sysctl parameter.
 Who:  Krzysztof Piotr Oledzki <ole@ans.pl>
 
+---------------------------
+
+What: print_fn_descriptor_symbol()
+When: October 2009
+Why:  The %pF vsprintf format provides the same functionality in a
+      simpler way.  print_fn_descriptor_symbol() is deprecated but
+      still present to give out-of-tree modules time to change.
+Who:  Bjorn Helgaas <bjorn.helgaas@hp.com>
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
diff -puN drivers/pci/quirks.c~vsprintf-use-new-vsprintf-symbolic-function-pointer-format drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~vsprintf-use-new-vsprintf-symbolic-function-pointer-format
+++ a/drivers/pci/quirks.c
@@ -1560,10 +1560,7 @@ static void pci_do_fixups(struct pci_dev
 	while (f < end) {
 		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
  		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
-#ifdef DEBUG
-			dev_dbg(&dev->dev, "calling ");
-			print_fn_descriptor_symbol("%s\n", f->hook);
-#endif
+			dev_dbg(&dev->dev, "calling %pF\n", f->hook);
 			f->hook(dev);
 		}
 		f++;
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
diff -puN init/main.c~vsprintf-use-new-vsprintf-symbolic-function-pointer-format init/main.c
--- a/init/main.c~vsprintf-use-new-vsprintf-symbolic-function-pointer-format
+++ a/init/main.c
@@ -730,7 +730,7 @@ int do_one_initcall(initcall_t fn)
 	int result;
 
 	if (initcall_debug) {
-		print_fn_descriptor_symbol("calling  %s\n", fn);
+		printk("calling  %pF\n", fn);
 		t0 = ktime_get();
 	}
 
@@ -740,9 +740,8 @@ int do_one_initcall(initcall_t fn)
 		t1 = ktime_get();
 		delta = ktime_sub(t1, t0);
 
-		print_fn_descriptor_symbol("initcall %s", fn);
-		printk(" returned %d after %Ld msecs\n", result,
-			(unsigned long long) delta.tv64 >> 20);
+		printk("initcall %pF returned %d after %Ld msecs\n", fn,
+		       result, (unsigned long long) delta.tv64 >> 20);
 	}
 
 	msgbuf[0] = 0;
@@ -758,10 +757,9 @@ int do_one_initcall(initcall_t fn)
 		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
 		local_irq_enable();
 	}
-	if (msgbuf[0]) {
-		print_fn_descriptor_symbol(KERN_WARNING "initcall %s", fn);
-		printk(" returned with %s\n", msgbuf);
-	}
+	if (msgbuf[0])
+		printk(KERN_WARNING "initcall %pF returned with %s\n",
+		       fn, msgbuf);
 
 	return result;
 }
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
pnp-remove-printk-with-outdated-version.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch
firmware-use-dev_printk-when-possible.patch
resources-tidy-__request_region.patch

