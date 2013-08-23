From: akpm@linux-foundation.org
Subject: +
 s390-kprobes-add-support-for-pc-relative-long-displacement-instructions.patch added to -mm tree
Date: Fri, 23 Aug 2013 16:24:05 -0700
Message-ID: <5217ef15.9alXAU71wuKPQOSb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3HWXYG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 19:24:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, ananth@in.ibm.com, heiko.carstens@de.ibm.com

Subject: + s390-kprobes-add-support-for-pc-relative-long-displacement-instructions.patch added to -mm tree
To: heiko.carstens@de.ibm.com,ananth@in.ibm.com,masami.hiramatsu.pt@hitachi.com,mingo@kernel.org,schwidefsky@de.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 16:24:05 -0700


The patch titled
     Subject: s390/kprobes: add support for pc-relative long displacement instructions
has been added to the -mm tree.  Its filename is
     s390-kprobes-add-support-for-pc-relative-long-displacement-instructions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-kprobes-add-support-for-pc-relative-long-displacement-instructions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-kprobes-add-support-for-pc-relative-long-displacement-instructions.patch

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
Subject: s390/kprobes: add support for pc-relative long displacement instructions

With the general-instruction extension facility (z10) a couple of
instructions with a pc-relative long displacement were introduced.  The
kprobes support for these instructions however was never implemented.

In result, if anybody ever put a probe on any of these instructions the
result would have been random behaviour after the instruction got executed
within the insn slot.

So lets add the missing handling for these instructions.  Since all of the
new instructions have 32 bit signed displacement the easiest solution is
to allocate an insn slot that is within the same 2GB area like the
original instruction and patch the displacement field.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/kprobes.h |    4 
 arch/s390/kernel/kprobes.c      |  144 ++++++++++++++++++++++++++++--
 2 files changed, 140 insertions(+), 8 deletions(-)

diff -puN arch/s390/include/asm/kprobes.h~s390-kprobes-add-support-for-pc-relative-long-displacement-instructions arch/s390/include/asm/kprobes.h
--- a/arch/s390/include/asm/kprobes.h~s390-kprobes-add-support-for-pc-relative-long-displacement-instructions
+++ a/arch/s390/include/asm/kprobes.h
@@ -31,6 +31,8 @@
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
 
+#define __ARCH_WANT_KPROBES_INSN_SLOT
+
 struct pt_regs;
 struct kprobe;
 
@@ -57,7 +59,7 @@ typedef u16 kprobe_opcode_t;
 /* Architecture specific copy of original instruction */
 struct arch_specific_insn {
 	/* copy of original instruction */
-	kprobe_opcode_t insn[MAX_INSN_SIZE];
+	kprobe_opcode_t *insn;
 };
 
 struct prev_kprobe {
diff -puN arch/s390/kernel/kprobes.c~s390-kprobes-add-support-for-pc-relative-long-displacement-instructions arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~s390-kprobes-add-support-for-pc-relative-long-displacement-instructions
+++ a/arch/s390/kernel/kprobes.c
@@ -37,6 +37,26 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kpr
 
 struct kretprobe_blackpoint kretprobe_blacklist[] = { };
 
+DEFINE_INSN_CACHE_OPS(dmainsn);
+
+static void *alloc_dmainsn_page(void)
+{
+	return (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+}
+
+static void free_dmainsn_page(void *page)
+{
+	free_page((unsigned long)page);
+}
+
+struct kprobe_insn_cache kprobe_dmainsn_slots = {
+	.mutex = __MUTEX_INITIALIZER(kprobe_dmainsn_slots.mutex),
+	.alloc = alloc_dmainsn_page,
+	.free = free_dmainsn_page,
+	.pages = LIST_HEAD_INIT(kprobe_dmainsn_slots.pages),
+	.insn_size = MAX_INSN_SIZE,
+};
+
 static int __kprobes is_prohibited_opcode(kprobe_opcode_t *insn)
 {
 	switch (insn[0] >> 8) {
@@ -100,9 +120,8 @@ static int __kprobes get_fixup_type(kpro
 			fixup |= FIXUP_RETURN_REGISTER;
 		break;
 	case 0xc0:
-		if ((insn[0] & 0x0f) == 0x00 ||	/* larl  */
-		    (insn[0] & 0x0f) == 0x05)	/* brasl */
-		fixup |= FIXUP_RETURN_REGISTER;
+		if ((insn[0] & 0x0f) == 0x05)	/* brasl */
+			fixup |= FIXUP_RETURN_REGISTER;
 		break;
 	case 0xeb:
 		if ((insn[2] & 0xff) == 0x44 ||	/* bxhg  */
@@ -117,18 +136,128 @@ static int __kprobes get_fixup_type(kpro
 	return fixup;
 }
 
+static int __kprobes is_insn_relative_long(kprobe_opcode_t *insn)
+{
+	/* Check if we have a RIL-b or RIL-c format instruction which
+	 * we need to modify in order to avoid instruction emulation. */
+	switch (insn[0] >> 8) {
+	case 0xc0:
+		if ((insn[0] & 0x0f) == 0x00) /* larl */
+			return true;
+		break;
+	case 0xc4:
+		switch (insn[0] & 0x0f) {
+		case 0x02: /* llhrl  */
+		case 0x04: /* lghrl  */
+		case 0x05: /* lhrl   */
+		case 0x06: /* llghrl */
+		case 0x07: /* sthrl  */
+		case 0x08: /* lgrl   */
+		case 0x0b: /* stgrl  */
+		case 0x0c: /* lgfrl  */
+		case 0x0d: /* lrl    */
+		case 0x0e: /* llgfrl */
+		case 0x0f: /* strl   */
+			return true;
+		}
+		break;
+	case 0xc6:
+		switch (insn[0] & 0x0f) {
+		case 0x00: /* exrl   */
+		case 0x02: /* pfdrl  */
+		case 0x04: /* cghrl  */
+		case 0x05: /* chrl   */
+		case 0x06: /* clghrl */
+		case 0x07: /* clhrl  */
+		case 0x08: /* cgrl   */
+		case 0x0a: /* clgrl  */
+		case 0x0c: /* cgfrl  */
+		case 0x0d: /* crl    */
+		case 0x0e: /* clgfrl */
+		case 0x0f: /* clrl   */
+			return true;
+		}
+		break;
+	}
+	return false;
+}
+
+static void __kprobes copy_instruction(struct kprobe *p)
+{
+	s64 disp, new_disp;
+	u64 addr, new_addr;
+
+	memcpy(p->ainsn.insn, p->addr, ((p->opcode >> 14) + 3) & -2);
+	if (!is_insn_relative_long(p->ainsn.insn))
+		return;
+	/*
+	 * For pc-relative instructions in RIL-b or RIL-c format patch the
+	 * RI2 displacement field. We have already made sure that the insn
+	 * slot for the patched instruction is within the same 2GB area
+	 * as the original instruction (either kernel image or module area).
+	 * Therefore the new displacement will always fit.
+	 */
+	disp = *(s32 *)&p->ainsn.insn[1];
+	addr = (u64)(unsigned long)p->addr;
+	new_addr = (u64)(unsigned long)p->ainsn.insn;
+	new_disp = ((addr + (disp * 2)) - new_addr) / 2;
+	*(s32 *)&p->ainsn.insn[1] = new_disp;
+}
+
+static inline int is_kernel_addr(void *addr)
+{
+	return addr < (void *)_end;
+}
+
+static inline int is_module_addr(void *addr)
+{
+#ifdef CONFIG_64BIT
+	BUILD_BUG_ON(MODULES_LEN > (1UL << 31));
+	if (addr < (void *)MODULES_VADDR)
+		return 0;
+	if (addr > (void *)MODULES_END)
+		return 0;
+#endif
+	return 1;
+}
+
+static int __kprobes s390_get_insn_slot(struct kprobe *p)
+{
+	/*
+	 * Get an insn slot that is within the same 2GB area like the original
+	 * instruction. That way instructions with a 32bit signed displacement
+	 * field can be patched and executed within the insn slot.
+	 */
+	p->ainsn.insn = NULL;
+	if (is_kernel_addr(p->addr))
+		p->ainsn.insn = get_dmainsn_slot();
+	if (is_module_addr(p->addr))
+		p->ainsn.insn = get_insn_slot();
+	return p->ainsn.insn ? 0 : -ENOMEM;
+}
+
+static void __kprobes s390_free_insn_slot(struct kprobe *p)
+{
+	if (!p->ainsn.insn)
+		return;
+	if (is_kernel_addr(p->addr))
+		free_dmainsn_slot(p->ainsn.insn, 0);
+	else
+		free_insn_slot(p->ainsn.insn, 0);
+	p->ainsn.insn = NULL;
+}
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	if ((unsigned long) p->addr & 0x01)
 		return -EINVAL;
-
 	/* Make sure the probe isn't going on a difficult instruction */
 	if (is_prohibited_opcode(p->addr))
 		return -EINVAL;
-
+	if (s390_get_insn_slot(p))
+		return -ENOMEM;
 	p->opcode = *p->addr;
-	memcpy(p->ainsn.insn, p->addr, ((p->opcode >> 14) + 3) & -2);
