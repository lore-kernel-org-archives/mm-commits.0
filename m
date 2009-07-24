From: akpm@linux-foundation.org
Subject: [obsolete] revert-serial-add-irqflags-support.patch removed from -mm tree
Date: Fri, 24 Jul 2009 13:37:09 -0700
Message-ID: <200907242037.n6OKb9ml005372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200AbZGXUiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 16:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Lee.Schermerhorn@hp.com, alan@linux.intel.com, bjorn.helgaas@hp.com, eric.whitney@hp.com, sfr@canb.auug.org.au, vikram.pandita@ti.com, mm-commits@vger.kernel.org


The patch titled
     revert serial-add-irqflags-support
has been removed from the -mm tree.  Its filename was
     revert-serial-add-irqflags-support.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert serial-add-irqflags-support
From: Andrew Morton <akpm@linux-foundation.org>

Revert

: commit 0b8d7a6fbba81ffd06de701fa6178916ee9732c3
: Author:     Vikram Pandita <vikram.pandita@ti.com>
: AuthorDate: Mon Jul 13 10:21:15 2009 +1000
: Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
: CommitDate: Mon Jul 13 10:21:15 2009 +1000
: 
:     serial-add-irqflags-support
:     
:     There is currently no provision for passing IRQ trigger flags for
:     serial IRQs with triggering requirements (such as GPIO IRQs)
:     
:     This patch adds irqflags to plat_serial8250_port that can be passed
:     from board file to reqest_irq() of 8250 driver
:     
:     Changes are backward compatible with boards passing UPF_SHARE_IRQ flag
:     
:     Tested on Zoom2 board that has IRQF_TRIGGER_RISING requirement for 8250 irq
:     

due to boot-hang report from Lee.

Cc: Vikram Pandita <vikram.pandita@ti.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Vikram Pandita <vikram.pandita@ti.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c       |   14 +++++---------
 drivers/serial/8250.h       |    1 -
 include/linux/serial_8250.h |    1 -
 include/linux/serial_core.h |    1 -
 4 files changed, 5 insertions(+), 12 deletions(-)

