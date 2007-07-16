From: akpm@linux-foundation.org
Subject: - genericserial-remove-bogus-optimisation-check-and-dead-code-paths.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:08 -0700
Message-ID: <200707162059.l6GKx8tQ002403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756032AbXGPVSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, morten@sourcepoet.org, mm-commits@vger.kernel.org


The patch titled
     genericserial: remove bogus optimisation check and dead code paths
has been removed from the -mm tree.  Its filename was
     genericserial-remove-bogus-optimisation-check-and-dead-code-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: genericserial: remove bogus optimisation check and dead code paths
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We've been using the 'new locking' for a long time now so it seems
pointless keeping the old one around.  Remove it and undo the macros it
uses back into real code for readability.  Remove the bogus 'no termios
change' checks.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Morten Helgesen <morten@sourcepoet.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/generic_serial.c |  120 --------------------------------
 1 file changed, 3 insertions(+), 117 deletions(-)

diff -puN drivers/char/generic_serial.c~genericserial-remove-bogus-optimisation-check-and-dead-code-paths drivers/char/generic_serial.c
--- a/drivers/char/generic_serial.c~genericserial-remove-bogus-optimisation-check-and-dead-code-paths
+++ a/drivers/char/generic_serial.c
@@ -43,16 +43,6 @@ static int gs_debug;
 
 #define func_enter() gs_dprintk (GS_DEBUG_FLOW, "gs: enter %s\n", __FUNCTION__)
 #define func_exit()  gs_dprintk (GS_DEBUG_FLOW, "gs: exit  %s\n", __FUNCTION__)
-#define NEW_WRITE_LOCKING 1
-#if NEW_WRITE_LOCKING
-#define DECL      /* Nothing */
-#define LOCKIT    mutex_lock(& port->port_write_mutex);
-#define RELEASEIT mutex_unlock(&port->port_write_mutex);
-#else
-#define DECL      unsigned long flags;
-#define LOCKIT    save_flags (flags);cli ()
-#define RELEASEIT restore_flags (flags)
-#endif
 
 #define RS_EVENT_WRITE_WAKEUP	1
 
