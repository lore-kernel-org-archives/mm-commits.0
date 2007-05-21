From: akpm@linux-foundation.org
Subject: - usb-serial-keyspan-add-support-for-usa-49wg-usa-28xg-fix.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:33 -0700
Message-ID: <200705212317.l4LNHWQH022483@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758656AbXEUXTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, lucy@keyspan.com, mm-commits@vger.kernel.org


The patch titled
     usb-serial-keyspan-add-support-for-usa-49wg-usa-28xg-fix
has been removed from the -mm tree.  Its filename was
     usb-serial-keyspan-add-support-for-usa-49wg-usa-28xg-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb-serial-keyspan-add-support-for-usa-49wg-usa-28xg-fix
From: Andrew Morton <akpm@linux-foundation.org>

coding style, unneeded casts of void*

Cc: Greg KH <greg@kroah.com>
Cc: Lucy McCoy <lucy@keyspan.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/keyspan.c |  123 +++++++++++++++------------------
 1 files changed, 58 insertions(+), 65 deletions(-)

diff -puN drivers/usb/serial/keyspan.c~usb-serial-keyspan-add-support-for-usa-49wg-usa-28xg-fix drivers/usb/serial/keyspan.c
--- a/drivers/usb/serial/keyspan.c~usb-serial-keyspan-add-support-for-usa-49wg-usa-28xg-fix
+++ a/drivers/usb/serial/keyspan.c
@@ -861,36 +861,34 @@ static void	usa49_indat_callback(struct 
 		}
 }
 
-
-static void	usa49wg_indat_callback(struct urb *urb)
+static void usa49wg_indat_callback(struct urb *urb)
 {
 	int			i, len, x, err;
-	struct usb_serial		*serial;
-	struct usb_serial_port		*port;
-
+	struct usb_serial	*serial;
+	struct usb_serial_port	*port;
 	struct tty_struct	*tty;
 	unsigned char 		*data = urb->transfer_buffer;
 
-
 	dbg ("%s", __FUNCTION__);
 
-	serial = (struct usb_serial *) urb->context;
+	serial = urb->context;
 
 	if (urb->status) {
 		dbg("%s - nonzero status: %x", __FUNCTION__, urb->status);
 		return;
 	}
 
-	// inbound data is in the form P#, len, status, data */
-
-	i = len = 0;
+	/* inbound data is in the form P#, len, status, data */
+	i = 0;
+	len = 0;
 
 	if (urb->actual_length) {
 		while (i < urb->actual_length) {
 
 			/* Check port number from message*/
 			if (data[i] >= serial->num_ports) {
-				dbg ("%s - Unexpected port number %d", __FUNCTION__, data[i]);
+				dbg ("%s - Unexpected port number %d",
+					__FUNCTION__, data[i]);
 				return;
 			}
 			port = serial->port[data[i++]];
@@ -903,12 +901,14 @@ static void	usa49wg_indat_callback(struc
 				i++;
 				for (x = 1; x < len ; ++x)
 					if (port->open_count)
-						tty_insert_flip_char(tty, data[i++], 0);
+						tty_insert_flip_char(tty,
+								data[i++], 0);
 					else
 						i++;
-			}
-			else {
-				/* some bytes had errors, every byte has status */
+			} else {
+				/*
+				 * some bytes had errors, every byte has status
+				 */
 				for (x = 0; x + 1 < len; x += 2) {
 					int stat = data[i], flag = 0;
 					if (stat & RXERROR_OVERRUN)
@@ -919,8 +919,9 @@ static void	usa49wg_indat_callback(struc
 						flag |= TTY_PARITY;
 					/* XXX should handle break (0x10) */
 					if (port->open_count)
-						tty_insert_flip_char(tty, data[i+1], flag);
-					i+=2;
+						tty_insert_flip_char(tty,
+							data[i+1], flag);
+					i += 2;
 				}
 			}
 			if (port->open_count)
@@ -931,19 +932,18 @@ static void	usa49wg_indat_callback(struc
 	/* Resubmit urb so we continue receiving */
 	urb->dev = serial->dev;
 
-	if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err != 0)
 		dbg("%s - resubmit read urb failed. (%d)", __FUNCTION__, err);
-	}
 }
 
-
 /* not used, usa-49 doesn't have per-port control endpoints */
-static void	usa49_outcont_callback(struct urb *urb)
+static void usa49_outcont_callback(struct urb *urb)
 {
 	dbg ("%s", __FUNCTION__);
 }
 
-static void	usa90_indat_callback(struct urb *urb)
+static void usa90_indat_callback(struct urb *urb)
 {
 	int			i, err;
 	int			endpoint;
@@ -956,7 +956,6 @@ static void	usa90_indat_callback(struct 
 
 	endpoint = usb_pipeendpoint(urb->pipe);
 
-
 	if (urb->status) {
 		dbg("%s - nonzero status: %x on endpoint %d.",
 		    __FUNCTION__, urb->status, endpoint);
@@ -1082,8 +1081,6 @@ static void	usa90_outcont_callback(struc
 	}
 }
 
-
-
 /* Status messages from the 28xg */
 static void	usa67_instat_callback(struct urb *urb)
 {
@@ -1097,7 +1094,7 @@ static void	usa67_instat_callback(struct
 
 	dbg ("%s", __FUNCTION__);
 
-	serial = (struct usb_serial *) urb->context;
+	serial = urb->context;
 
 	if (urb->status) {
 		dbg("%s - nonzero status: %x", __FUNCTION__, urb->status);
@@ -1137,12 +1134,12 @@ static void	usa67_instat_callback(struct
 
 	/* Resubmit urb so we continue receiving */
 	urb->dev = serial->dev;
-	if ((err = usb_submit_urb(urb, GFP_ATOMIC)) != 0) {
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err != 0)
 		dbg("%s - resubmit read urb failed. (%d)", __FUNCTION__, err);
-	}
 }
 
-static void	usa67_glocont_callback(struct urb *urb)
+static void usa67_glocont_callback(struct urb *urb)
 {
 	struct usb_serial *serial;
 	struct usb_serial_port *port;
@@ -1151,14 +1148,15 @@ static void	usa67_glocont_callback(struc
 
 	dbg ("%s", __FUNCTION__);
 
-	serial = (struct usb_serial *) urb->context;
+	serial = urb->context;
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		p_priv = usb_get_serial_port_data(port);
 
 		if (p_priv->resend_cont) {
 			dbg ("%s - sending setup", __FUNCTION__);
-			keyspan_usa67_send_setup(serial, port, p_priv->resend_cont - 1);
+			keyspan_usa67_send_setup(serial, port,
+						p_priv->resend_cont - 1);
 			break;
 		}
 	}
@@ -1873,7 +1871,7 @@ static int keyspan_usa26_send_setup(stru
 
 	/* Save reset port val for resend.
 	   Don't overwrite resend for open/close condition. */
-	if ((reset_port+1) > p_priv->resend_cont)
+	if ((reset_port + 1) > p_priv->resend_cont)
 		p_priv->resend_cont = reset_port + 1;
 	if (this_urb->status == -EINPROGRESS) {
 		/*  dbg ("%s - already writing", __FUNCTION__); */
@@ -2024,7 +2022,7 @@ static int keyspan_usa28_send_setup(stru
 
 	/* Save reset port val for resend.
 	   Don't overwrite resend for open/close condition. */
-	if ((reset_port+1) > p_priv->resend_cont)
+	if ((reset_port + 1) > p_priv->resend_cont)
 		p_priv->resend_cont = reset_port + 1;
 	if (this_urb->status == -EINPROGRESS) {
 		dbg ("%s already writing", __FUNCTION__);
@@ -2135,8 +2133,6 @@ static int keyspan_usa49_send_setup(stru
 	struct urb				*this_urb;
 	int 					err, device_port;
 
-
-
 	dbg ("%s", __FUNCTION__);
 
 	s_priv = usb_get_serial_data(serial);
@@ -2145,7 +2141,7 @@ static int keyspan_usa49_send_setup(stru
 
 	this_urb = s_priv->glocont_urb;
 
-		/* Work out which port within the device is being setup */
+	/* Work out which port within the device is being setup */
 	device_port = port->number - port->serial->minor;
 
 	dbg("%s - endpoint %d port %d (%d)",__FUNCTION__, usb_pipeendpoint(this_urb->pipe), port->number, device_port);
@@ -2156,10 +2152,9 @@ static int keyspan_usa49_send_setup(stru
 		return -1;
 	}
 
-
 	/* Save reset port val for resend.
 	   Don't overwrite resend for open/close condition. */
-	if ((reset_port+1) > p_priv->resend_cont)
+	if ((reset_port + 1) > p_priv->resend_cont)
 		p_priv->resend_cont = reset_port + 1;
 
 	if (this_urb->status == -EINPROGRESS) {
@@ -2290,9 +2285,8 @@ static int keyspan_usa49_send_setup(stru
 			     (unsigned char *)dr, s_priv->glocont_buf, sizeof(msg),
 			     usa49_glocont_callback, serial);
 
-	}
-	else {
-		memcpy (this_urb->transfer_buffer, &msg, sizeof(msg));
+	} else {
+		memcpy(this_urb->transfer_buffer, &msg, sizeof(msg));
 	
 		/* send the data out the device on control endpoint */
 		this_urb->transfer_buffer_length = sizeof(msg);
@@ -2475,7 +2469,8 @@ static int keyspan_usa67_send_setup(stru
 
 	/* Make sure we have an urb then send the message */
 	if (this_urb == NULL) {
-		dbg("%s - oops no urb for port %d.", __FUNCTION__, port->number);
+		dbg("%s - oops no urb for port %d.", __FUNCTION__,
+			port->number);
 		return -1;
 	}
 
@@ -2489,7 +2484,7 @@ static int keyspan_usa67_send_setup(stru
 		return(-1);
 	}
 
-	memset(&msg, 0, sizeof (struct keyspan_usa67_portControlMessage));
+	memset(&msg, 0, sizeof(struct keyspan_usa67_portControlMessage));
 
 	msg.port = device_port;
 
@@ -2509,7 +2504,7 @@ static int keyspan_usa67_send_setup(stru
 		msg.setPrescaler = 0xff;
 	}
 
-	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
+	msg.lcr = (p_priv->cflag & CSTOPB) ? STOPBITS_678_2 : STOPBITS_5678_1;
 	switch (p_priv->cflag & CSIZE) {
 	case CS5:
 		msg.lcr |= USA_DATABITS_5;
@@ -2538,8 +2533,8 @@ static int keyspan_usa67_send_setup(stru
 	msg.xonChar = 17;
 	msg.xoffChar = 19;
 
-	/* Opening port */
 	if (reset_port == 1) {
+		/* Opening port */
 		msg._txOn = 1;
 		msg._txOff = 0;
 		msg.txFlush = 0;
@@ -2550,10 +2545,8 @@ static int keyspan_usa67_send_setup(stru
 		msg.rxForward = 0;
 		msg.returnStatus = 0;
 		msg.resetDataToggle = 0xff;
-	}
-
-	/* Closing port */
-	else if (reset_port == 2) {
+	} else if (reset_port == 2) {
+		/* Closing port */
 		msg._txOn = 0;
 		msg._txOff = 1;
 		msg.txFlush = 0;
@@ -2564,10 +2557,8 @@ static int keyspan_usa67_send_setup(stru
 		msg.rxForward = 0;
 		msg.returnStatus = 0;
 		msg.resetDataToggle = 0;
-	}
-
-	/* Sending intermediate configs */
-	else {
+	} else {
+		/* Sending intermediate configs */
 		msg._txOn = (! p_priv->break_on);
 		msg._txOff = 0;
 		msg.txFlush = 0;
@@ -2580,7 +2571,7 @@ static int keyspan_usa67_send_setup(stru
 		msg.resetDataToggle = 0x0;
 	}
 
-		/* Do handshaking outputs */
+	/* Do handshaking outputs */
 	msg.setTxTriState_setRts = 0xff;
 	msg.txTriState_rts = p_priv->rts_state;
 
@@ -2589,16 +2580,16 @@ static int keyspan_usa67_send_setup(stru
 
 	p_priv->resend_cont = 0;
 
-	memcpy (this_urb->transfer_buffer, &msg, sizeof(msg));
+	memcpy(this_urb->transfer_buffer, &msg, sizeof(msg));
 
 	/* send the data out the device on control endpoint */
 	this_urb->transfer_buffer_length = sizeof(msg);
 	this_urb->dev = serial->dev;
 
-	if ((err = usb_submit_urb(this_urb, GFP_ATOMIC)) != 0) {
-		dbg("%s - usb_submit_urb(setup) failed (%d)", __FUNCTION__, err);
-	}
-
+	err = usb_submit_urb(this_urb, GFP_ATOMIC);
+	if (err != 0)
+		dbg("%s - usb_submit_urb(setup) failed (%d)", __FUNCTION__,
+				err);
 	return (0);
 }
 
@@ -2679,15 +2670,17 @@ static int keyspan_startup (struct usb_s
 
 	if (s_priv->instat_urb != NULL) {
 		s_priv->instat_urb->dev = serial->dev;
-		if ((err = usb_submit_urb(s_priv->instat_urb, GFP_KERNEL)) != 0) {
-			dbg("%s - submit instat urb failed %d", __FUNCTION__, err);
-		}
+		err = usb_submit_urb(s_priv->instat_urb, GFP_KERNEL);
+		if (err != 0)
+			dbg("%s - submit instat urb failed %d", __FUNCTION__,
+				err);
 	}
 	if (s_priv->indat_urb != NULL) {
 		s_priv->indat_urb->dev = serial->dev;
-		if ((err = usb_submit_urb(s_priv->indat_urb, GFP_KERNEL)) != 0) {
-			dbg("%s - submit indat urb failed %d", __FUNCTION__, err);
-		}
+		err = usb_submit_urb(s_priv->indat_urb, GFP_KERNEL);
+		if (err != 0)
+			dbg("%s - submit indat urb failed %d", __FUNCTION__,
+				err);
 	}
 			
 	return (0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
8xx-mpc885ads-pcmcia-support-fix.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
ide-warning-fixes.patch
git-mips-fixup.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
git-ubi.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
revert-gregkh-usb-usb-make-the-autosuspend-workqueue-thread-freezable.patch
git-wireless.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
xfs-clean-up-shrinker-games.patch
git-cryptodev.patch
x86_64-allocate-sparsemem-memmap-above-4g-fix.patch
simplify-cleanup_workqueue_thread-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
pie-randomization-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
reiser4.patch
reiser4-fix.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
vdso-print-fatal-signals.patch
check_dirty_inode_list.patch
git-gccbug-fixup.patch
w1-build-fix.patch