diff -puN drivers/serial/8250.c~revert-serial-add-irqflags-support drivers/serial/8250.c
--- a/drivers/serial/8250.c~revert-serial-add-irqflags-support
+++ a/drivers/serial/8250.c
@@ -1677,7 +1677,7 @@ static int serial_link_irq_chain(struct 
 		INIT_LIST_HEAD(&up->list);
 		i->head = &up->list;
 		spin_unlock_irq(&i->lock);
-		irq_flags |= up->port.irqflags;
+
 		ret = request_irq(up->port.irq, serial8250_interrupt,
 				  irq_flags, "serial", i);
 		if (ret < 0)
@@ -2026,7 +2026,7 @@ static int serial8250_startup(struct uar
 		 * allow register changes to become visible.
 		 */
 		spin_lock_irqsave(&up->port.lock, flags);
-		if (up->port.irqflags & IRQF_SHARED)
+		if (up->port.flags & UPF_SHARE_IRQ)
 			disable_irq_nosync(up->port.irq);
 
 		wait_for_xmitr(up, UART_LSR_THRE);
@@ -2039,7 +2039,7 @@ static int serial8250_startup(struct uar
 		iir = serial_in(up, UART_IIR);
 		serial_out(up, UART_IER, 0);
 
-		if (up->port.irqflags & IRQF_SHARED)
+		if (up->port.flags & UPF_SHARE_IRQ)
 			enable_irq(up->port.irq);
 		spin_unlock_irqrestore(&up->port.lock, flags);
 
@@ -2673,7 +2673,6 @@ static void __init serial8250_isa_init_p
 	     i++, up++) {
 		up->port.iobase   = old_serial_port[i].port;
 		up->port.irq      = irq_canonicalize(old_serial_port[i].irq);
-		up->port.irqflags = old_serial_port[i].irqflags;
 		up->port.uartclk  = old_serial_port[i].baud_base * 16;
 		up->port.flags    = old_serial_port[i].flags;
 		up->port.hub6     = old_serial_port[i].hub6;
@@ -2682,7 +2681,7 @@ static void __init serial8250_isa_init_p
 		up->port.regshift = old_serial_port[i].iomem_reg_shift;
 		set_io_from_upio(&up->port);
 		if (share_irqs)
-			up->port.irqflags |= IRQF_SHARED;
+			up->port.flags |= UPF_SHARE_IRQ;
 	}
 }
 
@@ -2872,7 +2871,6 @@ int __init early_serial_setup(struct uar
 	p->iobase       = port->iobase;
 	p->membase      = port->membase;
 	p->irq          = port->irq;
-	p->irqflags     = port->irqflags;
 	p->uartclk      = port->uartclk;
 	p->fifosize     = port->fifosize;
 	p->regshift     = port->regshift;
@@ -2946,7 +2944,6 @@ static int __devinit serial8250_probe(st
 		port.iobase		= p->iobase;
 		port.membase		= p->membase;
 		port.irq		= p->irq;
-		port.irqflags		= p->irqflags;
 		port.uartclk		= p->uartclk;
 		port.regshift		= p->regshift;
 		port.iotype		= p->iotype;
@@ -2959,7 +2956,7 @@ static int __devinit serial8250_probe(st
 		port.serial_out		= p->serial_out;
 		port.dev		= &dev->dev;
 		if (share_irqs)
-			port.irqflags |= IRQF_SHARED;
+			port.flags |= UPF_SHARE_IRQ;
 		ret = serial8250_register_port(&port);
 		if (ret < 0) {
 			dev_err(&dev->dev, "unable to register port at index %d "
@@ -3101,7 +3098,6 @@ int serial8250_register_port(struct uart
 		uart->port.iobase       = port->iobase;
 		uart->port.membase      = port->membase;
 		uart->port.irq          = port->irq;
-		uart->port.irqflags     = port->irqflags;
 		uart->port.uartclk      = port->uartclk;
 		uart->port.fifosize     = port->fifosize;
 		uart->port.regshift     = port->regshift;
diff -puN drivers/serial/8250.h~revert-serial-add-irqflags-support drivers/serial/8250.h
--- a/drivers/serial/8250.h~revert-serial-add-irqflags-support
+++ a/drivers/serial/8250.h
@@ -20,7 +20,6 @@ struct old_serial_port {
 	unsigned int baud_base;
 	unsigned int port;
 	unsigned int irq;
-	unsigned long irqflags;
 	unsigned int flags;
 	unsigned char hub6;
 	unsigned char io_type;
diff -puN include/linux/serial_8250.h~revert-serial-add-irqflags-support include/linux/serial_8250.h
--- a/include/linux/serial_8250.h~revert-serial-add-irqflags-support
+++ a/include/linux/serial_8250.h
@@ -22,7 +22,6 @@ struct plat_serial8250_port {
 	void __iomem	*membase;	/* ioremap cookie or NULL */
 	resource_size_t	mapbase;	/* resource base */
 	unsigned int	irq;		/* interrupt number */
-	unsigned long	irqflags;	/* request_irq flags */
 	unsigned int	uartclk;	/* UART clock rate */
 	void            *private_data;
 	unsigned char	regshift;	/* register shift */
diff -puN include/linux/serial_core.h~revert-serial-add-irqflags-support include/linux/serial_core.h
--- a/include/linux/serial_core.h~revert-serial-add-irqflags-support
+++ a/include/linux/serial_core.h
@@ -265,7 +265,6 @@ struct uart_port {
 	unsigned int		(*serial_in)(struct uart_port *, int);
 	void			(*serial_out)(struct uart_port *, int, int);
 	unsigned int		irq;			/* irq number */
-	unsigned long		irqflags;		/* irq flags  */
 	unsigned int		uartclk;		/* base uart clock */
 	unsigned int		fifosize;		/* tx fifo size */
 	unsigned char		x_char;			/* xon/xoff char */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-serial-add-irqflags-support.patch
revert-pty-rework-the-pty-layer-to-use-the-normal-buffering-logic.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch
x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board-cleanup.patch
dmaengine-dmatest-add-a-maximum-number-of-test-iterations-checkpatch-fixes.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse-fix.patch
scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
vfs-optimize-touch_time-too-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
include-linux-clocksourceh-coding-style-tweaks.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use-checkpatch-fixes.patch
fatfs-use-common-localtime-gmtime-in-fat_time_unix2fat-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

