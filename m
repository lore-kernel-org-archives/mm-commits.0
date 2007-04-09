From: akpm@linux-foundation.org
Subject: + pad-irq_desc-to-internode-cacheline-size.patch added to -mm tree
Date: Mon, 09 Apr 2007 13:53:26 -0700
Message-ID: <200704092053.l39KrQ6a023177@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59947 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965656AbXDIUxo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 16:53:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kiran@scalex86.org, mingo@elte.hu, shai@scalex86.org, suresh.b.siddha@intel.com, tglx@linutronix.de


The patch titled
     Pad irq_desc to internode cacheline size
has been added to the -mm tree.  Its filename is
     pad-irq_desc-to-internode-cacheline-size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Pad irq_desc to internode cacheline size
From: Ravikiran G Thirumalai <kiran@scalex86.org>

We noticed a drop in n/w performance due to the irq_desc being cacheline
aligned rather than internode aligned.  We see 50% of expected performance
when two e1000 nics local to two different nodes have consecutive irq
descriptors allocated, due to false sharing.

Note that this patch does away with cacheline padding for the UP case, as
it does not seem useful for UP configurations.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h |    2 +-
 kernel/irq/handle.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/irq.h~pad-irq_desc-to-internode-cacheline-size include/linux/irq.h
--- a/include/linux/irq.h~pad-irq_desc-to-internode-cacheline-size
+++ a/include/linux/irq.h
@@ -175,7 +175,7 @@ struct irq_desc {
 	struct proc_dir_entry	*dir;
 #endif
 	const char		*name;
-} ____cacheline_aligned;
+} ____cacheline_internodealigned_in_smp;
 
 extern struct irq_desc irq_desc[NR_IRQS];
 
diff -puN kernel/irq/handle.c~pad-irq_desc-to-internode-cacheline-size kernel/irq/handle.c
--- a/kernel/irq/handle.c~pad-irq_desc-to-internode-cacheline-size
+++ a/kernel/irq/handle.c
@@ -48,7 +48,7 @@ handle_bad_irq(unsigned int irq, struct 
  *
  * Controller mappings for all interrupt sources:
  */
-struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned = {
+struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status = IRQ_DISABLED,
 		.chip = &no_irq_chip,
_

Patches currently in -mm which might be from kiran@scalex86.org are

git-pciseg.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
pad-irq_desc-to-internode-cacheline-size.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
sched-align-rq-to-cacheline-boundary.patch
slab-leaks3-default-y.patch
