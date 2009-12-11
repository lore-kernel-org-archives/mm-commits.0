From: akpm@linux-foundation.org
Subject: + revert-tty-sdio_uart-use-kfifo-instead-of-the-messy-circ-stuff.patch added to -mm tree
Date: Thu, 10 Dec 2009 16:46:05 -0800
Message-ID: <200912110110.nBB1AIKb007544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758004AbZLKBKm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Dec 2009 20:10:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@linux.intel.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, gregkh@suse.de, sfr@canb.auug.org.au, stefani@seibold.net


The patch titled
     revert "tty: sdio_uart: Use kfifo instead of the messy circ stuff"
has been added to the -mm tree.  Its filename is
     revert-tty-sdio_uart-use-kfifo-instead-of-the-messy-circ-stuff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "tty: sdio_uart: Use kfifo instead of the messy circ stuff"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

: coit 73ecb640fba336cf53746eb73ab419b77655b917
: Author:     Alan Cox <alan@linux.intel.com>
: AuthorDate: Mon Nov 30 13:16:20 2009 +0000
: Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
: CommitDate: Thu Dec 10 10:16:51 2009 +1100
: 
:     tty: sdio_uart: Use kfifo instead of the messy circ stuff
:     
:     Probably all the tty code should switch to this, especially when the new
:     lockless kfifo is merged.
:     
:     Signed-off-by: Alan Cox <alan@linux.intel.com>
:     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

counter-sabotage operation.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/sdio_uart.c |   94 ++++++++++++++++++++++-----------
 1 file changed, 64 insertions(+), 30 deletions(-)

diff -puN drivers/mmc/card/sdio_uart.c~revert-tty-sdio_uart-use-kfifo-instead-of-the-messy-circ-stuff drivers/mmc/card/sdio_uart.c
--- a/drivers/mmc/card/sdio_uart.c~revert-tty-sdio_uart-use-kfifo-instead-of-the-messy-circ-stuff
+++ a/drivers/mmc/card/sdio_uart.c
@@ -33,7 +33,7 @@
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
 #include <linux/serial_reg.h>
-#include <linux/kfifo.h>
+#include <linux/circ_buf.h>
 #include <linux/gfp.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
@@ -47,9 +47,18 @@
 #define UART_NR		8	/* Number of UARTs this driver can handle */
 
 
-#define FIFO_SIZE	PAGE_SIZE
+#define UART_XMIT_SIZE	PAGE_SIZE
 #define WAKEUP_CHARS	256
 
