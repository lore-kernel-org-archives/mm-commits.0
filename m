From: akpm@linux-foundation.org
Subject: + lguest-faster-tls-switching.patch added to -mm tree
Date: Thu, 31 May 2007 14:55:30 -0700
Message-ID: <200705312155.l4VLtUoZ028981@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbXEaVzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 17:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: faster tls switching
has been added to the -mm tree.  Its filename is
     lguest-faster-tls-switching.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: faster tls switching
From: Rusty Russell <rusty@rustcorp.com.au>

1) When the Guest sets the new TLS entries, we don't need to re-verify
   the whole GDT.
2) We also don't need to copy all the GDT entries if only the TLS
   entries have changed.

Before:
Time for one context switch via pipe: 5406 (5170 - 7467)

After:
Time for one context switch via pipe: 4916 (4661 - 7004)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c     |    3 +++
 drivers/lguest/lg.h       |    2 ++
 drivers/lguest/segments.c |   20 +++++++++++++++-----
 3 files changed, 20 insertions(+), 5 deletions(-)

diff -puN drivers/lguest/core.c~lguest-faster-tls-switching drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-faster-tls-switching
+++ a/drivers/lguest/core.c
@@ -278,6 +278,9 @@ static void copy_in_guest_info(struct lg
 	/* Copy all GDT entries but the TSS. */
 	if (lg->changed & CHANGED_GDT)
 		copy_gdt(lg, pages->state.guest_gdt);
+	/* If only the TLS entries have changed, copy them. */
+	else if (lg->changed & CHANGED_GDT_TLS)
+		copy_gdt_tls(lg, pages->state.guest_gdt);
 
 	lg->changed = 0;
 }
diff -puN drivers/lguest/lg.h~lguest-faster-tls-switching drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-faster-tls-switching
+++ a/drivers/lguest/lg.h
@@ -115,6 +115,7 @@ struct lguest_pages
 
 #define CHANGED_IDT		1
 #define CHANGED_GDT		2
+#define CHANGED_GDT_TLS		4 /* Actually a subset of CHANGED_GDT */
 #define CHANGED_ALL	        3
 
 /* The private info the thread maintains about the guest. */
@@ -202,6 +203,7 @@ void setup_guest_gdt(struct lguest *lg);
 void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num);
 void guest_load_tls(struct lguest *lg, unsigned long tls_array);
 void copy_gdt(const struct lguest *lg, struct desc_struct *gdt);
+void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt);
 
 /* page_tables.c: */
 int init_guest_pagetable(struct lguest *lg, unsigned long pgtable);
diff -puN drivers/lguest/segments.c~lguest-faster-tls-switching drivers/lguest/segments.c
--- a/drivers/lguest/segments.c~lguest-faster-tls-switching
+++ a/drivers/lguest/segments.c
@@ -34,11 +34,11 @@ static void check_segment_use(struct lgu
 		kill_guest(lg, "Removed live GDT entry %u", desc);
 }
 
-static void fixup_gdt_table(struct lguest *lg)
+static void fixup_gdt_table(struct lguest *lg, unsigned start, unsigned end)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(lg->gdt); i++) {
+	for (i = start; i < end; i++) {
 		/* We never copy these ones to real gdt */
 		if (ignored_gdt(i))
 			continue;
@@ -86,6 +86,16 @@ void setup_guest_gdt(struct lguest *lg)
 	lg->gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_PL << 13);
 }
 
+/* This is a fast version for the common case where only the three TLS entries
+ * have changed. */
+void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt)
+{
+	unsigned int i;
+
+	for (i = GDT_ENTRY_TLS_MIN; i <= GDT_ENTRY_TLS_MAX; i++)
+		gdt[i] = lg->gdt[i];
+}
+
 void copy_gdt(const struct lguest *lg, struct desc_struct *gdt)
 {
 	unsigned int i;
@@ -101,7 +111,7 @@ void load_guest_gdt(struct lguest *lg, u
 		kill_guest(lg, "too many gdt entries %i", num);
 
 	lgread(lg, lg->gdt, table, num * sizeof(lg->gdt[0]));
-	fixup_gdt_table(lg);
+	fixup_gdt_table(lg, 0, ARRAY_SIZE(lg->gdt));
 	lg->changed |= CHANGED_GDT;
 }
 
@@ -110,6 +120,6 @@ void guest_load_tls(struct lguest *lg, u
 	struct desc_struct *tls = &lg->gdt[GDT_ENTRY_TLS_MIN];
 
 	lgread(lg, tls, gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
-	fixup_gdt_table(lg);
-	lg->changed |= CHANGED_GDT;
+	fixup_gdt_table(lg, GDT_ENTRY_TLS_MIN, GDT_ENTRY_TLS_MAX+1);
+	lg->changed |= CHANGED_GDT_TLS;
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-tidyups.patch
lguest-the-guest-code-tidyups-update.patch
lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit.patch
lguest-speed-up-paravirt_lazy_flush-handling.patch
lguest-more-lazy_hcalls.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-host-code-tidyups-update.patch
lguest-the-host-code-borkages.patch
lguest-faster-tls-switching.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
