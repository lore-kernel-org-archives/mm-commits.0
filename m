From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-tidyups-update.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:14:49 -0700
Message-ID: <200706080614.l586EnhY020984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbXFHGPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     lguest: host code tidyups
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-tidyups-update.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest: host code tidyups
From: Rusty Russell <rusty@rustcorp.com.au>

Christoph Hellwig said runs sparse:
1) page_tables.c unnecessary initialization
2) Change prototype of run_lguest and do cast in caller instead (when we add
   __user to cast, it runs over another line).
Al Viro pointed out the ugly cast in push_lguest_stack():
3) Stick with unsigned long for arg, removes 4 casts in total.

Most importantly, I now realize that Christoph's incorrect ranting
about lgread_u32 et al was in fact a subtle ploy to make me diagnose
the real issue: sparse 0.3 complains about casting a __user pointer
to/from u32, but not an "unsigned long".  They are (currently)
equivalent for lguest, but this is a much better solution than __force.

Kudos, Christoph, for such masterful manipulation!

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c                 |   27 +++++++++---------
 drivers/lguest/hypercalls.c           |   10 ++----
 drivers/lguest/interrupts_and_traps.c |   13 ++++----
 drivers/lguest/io.c                   |    2 -
 drivers/lguest/lg.h                   |   35 +++++++++++-------------
 drivers/lguest/segments.c             |    6 ++--
 include/linux/lguest_launcher.h       |    2 -
 7 files changed, 47 insertions(+), 48 deletions(-)

diff -puN drivers/lguest/core.c~lguest-the-host-code-tidyups-update drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-the-host-code-tidyups-update
+++ a/drivers/lguest/core.c
@@ -212,39 +212,40 @@ int lguest_address_ok(const struct lgues
 }
 
 /* Just like get_user, but don't let guest access lguest binary. */
-u32 lgread_u32(struct lguest *lg, u32 addr)
+u32 lgread_u32(struct lguest *lg, unsigned long addr)
 {
 	u32 val = 0;
 
 	/* Don't let them access lguest binary */
 	if (!lguest_address_ok(lg, addr, sizeof(val))
-	    || get_user(val, (__force u32 __user *)addr) != 0)
-		kill_guest(lg, "bad read address %u", addr);
+	    || get_user(val, (u32 __user *)addr) != 0)
+		kill_guest(lg, "bad read address %#lx", addr);
 	return val;
 }
 
-void lgwrite_u32(struct lguest *lg, u32 addr, u32 val)
+void lgwrite_u32(struct lguest *lg, unsigned long addr, u32 val)
 {
 	if (!lguest_address_ok(lg, addr, sizeof(val))
-	    || put_user(val, (__force u32 __user *)addr) != 0)
-		kill_guest(lg, "bad write address %u", addr);
+	    || put_user(val, (u32 __user *)addr) != 0)
+		kill_guest(lg, "bad write address %#lx", addr);
 }
 
-void lgread(struct lguest *lg, void *b, u32 addr, unsigned bytes)
+void lgread(struct lguest *lg, void *b, unsigned long addr, unsigned bytes)
 {
 	if (!lguest_address_ok(lg, addr, bytes)
-	    || copy_from_user(b, (__force void __user *)addr, bytes) != 0) {
+	    || copy_from_user(b, (void __user *)addr, bytes) != 0) {
 		/* copy_from_user should do this, but as we rely on it... */
 		memset(b, 0, bytes);
-		kill_guest(lg, "bad read address %u len %u", addr, bytes);
+		kill_guest(lg, "bad read address %#lx len %u", addr, bytes);
 	}
 }
 
-void lgwrite(struct lguest *lg, u32 addr, const void *b, unsigned bytes)
+void lgwrite(struct lguest *lg, unsigned long addr, const void *b,
+	     unsigned bytes)
 {
 	if (!lguest_address_ok(lg, addr, bytes)
-	    || copy_to_user((__force void __user *)addr, b, bytes) != 0)
-		kill_guest(lg, "bad write address %u len %u", addr, bytes);
+	    || copy_to_user((void __user *)addr, b, bytes) != 0)
+		kill_guest(lg, "bad write address %#lx len %u", addr, bytes);
 }
 
 static void set_ts(void)
@@ -367,7 +368,7 @@ int run_guest(struct lguest *lg, unsigne
 		if (deliver_trap(lg, lg->regs->trapnum))
 			continue;
 
-		kill_guest(lg, "unhandled trap %i at %#x (%#x)",
+		kill_guest(lg, "unhandled trap %li at %#lx (%#lx)",
 			   lg->regs->trapnum, lg->regs->eip,
 			   lg->regs->trapnum == 14 ? cr2 : lg->regs->errcode);
 	}
diff -puN drivers/lguest/hypercalls.c~lguest-the-host-code-tidyups-update drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c~lguest-the-host-code-tidyups-update
+++ a/drivers/lguest/hypercalls.c
@@ -83,8 +83,7 @@ static void do_hcall(struct lguest *lg, 
 		guest_set_pmd(lg, regs->edx, regs->ebx);
 		break;
 	case LHCALL_LOAD_TLS:
-		guest_load_tls(lg,
-			       (__force struct desc_struct __user*)regs->edx);
+		guest_load_tls(lg, regs->edx);
 		break;
 	case LHCALL_TS:
 		lg->ts = regs->edx;
@@ -93,7 +92,7 @@ static void do_hcall(struct lguest *lg, 
 		lg->halted = 1;
 		break;
 	default:
-		kill_guest(lg, "Bad hypercall %i\n", regs->eax);
+		kill_guest(lg, "Bad hypercall %li\n", regs->eax);
 	}
 }
 
@@ -138,15 +137,14 @@ static void do_async_hcalls(struct lgues
 static void initialize(struct lguest *lg)
 {
 	if (lg->regs->eax != LHCALL_LGUEST_INIT) {
-		kill_guest(lg, "hypercall %i before LGUEST_INIT",
+		kill_guest(lg, "hypercall %li before LGUEST_INIT",
 			   lg->regs->eax);
 		return;
 	}
 
 	lg->lguest_data = (struct lguest_data __user *)lg->regs->edx;
 	/* We check here so we can simply copy_to_user/from_user */
-	if (!lguest_address_ok(lg, (long)lg->lguest_data,
-			       sizeof(*lg->lguest_data))) {
+	if (!lguest_address_ok(lg, lg->regs->edx, sizeof(*lg->lguest_data))) {
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 		return;
 	}
diff -puN drivers/lguest/interrupts_and_traps.c~lguest-the-host-code-tidyups-update drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c~lguest-the-host-code-tidyups-update
+++ a/drivers/lguest/interrupts_and_traps.c
@@ -16,24 +16,25 @@ static int idt_present(u32 lo, u32 hi)
 	return (hi & 0x8000);
 }
 
-static void push_guest_stack(struct lguest *lg, u32 __user **gstack, u32 val)
+static void push_guest_stack(struct lguest *lg, unsigned long *gstack, u32 val)
 {
-	lgwrite_u32(lg, (__force u32)--(*gstack), val);
+	*gstack -= 4;
+	lgwrite_u32(lg, *gstack, val);
 }
 
 static void set_guest_interrupt(struct lguest *lg, u32 lo, u32 hi, int has_err)
 {
-	u32 __user *gstack;
+	unsigned long gstack;
 	u32 eflags, ss, irq_enable;
 
 	/* If they want a ring change, we use new stack and push old ss/esp */
 	if ((lg->regs->ss&0x3) != GUEST_PL) {
-		gstack = (u32 __user *)guest_pa(lg, lg->esp1);
+		gstack = guest_pa(lg, lg->esp1);
 		ss = lg->ss1;
 		push_guest_stack(lg, &gstack, lg->regs->ss);
 		push_guest_stack(lg, &gstack, lg->regs->esp);
 	} else {
-		gstack = (u32 __user *)guest_pa(lg, lg->regs->esp);
+		gstack = guest_pa(lg, lg->regs->esp);
 		ss = lg->regs->ss;
 	}
 
@@ -53,7 +54,7 @@ static void set_guest_interrupt(struct l
 
 	/* Change the real stack so switcher returns to trap handler */
 	lg->regs->ss = ss;
-	lg->regs->esp = (__force u32)gstack + lg->page_offset;
+	lg->regs->esp = gstack + lg->page_offset;
 	lg->regs->cs = (__KERNEL_CS|GUEST_PL);
 	lg->regs->eip = idt_address(lo, hi);
 
diff -puN drivers/lguest/io.c~lguest-the-host-code-tidyups-update drivers/lguest/io.c
--- a/drivers/lguest/io.c~lguest-the-host-code-tidyups-update
+++ a/drivers/lguest/io.c
@@ -52,7 +52,7 @@ static int check_dma_list(struct lguest 
 	return 1;
 
 kill:
-	kill_guest(lg, "bad DMA entry: %u@%#x", dma->len[i], dma->addr[i]);
+	kill_guest(lg, "bad DMA entry: %u@%#lx", dma->len[i], dma->addr[i]);
 	return 0;
 }
 
diff -puN drivers/lguest/lg.h~lguest-the-host-code-tidyups-update drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-the-host-code-tidyups-update
+++ a/drivers/lguest/lg.h
@@ -25,18 +25,18 @@
 struct lguest_regs
 {
 	/* Manually saved part. */
-	u32 ebx, ecx, edx;
-	u32 esi, edi, ebp;
-	u32 gs;
-	u32 eax;
-	u32 fs, ds, es;
-	u32 trapnum, errcode;
+	unsigned long ebx, ecx, edx;
+	unsigned long esi, edi, ebp;
+	unsigned long gs;
+	unsigned long eax;
+	unsigned long fs, ds, es;
+	unsigned long trapnum, errcode;
 	/* Trap pushed part */
-	u32 eip;
-	u32 cs;
-	u32 eflags;
-	u32 esp;
-	u32 ss;
+	unsigned long eip;
+	unsigned long cs;
+	unsigned long eflags;
+	unsigned long esp;
+	unsigned long ss;
 };
 
 void free_pagetables(void);
@@ -175,10 +175,10 @@ extern struct lguest lguests[];
 extern struct mutex lguest_lock;
 
 /* core.c: */
-u32 lgread_u32(struct lguest *lg, u32 addr);
-void lgwrite_u32(struct lguest *lg, u32 val, u32 addr);
-void lgread(struct lguest *lg, void *buf, u32 addr, unsigned bytes);
-void lgwrite(struct lguest *lg, u32 addr, const void *buf, unsigned bytes);
+u32 lgread_u32(struct lguest *lg, unsigned long addr);
+void lgwrite_u32(struct lguest *lg, unsigned long addr, u32 val);
+void lgread(struct lguest *lg, void *buf, unsigned long addr, unsigned len);
+void lgwrite(struct lguest *lg, unsigned long, const void *buf, unsigned len);
 int find_free_guest(void);
 int lguest_address_ok(const struct lguest *lg,
 		      unsigned long addr, unsigned long len);
@@ -199,9 +199,8 @@ void copy_traps(const struct lguest *lg,
 /* segments.c: */
 void setup_default_gdt_entries(struct lguest_ro_state *state);
 void setup_guest_gdt(struct lguest *lg);
-void load_guest_gdt(struct lguest *lg, u32 table, u32 num);
-void guest_load_tls(struct lguest *lg,
-		    const struct desc_struct __user *tls_array);
+void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num);
+void guest_load_tls(struct lguest *lg, unsigned long tls_array);
 void copy_gdt(const struct lguest *lg, struct desc_struct *gdt);
 
 /* page_tables.c: */
diff -puN drivers/lguest/segments.c~lguest-the-host-code-tidyups-update drivers/lguest/segments.c
--- a/drivers/lguest/segments.c~lguest-the-host-code-tidyups-update
+++ a/drivers/lguest/segments.c
@@ -95,7 +95,7 @@ void copy_gdt(const struct lguest *lg, s
 			gdt[i] = lg->gdt[i];
 }
 
-void load_guest_gdt(struct lguest *lg, u32 table, u32 num)
+void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num)
 {
 	if (num > ARRAY_SIZE(lg->gdt))
 		kill_guest(lg, "too many gdt entries %i", num);
@@ -105,11 +105,11 @@ void load_guest_gdt(struct lguest *lg, u
 	lg->changed |= CHANGED_GDT;
 }
 
-void guest_load_tls(struct lguest *lg, const struct desc_struct __user *gtls)
+void guest_load_tls(struct lguest *lg, unsigned long gtls)
 {
 	struct desc_struct *tls = &lg->gdt[GDT_ENTRY_TLS_MIN];
 
-	lgread(lg, tls, (u32)gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
+	lgread(lg, tls, gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
 	fixup_gdt_table(lg);
 	lg->changed |= CHANGED_GDT;
 }
diff -puN include/linux/lguest_launcher.h~lguest-the-host-code-tidyups-update include/linux/lguest_launcher.h
--- a/include/linux/lguest_launcher.h~lguest-the-host-code-tidyups-update
+++ a/include/linux/lguest_launcher.h
@@ -13,7 +13,7 @@ struct lguest_dma
 {
 	/* 0 if free to be used, filled by hypervisor. */
  	u32 used_len;
-	u32 addr[LGUEST_MAX_DMA_SECTIONS];
+	unsigned long addr[LGUEST_MAX_DMA_SECTIONS];
 	u16 len[LGUEST_MAX_DMA_SECTIONS];
 };
 
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