+#define circ_empty(circ)	((circ)->head == (circ)->tail)
+#define circ_clear(circ)	((circ)->head = (circ)->tail = 0)
+
+#define circ_chars_pending(circ) \
+		(CIRC_CNT((circ)->head, (circ)->tail, UART_XMIT_SIZE))
+
+#define circ_chars_free(circ) \
+		(CIRC_SPACE((circ)->head, (circ)->tail, UART_XMIT_SIZE))
+
 
 struct uart_icount {
 	__u32	cts;
@@ -73,7 +82,7 @@ struct sdio_uart_port {
 	struct mutex		func_lock;
 	struct task_struct	*in_sdio_uart_irq;
 	unsigned int		regs_offset;
-	struct kfifo		*xmit_fifo;
+	struct circ_buf		xmit;
 	spinlock_t		write_lock;
 	struct uart_icount	icount;
 	unsigned int		uartclk;
@@ -96,9 +105,6 @@ static int sdio_uart_add_port(struct sdi
 	kref_init(&port->kref);
 	mutex_init(&port->func_lock);
 	spin_lock_init(&port->write_lock);
-	port->xmit_fifo = kfifo_alloc(FIFO_SIZE, GFP_KERNEL, &port->write_lock);
-	if (port->xmit_fifo == NULL)
-		return -ENOMEM;
 
 	spin_lock(&sdio_uart_table_lock);
 	for (index = 0; index < UART_NR; index++) {
@@ -134,7 +140,6 @@ static void sdio_uart_port_destroy(struc
 {
 	struct sdio_uart_port *port =
 		container_of(kref, struct sdio_uart_port, kref);
-	kfifo_free(port->xmit_fifo);
 	kfree(port);
 }
 
@@ -451,11 +456,9 @@ static void sdio_uart_receive_chars(stru
 
 static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 {
-	struct kfifo *xmit = port->xmit_fifo;
+	struct circ_buf *xmit = &port->xmit;
 	int count;
 	struct tty_struct *tty;
-	u8 iobuf[16];
-	int len;
 
 	if (port->x_char) {
 		sdio_out(port, UART_TX, port->x_char);
@@ -466,23 +469,26 @@ static void sdio_uart_transmit_chars(str
 
 	tty = tty_port_tty_get(&port->port);
 
-	if (tty == NULL || !kfifo_len(xmit)
-				|| tty->stopped || tty->hw_stopped) {
+	if (tty == NULL || circ_empty(xmit) ||
+			tty->stopped || tty->hw_stopped) {
 		sdio_uart_stop_tx(port);
 		tty_kref_put(tty);
 		return;
 	}
 
-	len = kfifo_get(xmit, iobuf, 16);
-	for (count = 0; count < len; count++) {
-		sdio_out(port, UART_TX, iobuf[count]);
+	count = 16;
+	do {
+		sdio_out(port, UART_TX, xmit->buf[xmit->tail]);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		port->icount.tx++;
-	}
+		if (circ_empty(xmit))
+			break;
+	} while (--count > 0);
 
-	if (len < WAKEUP_CHARS)
+	if (circ_chars_pending(xmit) < WAKEUP_CHARS)
 		tty_wakeup(tty);
 
-	if (len == 0)
+	if (circ_empty(xmit))
 		sdio_uart_stop_tx(port);
 	tty_kref_put(tty);
 }
@@ -626,6 +632,7 @@ static int sdio_uart_activate(struct tty
 {
 	struct sdio_uart_port *port =
 			container_of(tport, struct sdio_uart_port, port);
+	unsigned long page;
 	int ret;
 
 	/*
@@ -634,17 +641,22 @@ static int sdio_uart_activate(struct tty
 	 */
 	set_bit(TTY_IO_ERROR, &tty->flags);
 
-	kfifo_reset(port->xmit_fifo);
+	/* Initialise and allocate the transmit buffer. */
+	page = __get_free_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+	port->xmit.buf = (unsigned char *)page;
+	circ_clear(&port->xmit);
 
 	ret = sdio_uart_claim_func(port);
 	if (ret)
-		return ret;
+		goto err1;
 	ret = sdio_enable_func(port->func);
 	if (ret)
-		goto err1;
+		goto err2;
 	ret = sdio_claim_irq(port->func, sdio_uart_irq);
 	if (ret)
-		goto err2;
+		goto err3;
 
 	/*
 	 * Clear the FIFO buffers and disable them.
@@ -688,10 +700,12 @@ static int sdio_uart_activate(struct tty
 	sdio_uart_release_func(port);
 	return 0;
 
-err2:
+err3:
 	sdio_disable_func(port->func);
-err1:
+err2:
 	sdio_uart_release_func(port);
+err1:
+	free_page((unsigned long)port->xmit.buf);
 	return ret;
 }
 
@@ -709,9 +723,11 @@ static void sdio_uart_shutdown(struct tt
 {
 	struct sdio_uart_port *port =
 			container_of(tport, struct sdio_uart_port, port);
+	int ret;
 
-	if (sdio_uart_claim_func(port))
-		return;
+	ret = sdio_uart_claim_func(port);
+	if (ret)
+		goto skip;
 
 	sdio_uart_stop_rx(port);
 
@@ -733,6 +749,10 @@ static void sdio_uart_shutdown(struct tt
 	sdio_disable_func(port->func);
 
 	sdio_uart_release_func(port);
+
+skip:
+	/* Free the transmit buffer page. */
+	free_page((unsigned long)port->xmit.buf);
 }
 
 /**
@@ -802,12 +822,26 @@ static int sdio_uart_write(struct tty_st
 			   int count)
 {
 	struct sdio_uart_port *port = tty->driver_data;
-	int ret;
+	struct circ_buf *circ = &port->xmit;
+	int c, ret = 0;
 
 	if (!port->func)
 		return -ENODEV;
 
-	ret = kfifo_put(port->xmit_fifo, buf, count);
+	spin_lock(&port->write_lock);
+	while (1) {
+		c = CIRC_SPACE_TO_END(circ->head, circ->tail, UART_XMIT_SIZE);
+		if (count < c)
+			c = count;
+		if (c <= 0)
+			break;
+		memcpy(circ->buf + circ->head, buf, c);
+		circ->head = (circ->head + c) & (UART_XMIT_SIZE - 1);
+		buf += c;
+		count -= c;
+		ret += c;
+	}
+	spin_unlock(&port->write_lock);
 
 	if (!(port->ier & UART_IER_THRI)) {
 		int err = sdio_uart_claim_func(port);
@@ -825,13 +859,13 @@ static int sdio_uart_write(struct tty_st
 static int sdio_uart_write_room(struct tty_struct *tty)
 {
 	struct sdio_uart_port *port = tty->driver_data;
-	return FIFO_SIZE - kfifo_len(port->xmit_fifo);
+	return port ? circ_chars_free(&port->xmit) : 0;
 }
 
 static int sdio_uart_chars_in_buffer(struct tty_struct *tty)
 {
 	struct sdio_uart_port *port = tty->driver_data;
-	return kfifo_len(port->xmit_fifo);
+	return port ? circ_chars_pending(&port->xmit) : 0;
 }
 
 static void sdio_uart_send_xchar(struct tty_struct *tty, char ch)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
net-sctp-socketc-fix-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
ksm-memory-hotremove-migration-only-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
char-cyclades-fix-compiler-warning.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
revert-tty-sdio_uart-use-kfifo-instead-of-the-messy-circ-stuff.patch
kfifo-move-struct-kfifo-in-place-fix.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

