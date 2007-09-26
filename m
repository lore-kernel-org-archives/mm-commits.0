From: akpm@linux-foundation.org
Subject: - uml-correctly-handle-skb-allocation-failures.patch removed from -mm tree
Date: Wed, 26 Sep 2007 16:41:10 -0700
Message-ID: <200709262341.l8QNfAtp009870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46278 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbXIZXlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 19:41:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: correctly handle skb allocation failures
has been removed from the -mm tree.  Its filename was
     uml-correctly-handle-skb-allocation-failures.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: uml: correctly handle skb allocation failures
From: Jeff Dike <jdike@addtoit.com>

Handle memory allocation failures when reading packets.

We have to read something from the host, even if we can't allocate any memory.
 If we don't, the host side of the device may fill up and stop delivering
interrupts because no new packets can be queued.

A single sk_buff is allocated whenever an MTU is seen which is larger than any
seen earlier.  This is used to read packets if there is a memory allocation
failure.

The large MTU check is done from eth_configure, which is called when a
interface is added to the system, and from uml_net_change_mtu, which is called
when an existing interface has its MTU changed.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/um/drivers/net_kern.c~uml-correctly-handle-skb-allocation-failures arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-correctly-handle-skb-allocation-failures
+++ a/arch/um/drivers/net_kern.c
@@ -34,6 +34,48 @@ static inline void set_ether_mac(struct 
 static DEFINE_SPINLOCK(opened_lock);
 static LIST_HEAD(opened);
 
+/*
+ * The throwaway skb is used when we can't allocate an skb.  The
+ * packet is read into throwaway in order to get the data off the
+ * connection to the host.
+ * It is reallocated whenever an MTU is seen which is larger than
+ * anything seen before.  update_throwaway_skb is called from
+ * eth_configure for new interfaces and from uml_net_change_mtu for
+ * MTU changes on existing interfaces.
+ */
+static DEFINE_SPINLOCK(throwaway_lock);
+static struct sk_buff *throwaway;
+static int throwaway_max;
+
+static int update_throwaway_skb(int max)
+{
+	struct sk_buff *new;
+	int err = 0;
+
+	spin_lock(&throwaway_lock);
+
+	if (max <= throwaway_max)
+		goto out;
+
+	err = -ENOMEM;
+	new = dev_alloc_skb(max);
+	if (new == NULL)
+		goto out;
+
+	skb_put(new, max);
+
+	kfree_skb(throwaway);
+	throwaway = new;
+	throwaway_max = max;
+	err = 0;
+out:
+	spin_unlock(&throwaway_lock);
+
+	return err;
+}
+
+int npackets = 0;
+
 static int uml_net_rx(struct net_device *dev)
 {
 	struct uml_net_private *lp = dev->priv;
@@ -42,7 +84,14 @@ static int uml_net_rx(struct net_device 
 
 	/* If we can't allocate memory, try again next round. */
 	skb = dev_alloc_skb(lp->max_packet);
+	if ((++npackets % 100) == 0){
+		kfree_skb(skb);
+		skb = NULL;
+	}
+
 	if (skb == NULL) {
+		throwaway->dev = dev;
+		(*lp->read)(lp->fd, throwaway, lp);
 		lp->stats.rx_dropped++;
 		return 0;
 	}
@@ -240,6 +289,13 @@ static int uml_net_set_mac(struct net_de
 
 static int uml_net_change_mtu(struct net_device *dev, int new_mtu)
 {
+	struct uml_net_private *lp = dev->priv;
+	int err;
+
+	err = update_throwaway_skb(lp->max_packet);
+	if (err)
+		return err;
+
 	dev->mtu = new_mtu;
 
 	return 0;
@@ -447,6 +503,10 @@ static void eth_configure(int n, void *i
 	dev->watchdog_timeo = (HZ >> 1);
 	dev->irq = UM_ETH_IRQ;
 
+	err = update_throwaway_skb(lp->max_packet);
+	if (err)
+		goto out_undo_user_init;
+
 	rtnl_lock();
 	err = register_netdevice(dev);
 	rtnl_unlock();
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-stop-saving-process-fp-state-fix.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-rename-pt_regs-general-purpose-register-file-fix.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
uml-remove-unused-file.patch
uml-more-idiomatic-parameter-parsing.patch
uml-eliminate-hz.patch
uml-fix-timer-switching.patch
uml-simplify-interval-setting.patch
uml-separate-timer-initialization.patch
uml-generic_time-support.patch
uml-generic_clockevents-support.patch
uml-clocksource-support.patch
uml-clocksource-support-fix.patch
uml-tickless-support.patch
uml-tickless-support-fix.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-time-build-fix.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
uml-network-formatting.patch
uml-network-driver-mtu-cleanups.patch
uml-correctly-handle-skb-allocation-failures.patch
bitops-introduce-lock-ops.patch
