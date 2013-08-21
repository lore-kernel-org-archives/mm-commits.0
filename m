From: akpm@linux-foundation.org
Subject: + kprobes-provide-new-dmainsn-cache.patch added to -mm tree
Date: Wed, 21 Aug 2013 13:28:19 -0700
Message-ID: <521522e3.nw5ykOvvbHhO4k0s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUU2U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Aug 2013 16:28:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, ananth@in.ibm.com, heiko.carstens@de.ibm.com

Subject: + kprobes-provide-new-dmainsn-cache.patch added to -mm tree
To: heiko.carstens@de.ibm.com,ananth@in.ibm.com,masami.hiramatsu.pt@hitachi.com,mingo@kernel.org,schwidefsky@de.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 21 Aug 2013 13:28:19 -0700


The patch titled
     Subject: kprobes: provide new dmainsn cache
has been added to the -mm tree.  Its filename is
     kprobes-provide-new-dmainsn-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-provide-new-dmainsn-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-provide-new-dmainsn-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: kprobes: provide new dmainsn cache

The current kpropes insn caches allocate memory areas for insn slots with
module_alloc().  The assumption is that the kernel image and module area
are both within the same +/- 2GB memory area.

This however is not true for s390 where the kernel image resides within
the first 2GB (DMA memory area), but the module area is far away in the
vmalloc area, usually somewhere close below the 4TB area.

For new pc relative instructions s390 needs insn slots that are within +/-
2GB of each area.  That way we can patch displacements of pc-relative
instructions within the insn slots just like x86 and powerpc.

The module area works already with the normal insn slot allocator, however
there is currently no way to get insn slots that are within the first 2GB
on s390 (aka DMA area).

Therefore this patch introduces the dmainsn slot cache.  Slots can be
allocated and freed with get_dmainsn_slot() and free_dmainsn_slot().

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig            |    7 +++++++
 include/linux/kprobes.h |    5 +++++
 kernel/kprobes.c        |   28 ++++++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 2 deletions(-)

diff -puN arch/Kconfig~kprobes-provide-new-dmainsn-cache arch/Kconfig
--- a/arch/Kconfig~kprobes-provide-new-dmainsn-cache
+++ a/arch/Kconfig
@@ -76,6 +76,13 @@ config OPTPROBES
 	depends on KPROBES && HAVE_OPTPROBES
 	depends on !PREEMPT
 
+config DMAPROBES
+	bool
+	help
+	  Architectures may want to put kprobes instruction slots into
+	  the dma memory region. E.g. s390 has the kernel image in the
+	  dma memory region but the module area far away.
+
 config KPROBES_ON_FTRACE
 	def_bool y
 	depends on KPROBES && HAVE_KPROBES_ON_FTRACE
diff -puN include/linux/kprobes.h~kprobes-provide-new-dmainsn-cache include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-provide-new-dmainsn-cache
+++ a/include/linux/kprobes.h
@@ -320,6 +320,11 @@ extern int proc_kprobes_optimization_han
 #endif
 
 #endif /* CONFIG_OPTPROBES */
+
+#ifdef CONFIG_DMAPROBES
+DEFINE_INSN_CACHE_OPS(dmainsn);
+#endif
+
 #ifdef CONFIG_KPROBES_ON_FTRACE
 extern void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 				  struct ftrace_ops *ops, struct pt_regs *regs);
diff -puN kernel/kprobes.c~kprobes-provide-new-dmainsn-cache kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-provide-new-dmainsn-cache
+++ a/kernel/kprobes.c
@@ -114,6 +114,7 @@ struct kprobe_insn_page {
 	kprobe_opcode_t *insns;		/* Page of instruction slots */
 	int nused;
 	int ngarbage;
+	bool dma_alloc;
 	char slot_used[];
 };
 
@@ -126,6 +127,7 @@ struct kprobe_insn_cache {
 	struct list_head pages;	/* list of kprobe_insn_page */
 	size_t insn_size;	/* size of instruction slot */
 	int nr_garbage;
+	bool dma_alloc;
 };
 
 static int slots_per_page(struct kprobe_insn_cache *c)
@@ -144,6 +146,7 @@ struct kprobe_insn_cache kprobe_insn_slo
 	.pages = LIST_HEAD_INIT(kprobe_insn_slots.pages),
 	.insn_size = MAX_INSN_SIZE,
 	.nr_garbage = 0,
+	.dma_alloc = false,
 };
 static int __kprobes collect_garbage_slots(struct kprobe_insn_cache *c);
 
@@ -189,7 +192,10 @@ kprobe_opcode_t __kprobes *__get_insn_sl
 	 * kernel image and loaded module images reside. This is required
 	 * so x86_64 can correctly handle the %rip-relative fixups.
 	 */
-	kip->insns = module_alloc(PAGE_SIZE);
+	if (c->dma_alloc)
+		kip->insns = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	else
+		kip->insns = module_alloc(PAGE_SIZE);
 	if (!kip->insns) {
 		kfree(kip);
 		goto out;
@@ -199,6 +205,7 @@ kprobe_opcode_t __kprobes *__get_insn_sl
 	kip->slot_used[0] = SLOT_USED;
 	kip->nused = 1;
 	kip->ngarbage = 0;
+	kip->dma_alloc = c->dma_alloc;
 	list_add(&kip->list, &c->pages);
 	slot = kip->insns;
 out:
@@ -220,7 +227,10 @@ static int __kprobes collect_one_slot(st
 		 */
 		if (!list_is_singular(&kip->list)) {
 			list_del(&kip->list);
-			module_free(NULL, kip->insns);
+			if (kip->dma_alloc)
+				free_page((unsigned long)kip->insns);
+			else
+				module_free(NULL, kip->insns);
 			kfree(kip);
 		}
 		return 1;
@@ -284,6 +294,20 @@ struct kprobe_insn_cache kprobe_optinsn_
 	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
 	/* .insn_size is initialized later */
 	.nr_garbage = 0,
+	.dma_alloc = false,
+};
+#endif
+#ifdef CONFIG_DMAPROBES
+/*
+ * Special buffer for architectures which require insn slots
+ * to be in the GFP_DMA memory range.
+ */
+struct kprobe_insn_cache kprobe_dmainsn_slots = {
+	.mutex = __MUTEX_INITIALIZER(kprobe_dmainsn_slots.mutex),
+	.pages = LIST_HEAD_INIT(kprobe_dmainsn_slots.pages),
+	.insn_size = MAX_INSN_SIZE,
+	.nr_garbage = 0,
+	.dma_alloc = true,
 };
 #endif
 #endif
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

kprobes-unify-insn-caches.patch
kprobes-provide-new-dmainsn-cache.patch
s390-kprobes-add-support-for-pc-relative-long-displacement-instructions.patch
linux-next.patch

