From: akpm@linux-foundation.org
Subject: + forcedeth-fix-locking-bug-with-netconsole.patch added to -mm tree
Date: Fri, 21 Mar 2008 15:57:58 -0700
Message-ID: <200803212257.m2LMvxQ4014991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763910AbYCUW63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 18:58:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, aabdulla@nvidia.com, jeff@garzik.org


The patch titled
     forcedeth: fix locking bug with netconsole
has been added to the -mm tree.  Its filename is
     forcedeth-fix-locking-bug-with-netconsole.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forcedeth: fix locking bug with netconsole
From: Ingo Molnar <mingo@elte.hu>

While using netconsole on forcedeth, lockdep noticed the following locking
bug:

=================================
[ INFO: inconsistent lock state ]
2.6.24-rc6 #6
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---------------------------------
inconsistent {softirq-on-W} -> {in-softirq-W} usage.
udevd/719 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (_xmit_ETHER){-+..}, at: [<c043062e>] dev_watchdog+0x1c/0xb9
{softirq-on-W} state was registered at:
  [<c0147f67>] mark_held_locks+0x4e/0x66
  [<c014810e>] trace_hardirqs_on+0xfe/0x136
  [<c048ae63>] _spin_unlock_irq+0x22/0x42
  [<c02ec617>] nv_start_xmit_optimized+0x347/0x37a
  [<c042c80d>] netpoll_send_skb+0xa4/0x147
  [<c042d4a6>] netpoll_send_udp+0x238/0x242
  [<c02f44f6>] write_msg+0x6d/0x9b
  [<c012c129>] __call_console_drivers+0x4e/0x5a
  [<c012c18c>] _call_console_drivers+0x57/0x5b
  [<c012c2dd>] release_console_sem+0x11c/0x1b9
  [<c012caeb>] register_console+0x1eb/0x1f3
  [<c06ae673>] init_netconsole+0x119/0x15f
  [<c069149b>] kernel_init+0x147/0x294
  [<c01058cb>] kernel_thread_helper+0x7/0x10
  [<ffffffff>] 0xffffffff
irq event stamp: 950
hardirqs last  enabled at (950): [<c048ae63>] _spin_unlock_irq+0x22/0x42
hardirqs last disabled at (949): [<c048aaf7>] _spin_lock_irq+0xc/0x38
softirqs last  enabled at (0): [<c012a29c>] copy_process+0x375/0x126d
softirqs last disabled at (947): [<c0106d43>] do_softirq+0x61/0xc6

other info that might help us debug this:
no locks held by udevd/719.

stack backtrace:
Pid: 719, comm: udevd Not tainted 2.6.24-rc6 #6
 [<c0105c46>] show_trace_log_lvl+0x12/0x25
 [<c01063ec>] show_trace+0xd/0x10
 [<c010670c>] dump_stack+0x57/0x5f
 [<c0147505>] print_usage_bug+0x10a/0x117
 [<c0147c38>] mark_lock+0x121/0x402
 [<c01488b6>] __lock_acquire+0x3d1/0xb64
 [<c0149405>] lock_acquire+0x4e/0x6a
 [<c048a99b>] _spin_lock+0x23/0x32
 [<c043062e>] dev_watchdog+0x1c/0xb9
 [<c0133e4a>] run_timer_softirq+0x133/0x193
 [<c0130907>] __do_softirq+0x78/0xed
 [<c0106d43>] do_softirq+0x61/0xc6
 =======================
eth1: link down

The fix is to disable/restore irqs instead of disable/enable.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   18 ++++++++++--------
 net/core/netpoll.c      |    3 +++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-fix-locking-bug-with-netconsole drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-fix-locking-bug-with-netconsole
