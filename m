From: akpm@osdl.org
Subject: - cpu-hotplug-broken-with-2gb-vmsplit.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:15:33 -0800
Message-ID: <200612082015.kB8KFXWZ003307@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60046 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947086AbWLHUPw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, ak@suse.de, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     CPU hotplug broken with 2GB VMSPLIT
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-broken-with-2gb-vmsplit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CPU hotplug broken with 2GB VMSPLIT
From: Shaohua Li <shaohua.li@intel.com>

In VMSPLIT mode, kernel PGD might have more entries than user space.

Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/smpboot.c~cpu-hotplug-broken-with-2gb-vmsplit arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~cpu-hotplug-broken-with-2gb-vmsplit
+++ a/arch/i386/kernel/smpboot.c
@@ -1118,7 +1118,7 @@ static int __cpuinit __smp_prepare_cpu(i
 
 	/* init low mem mapping */
 	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
-			KERNEL_PGD_PTRS);
+			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
 	flush_tlb_all();
 	schedule_work(&info.task);
 	wait_for_completion(&done);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
cpu-hotplug-broken-with-2gb-vmsplit.patch
git-acpi.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch

