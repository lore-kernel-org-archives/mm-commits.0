From: akpm@linux-foundation.org
Subject: - mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:23:57 -0700
Message-ID: <200807182323.m6INNvAF004148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756611AbYGRXYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:24:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     MN10300: Fix MN10300's serial port driver to get at its tty_struct
has been removed from the -mm tree.  Its filename was
     mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MN10300: Fix MN10300's serial port driver to get at its tty_struct
From: David Howells <dhowells@redhat.com>

Fix MN10300's serial port driver to get at its tty_struct as this moved from
struct uart_info into struct tty_port in patch:

	commit 2500487cb5b4dbee56e127d699d14101016c5031
	Author: Alan Cox <alan@redhat.com>
	Date:   Fri Jul 11 17:23:39 2008 +1000

	    07-serial-core-use-tty_port

	    Switch the serial_core based drivers to use the new tty_port
	    structure. We can't quite use all of it yet because of the
	    dynamically allocated extras in the serial_core layer.

	    Signed-off-by: Alan Cox <alan@redhat.com>

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/mn10300-serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mn10300/kernel/mn10300-serial.c~mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct arch/mn10300/kernel/mn10300-serial.c
--- a/arch/mn10300/kernel/mn10300-serial.c~mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct
+++ a/arch/mn10300/kernel/mn10300-serial.c
@@ -392,7 +392,7 @@ static int mask_test_and_clear(volatile 
 static void mn10300_serial_receive_interrupt(struct mn10300_serial_port *port)
 {
 	struct uart_icount *icount = &port->uart.icount;
-	struct tty_struct *tty = port->uart.info->tty;
+	struct tty_struct *tty = port->uart.info->port.tty;
 	unsigned ix;
 	int count;
 	u8 st, ch, push, status, overrun;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
netfilter-fix-xt_times-time_mts-use-of-do_div.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state-checkpatch-fixes.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

