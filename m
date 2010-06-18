From: akpm@linux-foundation.org
Subject: + gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:15 -0700
Message-ID: <201006182331.o5INVFnL029513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930Ab0FRXbm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de


The patch titled
     gcc-4.6: irq: move alloc_desk_mask variables inside ifdef
has been added to the -mm tree.  Its filename is
     gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch

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
Subject: gcc-4.6: irq: move alloc_desk_mask variables inside ifdef
From: Andi Kleen <andi@firstfloor.org>

They are only useful with CONFIG_CPUMASK_OFFSTACK

Avoids hundreds of warnings with a gcc 4.6 -Wall build.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/irq.h~gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef include/linux/irq.h
--- a/include/linux/irq.h~gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef
+++ a/include/linux/irq.h
@@ -439,12 +439,12 @@ extern int set_irq_msi(unsigned int irq,
 static inline bool alloc_desc_masks(struct irq_desc *desc, int node,
 							bool boot)
 {
+#ifdef CONFIG_CPUMASK_OFFSTACK
 	gfp_t gfp = GFP_ATOMIC;
 
 	if (boot)
 		gfp = GFP_NOWAIT;
 
-#ifdef CONFIG_CPUMASK_OFFSTACK
 	if (!alloc_cpumask_var_node(&desc->affinity, gfp, node))
 		return false;
 
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch

