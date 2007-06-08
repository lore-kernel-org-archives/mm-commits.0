From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-tidyups.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:14:46 -0700
Message-ID: <200706080614.l586Ek8w020981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984AbXFHGO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:14:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest host feedback tidyups
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-tidyups.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest host feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>

1) Sam Ravnborg says lg-objs is deprecated, use lg-y.
2) Sparse: page_tables.c unnecessary initialization
3) Lots of __force to shut sparse up: guest "physical" addresses are
   userspace virtual.
4) Change prototype of run_lguest and do cast in caller instead (when we add
   __iomem to cast, it runs over another line).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c                 |   16 ++++++++--------
 drivers/lguest/hypercalls.c           |    3 ++-
 drivers/lguest/interrupts_and_traps.c |    4 ++--
 drivers/lguest/lg.h                   |    2 +-
 drivers/lguest/lguest_user.c          |    2 +-
 drivers/lguest/page_tables.c          |    2 +-
 6 files changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/lguest/core.c~lguest-the-host-code-tidyups drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-the-host-code-tidyups
+++ a/drivers/lguest/core.c
@@ -218,7 +218,7 @@ u32 lgread_u32(struct lguest *lg, u32 ad
 
 	/* Don't let them access lguest binary */
 	if (!lguest_address_ok(lg, addr, sizeof(val))
-	    || get_user(val, (u32 __user *)addr) != 0)
+	    || get_user(val, (__force u32 __user *)addr) != 0)
 		kill_guest(lg, "bad read address %u", addr);
 	return val;
 }
@@ -226,14 +226,14 @@ u32 lgread_u32(struct lguest *lg, u32 ad
 void lgwrite_u32(struct lguest *lg, u32 addr, u32 val)
 {
 	if (!lguest_address_ok(lg, addr, sizeof(val))
-	    || put_user(val, (u32 __user *)addr) != 0)
+	    || put_user(val, (__force u32 __user *)addr) != 0)
 		kill_guest(lg, "bad write address %u", addr);
 }
 
 void lgread(struct lguest *lg, void *b, u32 addr, unsigned bytes)
 {
 	if (!lguest_address_ok(lg, addr, bytes)
-	    || copy_from_user(b, (void __user *)addr, bytes) != 0) {
+	    || copy_from_user(b, (__force void __user *)addr, bytes) != 0) {
 		/* copy_from_user should do this, but as we rely on it... */
 		memset(b, 0, bytes);
 		kill_guest(lg, "bad read address %u len %u", addr, bytes);
@@ -243,7 +243,7 @@ void lgread(struct lguest *lg, void *b, 
 void lgwrite(struct lguest *lg, u32 addr, const void *b, unsigned bytes)
 {
 	if (!lguest_address_ok(lg, addr, bytes)
-	    || copy_to_user((void __user *)addr, b, bytes) != 0)
+	    || copy_to_user((__force void __user *)addr, b, bytes) != 0)
 		kill_guest(lg, "bad write address %u len %u", addr, bytes);
 }
 
@@ -294,7 +294,7 @@ static void run_guest_once(struct lguest
 		     : "memory", "%edx", "%ecx", "%edi", "%esi");
 }
 
-int run_guest(struct lguest *lg, char *__user user)
+int run_guest(struct lguest *lg, unsigned long __user *user)
 {
 	while (!lg->dead) {
 		unsigned int cr2 = 0; /* Damn gcc */
@@ -302,8 +302,8 @@ int run_guest(struct lguest *lg, char *_
 		/* Hypercalls first: we might have been out to userspace */
 		do_hypercalls(lg);
 		if (lg->dma_is_pending) {
-			if (put_user(lg->pending_dma, (unsigned long *)user) ||
-			    put_user(lg->pending_key, (unsigned long *)user+1))
+			if (put_user(lg->pending_dma, user) ||
+			    put_user(lg->pending_key, user+1))
 				return -EFAULT;
 			return sizeof(unsigned long)*2;
 		}
@@ -420,7 +420,7 @@ static int __init init(void)
 	lock_cpu_hotplug();
 	if (cpu_has_pge) { /* We have a broader idea of "global". */
 		cpu_had_pge = 1;
-		on_each_cpu(adjust_pge, 0, 0, 1);
+		on_each_cpu(adjust_pge, (void *)0, 0, 1);
 		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
 	}
 	unlock_cpu_hotplug();
diff -puN drivers/lguest/hypercalls.c~lguest-the-host-code-tidyups drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c~lguest-the-host-code-tidyups
+++ a/drivers/lguest/hypercalls.c
@@ -83,7 +83,8 @@ static void do_hcall(struct lguest *lg, 
 		guest_set_pmd(lg, regs->edx, regs->ebx);
 		break;
 	case LHCALL_LOAD_TLS:
-		guest_load_tls(lg, (struct desc_struct __user*)regs->edx);
+		guest_load_tls(lg,
+			       (__force struct desc_struct __user*)regs->edx);
 		break;
 	case LHCALL_TS:
 		lg->ts = regs->edx;
diff -puN drivers/lguest/interrupts_and_traps.c~lguest-the-host-code-tidyups drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c~lguest-the-host-code-tidyups
+++ a/drivers/lguest/interrupts_and_traps.c
@@ -18,7 +18,7 @@ static int idt_present(u32 lo, u32 hi)
 
 static void push_guest_stack(struct lguest *lg, u32 __user **gstack, u32 val)
 {
-	lgwrite_u32(lg, (u32)--(*gstack), val);
+	lgwrite_u32(lg, (__force u32)--(*gstack), val);
 }
 
 static void set_guest_interrupt(struct lguest *lg, u32 lo, u32 hi, int has_err)
@@ -53,7 +53,7 @@ static void set_guest_interrupt(struct l
 
 	/* Change the real stack so switcher returns to trap handler */
 	lg->regs->ss = ss;
-	lg->regs->esp = (u32)gstack + lg->page_offset;
+	lg->regs->esp = (__force u32)gstack + lg->page_offset;
 	lg->regs->cs = (__KERNEL_CS|GUEST_PL);
 	lg->regs->eip = idt_address(lo, hi);
 
diff -puN drivers/lguest/lg.h~lguest-the-host-code-tidyups drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-the-host-code-tidyups
+++ a/drivers/lguest/lg.h
@@ -182,7 +182,7 @@ void lgwrite(struct lguest *lg, u32 addr
 int find_free_guest(void);
 int lguest_address_ok(const struct lguest *lg,
 		      unsigned long addr, unsigned long len);
-int run_guest(struct lguest *lg, char *__user user);
+int run_guest(struct lguest *lg, unsigned long __user *user);
 
 
 /* interrupts_and_traps.c: */
diff -puN drivers/lguest/lguest_user.c~lguest-the-host-code-tidyups drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c~lguest-the-host-code-tidyups
+++ a/drivers/lguest/lguest_user.c
@@ -65,7 +65,7 @@ static ssize_t read(struct file *file, c
 	if (lg->dma_is_pending)
 		lg->dma_is_pending = 0;
 
-	return run_guest(lg, user);
+	return run_guest(lg, (unsigned long __user *)user);
 }
 
 /* Take: pfnlimit, pgdir, start, pageoffset. */
diff -puN drivers/lguest/page_tables.c~lguest-the-host-code-tidyups drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c~lguest-the-host-code-tidyups
+++ a/drivers/lguest/page_tables.c
@@ -13,7 +13,7 @@
 #define PTES_PER_PAGE (1 << PTES_PER_PAGE_SHIFT)
 #define SWITCHER_PGD_INDEX (PTES_PER_PAGE - 1)
 
-static DEFINE_PER_CPU(spte_t *, switcher_pte_pages) = { NULL };
+static DEFINE_PER_CPU(spte_t *, switcher_pte_pages);
 #define switcher_pte_page(cpu) per_cpu(switcher_pte_pages, cpu)
 
 static unsigned vaddr_to_pgd_index(unsigned long vaddr)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space.patch
paravirt-helper-to-disable-all-io-space-fix.patch
xen-disable-all-non-virtual-devices.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-host-code-tidyups-update.patch
lguest-the-host-code-borkages.patch
lguest-faster-tls-switching.patch
lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command.patch
lguest-the-host-code-use-tsc.patch
lguest-the-host-code-use-hrtimers.patch
lguest-the-host-code-update-for-mm-simplify-boot_params.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-net-driver-include-fix.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch
lguest-documentation-infrastructure-and-chapter-i.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