+++ a/drivers/net/forcedeth.c
@@ -1854,6 +1854,7 @@ static int nv_start_xmit(struct sk_buff 
 	struct ring_desc* start_tx;
 	struct ring_desc* prev_tx;
 	struct nv_skb_map* prev_tx_ctx;
+	unsigned long flags;
 
 	/* add fragments to entries count */
 	for (i = 0; i < fragments; i++) {
@@ -1863,10 +1864,10 @@ static int nv_start_xmit(struct sk_buff 
 
 	empty_slots = nv_get_empty_tx_slots(np);
 	if (unlikely(empty_slots <= entries)) {
-		spin_lock_irq(&np->lock);
+		spin_lock_irqsave(&np->lock, flags);
 		netif_stop_queue(dev);
 		np->tx_stop = 1;
-		spin_unlock_irq(&np->lock);
+		spin_unlock_irqrestore(&np->lock, flags);
 		return NETDEV_TX_BUSY;
 	}
 
@@ -1929,13 +1930,13 @@ static int nv_start_xmit(struct sk_buff 
 		tx_flags_extra = skb->ip_summed == CHECKSUM_PARTIAL ?
 			 NV_TX2_CHECKSUM_L3 | NV_TX2_CHECKSUM_L4 : 0;
 
-	spin_lock_irq(&np->lock);
+	spin_lock_irqsave(&np->lock, flags);
 
 	/* set tx flags */
 	start_tx->flaglen |= cpu_to_le32(tx_flags | tx_flags_extra);
 	np->put_tx.orig = put_tx;
 
-	spin_unlock_irq(&np->lock);
+	spin_unlock_irqrestore(&np->lock, flags);
 
 	dprintk(KERN_DEBUG "%s: nv_start_xmit: entries %d queued for transmission. tx_flags_extra: %x\n",
 		dev->name, entries, tx_flags_extra);
@@ -1971,6 +1972,7 @@ static int nv_start_xmit_optimized(struc
 	struct ring_desc_ex* prev_tx;
 	struct nv_skb_map* prev_tx_ctx;
 	struct nv_skb_map* start_tx_ctx;
+	unsigned long flags;
 
 	/* add fragments to entries count */
 	for (i = 0; i < fragments; i++) {
@@ -1980,10 +1982,10 @@ static int nv_start_xmit_optimized(struc
 
 	empty_slots = nv_get_empty_tx_slots(np);
 	if (unlikely(empty_slots <= entries)) {
-		spin_lock_irq(&np->lock);
+		spin_lock_irqsave(&np->lock, flags);
 		netif_stop_queue(dev);
 		np->tx_stop = 1;
-		spin_unlock_irq(&np->lock);
+		spin_unlock_irqrestore(&np->lock, flags);
 		return NETDEV_TX_BUSY;
 	}
 
@@ -2059,7 +2061,7 @@ static int nv_start_xmit_optimized(struc
 			start_tx->txvlan = 0;
 	}
 
-	spin_lock_irq(&np->lock);
+	spin_lock_irqsave(&np->lock, flags);
 
 	if (np->tx_limit) {
 		/* Limit the number of outstanding tx. Setup all fragments, but
@@ -2085,7 +2087,7 @@ static int nv_start_xmit_optimized(struc
 	start_tx->flaglen |= cpu_to_le32(tx_flags | tx_flags_extra);
 	np->put_tx.ex = put_tx;
 
-	spin_unlock_irq(&np->lock);
+	spin_unlock_irqrestore(&np->lock, flags);
 
 	dprintk(KERN_DEBUG "%s: nv_start_xmit_optimized: entries %d queued for transmission. tx_flags_extra: %x\n",
 		dev->name, entries, tx_flags_extra);
diff -puN net/core/netpoll.c~forcedeth-fix-locking-bug-with-netconsole net/core/netpoll.c
--- a/net/core/netpoll.c~forcedeth-fix-locking-bug-with-netconsole
+++ a/net/core/netpoll.c
@@ -284,6 +284,7 @@ static void netpoll_send_skb(struct netp
 		/* try until next clock tick */
 		for (tries = jiffies_to_usecs(1)/USEC_PER_POLL;
 		     tries > 0; --tries) {
+			WARN_ON_ONCE(!irqs_disabled());
 			if (netif_tx_trylock(dev)) {
 				if (!netif_queue_stopped(dev) &&
 				    !netif_subqueue_stopped(dev, skb))
@@ -297,8 +298,10 @@ static void netpoll_send_skb(struct netp
 
 			/* tickle device maybe there is some cleanup */
 			netpoll_poll(np);
+			WARN_ON_ONCE(!irqs_disabled());
 
 			udelay(USEC_PER_POLL);
+			WARN_ON_ONCE(!irqs_disabled());
 		}
 		local_irq_restore(flags);
 	}
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
pnp-increase-the-number-of-memory-resources-from-12-to-24.patch
mm-fix-boundary-checking-in-free_bootmem_core.patch
git-x86.patch
add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch
x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch
x86_64-do-not-reserve-ramdisk-two-times.patch
x86-handle_vm86_trap-cleanup.patch
i386-arch-x86-math-emu-fpu_entryc-warning-fix.patch
x86_64-ia32-ptrace-vs-enosys.patch
x86_64-ptrace-vs-enosys.patch
x86_64-ia32-ptrace-vs-enosys-sysenter-syscall.patch
git-kgdb-light.patch
git-acpi-fixup.patch
git-hrt.patch
git-kvm.patch
forcedeth-fix-locking-bug-with-netconsole.patch
git-sched.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
git-sched-schedc-needs-tickh.patch
git-semaphore.patch
git-semaphore-git-rejects.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mm-make-mem_map-allocation-continuous.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-allocate-section_map-for-sparse_init.patch
taint-kernel-after-warn_oncondition.patch
add-rusage_thread.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
update-checkpatchpl-to-version-016.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
x86-configurable-dmi-scanning-code.patch
cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch
cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
asm-futexh-should-include-linux-uaccessh.patch
rename-div64_64-to-div64_u64.patch
remove-div_long_long_rem.patch
introduce-a-generic-__fls-implementation.patch
implement-__fls-on-all-64-bit-archs.patch
use-__fls-for-fls64-on-64-bit-archs.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch

