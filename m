From: akpm@linux-foundation.org
Subject: - genirq-mask-irqs-when-migrating-them.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:25 -0800
Message-ID: <200702282354.l1SNsPw4031192@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48480 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711AbXB1Xy3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:54:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     genirq: Mask irqs when migrating them
has been removed from the -mm tree.  Its filename was
     genirq-mask-irqs-when-migrating-them.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: genirq: Mask irqs when migrating them
From: Eric W. Biederman <ebiederm@xmission.com>

move_native_irqs tries to do the right thing when migrating irqs by disabling
them.  However disabling them is a software logical thing, not a hardware
thing.  This has always been a little flaky and after Ingo's latest round of
changes it is guaranteed to not mask the apic.

So this patch fixes move_native_irq to directly call the mask and unmask chip
methods to guarantee that we mask the irq when we are migrating it.  We must
do this as it is required by all code that call into the path.

Since we don't know the masked status when IRQ_DISABLED is set so we will not
be able to restore it.  The patch makes the code just give up and trying again
the next time this routing is called.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/migration.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/irq/migration.c~genirq-mask-irqs-when-migrating-them kernel/irq/migration.c
--- a/kernel/irq/migration.c~genirq-mask-irqs-when-migrating-them
+++ a/kernel/irq/migration.c
@@ -65,12 +65,11 @@ void move_native_irq(int irq)
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
-	if (likely(!(desc->status & IRQ_DISABLED)))
-		desc->chip->disable(irq);
+	if (unlikely(desc->status & IRQ_DISABLED))
+		return;
 
+	desc->chip->mask(irq);
 	move_masked_irq(irq);
-
-	if (likely(!(desc->status & IRQ_DISABLED)))
-		desc->chip->enable(irq);
+	desc->chip->unmask(irq);
 }
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
make-ipc-shmcshm_nopage-static.patch
mm-tiny-shmemc-cleanups.patch
fix-the-sysctl=n-compilation.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
i386-irq-kill-irq-compression.patch
i386-irq-kill-irq-compression-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
