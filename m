From: akpm@linux-foundation.org
Subject: + uml-correctly-handle-skb-allocation-failures.patch added to -mm tree
Date: Thu, 27 Sep 2007 23:39:40 -0700
Message-ID: <200709280639.l8S6de09015005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39067 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757401AbXI1Gjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 02:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: correctly handle skb allocation failures
has been added to the -mm tree.  Its filename is
     uml-correctly-handle-skb-allocation-failures.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: correctly handle skb allocation failures
From: Jeff Dike <jdike@addtoit.com>

Handle memory allocation failures when reading packets.

We have to read something from the host, even if we can't allocate any
memory.  If we don't, the host side of the device may fill up and stop
delivering interrupts because no new packets can be queued.

A single sk_buff is allocated whenever an MTU is seen which is larger
than any seen earlier.  This is used to read packets if there is a
memory allocation failure.

The large MTU check is done from eth_configure, which is called when a
interface is added to the system.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |   46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff -puN arch/um/drivers/net_kern.c~uml-correctly-handle-skb-allocation-failures arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-correctly-handle-skb-allocation-failures
+++ a/arch/um/drivers/net_kern.c
@@ -34,6 +34,45 @@ static inline void set_ether_mac(struct 
 static DEFINE_SPINLOCK(opened_lock);
 static LIST_HEAD(opened);
 
+/*
+ * The drop_skb is used when we can't allocate an skb.  The
+ * packet is read into drop_skb in order to get the data off the
+ * connection to the host.
+ * It is reallocated whenever a maximum packet size is seen which is
+ * larger than any seen before.  update_drop_skb is called from
+ * eth_configure when a new interface is added.
+ */
+static DEFINE_SPINLOCK(drop_lock);
+static struct sk_buff *drop_skb;
+static int drop_max;
+
+static int update_drop_skb(int max)
+{
+	struct sk_buff *new;
+	int err = 0;
+
+	spin_lock(&drop_lock);
+
+	if (max <= drop_max)
+		goto out;
+
+	err = -ENOMEM;
+	new = dev_alloc_skb(max);
+	if (new == NULL)
+		goto out;
+
+	skb_put(new, max);
+
+	kfree_skb(drop_skb);
+	drop_skb = new;
+	drop_max = max;
+	err = 0;
+out:
+	spin_unlock(&drop_lock);
+
+	return err;
+}
+
 static int uml_net_rx(struct net_device *dev)
 {
 	struct uml_net_private *lp = dev->priv;
@@ -43,6 +82,9 @@ static int uml_net_rx(struct net_device 
 	/* If we can't allocate memory, try again next round. */
 	skb = dev_alloc_skb(lp->max_packet);
 	if (skb == NULL) {
+		drop_skb->dev = dev;
+		/* Read a packet into drop_skb and don't do anything with it. */
+		(*lp->read)(lp->fd, drop_skb, lp);
 		lp->stats.rx_dropped++;
 		return 0;
 	}
@@ -447,6 +489,10 @@ static void eth_configure(int n, void *i
 	dev->watchdog_timeo = (HZ >> 1);
 	dev->irq = UM_ETH_IRQ;
 
+	err = update_drop_skb(lp->max_packet);
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