@@ -62,7 +52,6 @@ module_param(gs_debug, int, 0644);
 void gs_put_char(struct tty_struct * tty, unsigned char ch)
 {
 	struct gs_port *port;
-	DECL
 
 	func_enter (); 
 
@@ -75,11 +64,11 @@ void gs_put_char(struct tty_struct * tty
 	if (! (port->flags & ASYNC_INITIALIZED)) return;
 
 	/* Take a lock on the serial tranmit buffer! */
-	LOCKIT;
+	mutex_lock(& port->port_write_mutex);
 
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
 		/* Sorry, buffer is full, drop character. Update statistics???? -- REW */
-		RELEASEIT;
+		mutex_unlock(&port->port_write_mutex);
 		return;
 	}
 
@@ -87,13 +76,11 @@ void gs_put_char(struct tty_struct * tty
 	port->xmit_head &= SERIAL_XMIT_SIZE - 1;
 	port->xmit_cnt++;  /* Characters in buffer */
 
-	RELEASEIT;
+	mutex_unlock(&port->port_write_mutex);
 	func_exit ();
 }
 
 
-#ifdef NEW_WRITE_LOCKING
-
 /*
 > Problems to take into account are:
 >       -1- Interrupts that empty part of the buffer.
@@ -166,90 +153,6 @@ int gs_write(struct tty_struct * tty, 
 	func_exit ();
 	return total;
 }
-#else
-/*
-> Problems to take into account are:
->       -1- Interrupts that empty part of the buffer.
->       -2- page faults on the access to userspace. 
->       -3- Other processes that are also trying to do a "write". 
-*/
-
-int gs_write(struct tty_struct * tty,
-                    const unsigned char *buf, int count)
-{
-	struct gs_port *port;
-	int c, total = 0;
-	int t;
-	unsigned long flags;
-
-	func_enter ();
-
-	/* The standard serial driver returns 0 in this case. 
-	   That sounds to me as "No error, I just didn't get to writing any
-	   bytes. Feel free to try again." 
-	   The "official" way to write n bytes from buf is:
-
-		 for (nwritten = 0;nwritten < n;nwritten += rv) {
-			 rv = write (fd, buf+nwritten, n-nwritten);
-			 if (rv < 0) break; // Error: bail out. //
-		 } 
-
-	   which will loop endlessly in this case. The manual page for write
-	   agrees with me. In practise almost everybody writes 
-	   "write (fd, buf,n);" but some people might have had to deal with 
-	   incomplete writes in the past and correctly implemented it by now... 
-	 */
-
-	if (!tty) return -EIO;
-
-	port = tty->driver_data;
-	if (!port || !port->xmit_buf)
-		return -EIO;
-
-	local_save_flags(flags);
-	while (1) {
-		cli();
-		c = count;
-
-		/* This is safe because we "OWN" the "head". Noone else can 
-		   change the "head": we own the port_write_mutex. */
-		/* Don't overrun the end of the buffer */
-		t = SERIAL_XMIT_SIZE - port->xmit_head;
-		if (t < c) c = t;
-
-		/* This is safe because the xmit_cnt can only decrease. This 
-		   would increase "t", so we might copy too little chars. */
-		/* Don't copy past the "head" of the buffer */
-		t = SERIAL_XMIT_SIZE - 1 - port->xmit_cnt;
-		if (t < c) c = t;
-
-		/* Can't copy more? break out! */
-		if (c <= 0) {
-			local_restore_flags(flags);
-			break;
-		}
-		memcpy(port->xmit_buf + port->xmit_head, buf, c);
-		port->xmit_head = ((port->xmit_head + c) &
-		                   (SERIAL_XMIT_SIZE-1));
-		port->xmit_cnt += c;
-		local_restore_flags(flags);
-		buf += c;
-		count -= c;
-		total += c;
-	}
-
-	if (port->xmit_cnt && 
-	    !tty->stopped && 
-	    !tty->hw_stopped &&
-	    !(port->flags & GS_TX_INTEN)) {
-		port->flags |= GS_TX_INTEN;
-		port->rd->enable_tx_interrupts (port);
-	}
-	func_exit ();
-	return total;
-}
-
-#endif
 
 
 
@@ -737,23 +640,6 @@ void gs_set_termios (struct tty_struct *
 		gs_dprintk (GS_DEBUG_TERMIOS, "termios structure (%p):\n", tiosp);
 	}
 
-	/* This is an optimization that is only allowed for dumb cards */
-	/* Smart cards require knowledge of iflags and oflags too: that 
-	   might change hardware cooking mode.... */
-	if (old_termios) {
-		if(   (tiosp->c_iflag == old_termios->c_iflag)
-		   && (tiosp->c_oflag == old_termios->c_oflag)
-		   && (tiosp->c_cflag == old_termios->c_cflag)
-		   && (tiosp->c_lflag == old_termios->c_lflag)
-		   && (tiosp->c_line  == old_termios->c_line)
-		   && (memcmp(tiosp->c_cc, old_termios->c_cc, NCC) == 0)) {
-			gs_dprintk(GS_DEBUG_TERMIOS, "gs_set_termios: optimized away\n");
-			return /* 0 */;
-		}
-	} else 
-		gs_dprintk(GS_DEBUG_TERMIOS, "gs_set_termios: no old_termios: "
-		           "no optimization\n");
-
 	if(old_termios && (gs_debug & GS_DEBUG_TERMIOS)) {
 		if(tiosp->c_iflag != old_termios->c_iflag)  printk("c_iflag changed\n");
 		if(tiosp->c_oflag != old_termios->c_oflag)  printk("c_oflag changed\n");
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-powerpc.patch
git-ia64.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
sb1250-duartc-sb1250-duart-serial-support.patch
mbcs-remove-lots-of-global-symbols.patch
i2o_cfg_passthru-cleanup.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
stallion-remove-unneeded-lock_kernel.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch
