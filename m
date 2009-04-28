From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 28 Apr 2009 12:20:05 -0700
Message-ID: <200904281920.n3SJK5k3018058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbZD1TVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 15:21:11 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n3SJK5BB030910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2009 12:20:41 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kvm/kvm-ia64.c        |   21 -----------
 arch/x86/kvm/mmu.c              |    4 --
 drivers/usb/serial/cypress_m8.c |    8 ----
 drivers/usb/serial/option.c     |    4 --
 drivers/usb/serial/sierra.c     |   44 -----------------------
 drivers/usb/serial/usb-serial.c |   56 ------------------------------
 fs/exec.c                       |    4 --
 include/linux/kvm.h             |    3 -
 8 files changed, 144 deletions(-)

diff -puN arch/ia64/kvm/kvm-ia64.c~linux-next-git-rejects arch/ia64/kvm/kvm-ia64.c
--- a/arch/ia64/kvm/kvm-ia64.c~linux-next-git-rejects
+++ a/arch/ia64/kvm/kvm-ia64.c
@@ -661,16 +661,6 @@ again:
 		goto out;
 	}
 
-<<<<<<< HEAD:arch/ia64/kvm/kvm-ia64.c
-	/*
-	 * down_read() may sleep and return with interrupts enabled
-	 */
-	down_read(&vcpu->kvm->slots_lock);
-
-	preempt_disable();
-	local_irq_disable();
-
-=======
 	preempt_disable();
 	local_irq_disable();
 
@@ -678,7 +668,6 @@ again:
 	host_ctx = kvm_get_host_context(vcpu);
 	guest_ctx = kvm_get_guest_context(vcpu);
 
->>>>>>> FETCH_HEAD:arch/ia64/kvm/kvm-ia64.c
 	vcpu->guest_mode = 1;
 
 	r = kvm_vcpu_pre_transition(vcpu);
@@ -687,15 +676,6 @@ again:
 
 	up_read(&vcpu->kvm->slots_lock);
 	kvm_guest_enter();
-<<<<<<< HEAD:arch/ia64/kvm/kvm-ia64.c
-	r = vti_vcpu_run(vcpu, kvm_run);
-	if (r < 0) {
-		local_irq_enable();
-		preempt_enable();
-		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
-		goto out;
-	}
-=======
 
 	/*
 	 * Transition to the guest
@@ -703,7 +683,6 @@ again:
 	kvm_vmm_info->tramp_entry(host_ctx, guest_ctx);
 
 	kvm_vcpu_post_transition(vcpu);
->>>>>>> FETCH_HEAD:arch/ia64/kvm/kvm-ia64.c
 
 	vcpu->arch.launched = 1;
 	vcpu->guest_mode = 0;
diff -puN arch/x86/kvm/mmu.c~linux-next-git-rejects arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~linux-next-git-rejects
+++ a/arch/x86/kvm/mmu.c
@@ -1241,10 +1241,6 @@ static struct kvm_mmu_page *kvm_mmu_get_
 	pgprintk("%s: adding gfn %lx role %x\n", __func__, gfn, role.word);
 	sp->gfn = gfn;
 	sp->role = role;
-<<<<<<< HEAD:arch/x86/kvm/mmu.c
-	sp->global = 0;
-=======
->>>>>>> FETCH_HEAD:arch/x86/kvm/mmu.c
 	hlist_add_head(&sp->hash_link, bucket);
 	if (!direct) {
 		if (rmap_write_protect(vcpu->kvm, gfn))
diff -puN drivers/usb/serial/cypress_m8.c~linux-next-git-rejects drivers/usb/serial/cypress_m8.c
--- a/drivers/usb/serial/cypress_m8.c~linux-next-git-rejects
+++ a/drivers/usb/serial/cypress_m8.c
@@ -659,15 +659,7 @@ static int cypress_open(struct tty_struc
 	priv->rx_flags = 0;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-<<<<<<< HEAD:drivers/usb/serial/cypress_m8.c
-	/* raise both lines and set termios */
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->line_control = CONTROL_DTR | CONTROL_RTS;
-	priv->cmd_ctrl = 1;
-	spin_unlock_irqrestore(&priv->lock, flags);
-=======
 	/* Set termios */
->>>>>>> FETCH_HEAD:drivers/usb/serial/cypress_m8.c
 	result = cypress_write(tty, port, NULL, 0);
 
 	if (result) {
diff -puN drivers/usb/serial/option.c~linux-next-git-rejects drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~linux-next-git-rejects
+++ a/drivers/usb/serial/option.c
@@ -949,11 +949,7 @@ static int option_open(struct tty_struct
 				usb_pipeout(urb->pipe), 0); */
 	}
 
-<<<<<<< HEAD:drivers/usb/serial/option.c
-	option_send_setup(tty, port);
-=======
 	option_send_setup(port);
->>>>>>> FETCH_HEAD:drivers/usb/serial/option.c
 
 	return 0;
 }
diff -puN drivers/usb/serial/sierra.c~linux-next-git-rejects drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~linux-next-git-rejects
+++ a/drivers/usb/serial/sierra.c
@@ -251,40 +251,6 @@ static int sierra_send_setup(struct usb_
 
 	portdata = usb_get_serial_port_data(port);
 
-<<<<<<< HEAD:drivers/usb/serial/sierra.c
-	if (tty) {
-		int val = 0;
-		if (portdata->dtr_state)
-			val |= 0x01;
-		if (portdata->rts_state)
-			val |= 0x02;
-
-		/* If composite device then properly report interface */
-		if (serial->num_ports == 1) {
-			interface = sierra_calc_interface(serial);
-
-			/* Control message is sent only to interfaces with
-			 * interrupt_in endpoints
-			 */
-			if (port->interrupt_in_urb) {
-				/* send control message */
-				return usb_control_msg(serial->dev,
-					usb_rcvctrlpipe(serial->dev, 0),
-					0x22, 0x21, val, interface,
-					NULL, 0, USB_CTRL_SET_TIMEOUT);
-			}
-		}
-
-		/* Otherwise the need to do non-composite mapping */
-		else {
-			if (port->bulk_out_endpointAddress == 2)
-				interface = 0;
-			else if (port->bulk_out_endpointAddress == 4)
-				interface = 1;
-			else if (port->bulk_out_endpointAddress == 5)
-				interface = 2;
-
-=======
 	if (portdata->dtr_state)
 		val |= 0x01;
 	if (portdata->rts_state)
@@ -299,15 +265,10 @@ static int sierra_send_setup(struct usb_
 		 */
 		if (port->interrupt_in_urb) {
 			/* send control message */
->>>>>>> FETCH_HEAD:drivers/usb/serial/sierra.c
 			return usb_control_msg(serial->dev,
 				usb_rcvctrlpipe(serial->dev, 0),
 				0x22, 0x21, val, interface,
 				NULL, 0, USB_CTRL_SET_TIMEOUT);
-<<<<<<< HEAD:drivers/usb/serial/sierra.c
-
-		}
-=======
 		}
 	}
 
@@ -325,7 +286,6 @@ static int sierra_send_setup(struct usb_
 			0x22, 0x21, val, interface,
 			NULL, 0, USB_CTRL_SET_TIMEOUT);
 
->>>>>>> FETCH_HEAD:drivers/usb/serial/sierra.c
 	}
 
 	return 0;
@@ -635,11 +595,7 @@ static int sierra_open(struct tty_struct
 		}
 	}
 
-<<<<<<< HEAD:drivers/usb/serial/sierra.c
-	sierra_send_setup(tty, port);
-=======
 	sierra_send_setup(port);
->>>>>>> FETCH_HEAD:drivers/usb/serial/sierra.c
 
 	/* start up the interrupt endpoint if we have one */
 	if (port->interrupt_in_urb) {
diff -puN drivers/usb/serial/usb-serial.c~linux-next-git-rejects drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~linux-next-git-rejects
+++ a/drivers/usb/serial/usb-serial.c
@@ -263,16 +263,9 @@ bailout_serial_put:
 
 static void serial_do_down(struct usb_serial_port *port)
 {
-<<<<<<< HEAD:drivers/usb/serial/usb-serial.c
-	struct usb_serial_port *port = tty->driver_data;
-	struct usb_serial *serial;
-	struct module *owner;
-	int count;
-=======
 	struct usb_serial_driver *drv = port->serial->type;
 	/* The console is magical, do not hang up the console hardware
 	   or there will be tears */
->>>>>>> FETCH_HEAD:drivers/usb/serial/usb-serial.c
 
 	if (port->console)
 		return;
@@ -291,56 +284,8 @@ static void serial_close(struct tty_stru
 
 	dbg("%s - port %d", __func__, port->number);
 
-<<<<<<< HEAD:drivers/usb/serial/usb-serial.c
-	mutex_lock(&port->mutex);
-	serial = port->serial;
-	owner = serial->type->driver.owner;
-=======
->>>>>>> FETCH_HEAD:drivers/usb/serial/usb-serial.c
-
 	if (tty_port_close_start(&port->port, tty, filp) == 0)
 		return;
-<<<<<<< HEAD:drivers/usb/serial/usb-serial.c
-	}
-
-	if (port->port.count == 1)
-		/* only call the device specific close if this
-		 * port is being closed by the last owner. Ensure we do
-		 * this before we drop the port count. The call is protected
-		 * by the port mutex
-		 */
-		serial->type->close(tty, port, filp);
-
-	if (port->port.count == (port->console ? 2 : 1)) {
-		struct tty_struct *tty = tty_port_tty_get(&port->port);
-		if (tty) {
-			/* We must do this before we drop the port count to
-			   zero. */
-			if (tty->driver_data)
-				tty->driver_data = NULL;
-			tty_port_tty_set(&port->port, NULL);
-			tty_kref_put(tty);
-		}
-	}
-
-	--port->port.count;
-	count = port->port.count;
-	mutex_unlock(&port->mutex);
-	put_device(&port->dev);
-
-	/* Mustn't dereference port any more */
-	if (count == 0) {
-		mutex_lock(&serial->disc_mutex);
-		if (!serial->disconnected)
-			usb_autopm_put_interface(serial->interface);
-		mutex_unlock(&serial->disc_mutex);
-	}
-	usb_serial_put(serial);
-
-	/* Mustn't dereference serial any more */
-	if (count == 0)
-		module_put(owner);
-=======
 
 	serial_do_down(port);		
 	tty_port_close_end(&port->port, tty);
@@ -354,7 +299,6 @@ static void serial_hangup(struct tty_str
 	serial_do_down(port);
 	tty_port_hangup(&port->port);
 	usb_serial_put(port->serial);
->>>>>>> FETCH_HEAD:drivers/usb/serial/usb-serial.c
 }
 
 static int serial_write(struct tty_struct *tty, const unsigned char *buf,
diff -puN fs/exec.c~linux-next-git-rejects fs/exec.c
--- a/fs/exec.c~linux-next-git-rejects
+++ a/fs/exec.c
@@ -1043,11 +1043,7 @@ int check_unsafe_exec(struct linux_binpr
 		if (t->fs == p->fs)
 			n_fs++;
 	}
-<<<<<<< HEAD:fs/exec.c
 	rcu_read_unlock();
-=======
-	rcu_read_lock();
->>>>>>> FETCH_HEAD:fs/exec.c
 
 	if (p->fs->users > n_fs) {
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
diff -puN include/linux/kvm.h~linux-next-git-rejects include/linux/kvm.h
--- a/include/linux/kvm.h~linux-next-git-rejects
+++ a/include/linux/kvm.h
@@ -409,13 +409,10 @@ struct kvm_trace_rec {
 #ifdef __KVM_HAVE_DEVICE_ASSIGNMENT
 #define KVM_CAP_DEVICE_DEASSIGNMENT 27
 #endif
-<<<<<<< HEAD:include/linux/kvm.h
-=======
 #ifdef __KVM_HAVE_MSIX
 #define KVM_CAP_DEVICE_MSIX 28
 #endif
 #define KVM_CAP_ASSIGN_DEV_IRQ 29
->>>>>>> FETCH_HEAD:include/linux/kvm.h
 /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
net-rfkill-rfkillc-fix-build-with-config_rfkill_leds=n.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
forcedeth-add-clock-gating-feature-checkpatch-fixes.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
block-turn-some-buggy-macros-into-c-functions.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-close-page_mkwrite-races-try-3-fix.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-borked-on-non-x86.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

