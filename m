From: akpm@osdl.org
Subject: - softirq-remove-bug_ons-which-can-incorrectly-trigger.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:15:18 -0800
Message-ID: <200612072315.kB7NFINQ030715@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53598 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163751AbWLGXQL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:16:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, caglar@pardus.org.tr, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     softirq: remove BUG_ONs which can incorrectly trigger
has been removed from the -mm tree.  Its filename was
     softirq-remove-bug_ons-which-can-incorrectly-trigger.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: softirq: remove BUG_ONs which can incorrectly trigger
From: Zachary Amsden <zach@vmware.com>

It is possible to have tasklets get scheduled before softirqd has had a chance
to spawn on all CPUs.  This is totally harmless; after success during action
CPU_UP_PREPARE, action CPU_ONLINE will be called, which immediately wakes
softirqd on the appropriate CPU to process the already pending tasklets.  So
there is no danger of having a missed wakeup for any tasklets that were
already pending.

In particular, i386 is affected by this during startup, and is visible when
using a very large initrd; during the time it takes for the initrd to be
decompressed, a timer IRQ can come in and schedule RCU callbacks.  It is also
possible that resending of a hardware IRQ via a softirq triggers the same bug.

Because of different timing conditions, this shows up in all emulators and
virtual machines tested, including Xen, VMware, Virtual PC, and Qemu.  It is
also possible to trigger on native hardware with a large enough initrd,
although I don't have a reliable case demonstrating that.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: <caglar@pardus.org.tr>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/softirq.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/softirq.c~softirq-remove-bug_ons-which-can-incorrectly-trigger kernel/softirq.c
--- a/kernel/softirq.c~softirq-remove-bug_ons-which-can-incorrectly-trigger
+++ a/kernel/softirq.c
@@ -574,8 +574,6 @@ static int __cpuinit cpu_callback(struct
 
 	switch (action) {
 	case CPU_UP_PREPARE:
-		BUG_ON(per_cpu(tasklet_vec, hotcpu).list);
-		BUG_ON(per_cpu(tasklet_hi_vec, hotcpu).list);
 		p = kthread_create(ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk("ksoftirqd for %i failed\n", hotcpu);
_

Patches currently in -mm which might be from zach@vmware.com are

origin.patch
convert-i386-pda-code-to-use-%fs.patch
updated-i386-cleanup-apic-code.patch
updated-i386-rework-local-apic-calibration.patch
updated-dynticks-fix-nmi-watchdog.patch

