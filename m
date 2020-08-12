Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A545AC433EA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 760CC2080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196031;
	bh=CnttCatz5aXXAipjykb809MVJvAL/LiuDn5z8WVgGto=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=m7fxGvTAkAK1No2Q7IO9vCHQVNQpkPxvey9ejOffDh89CROrfM1Zp7glQGW5JETN2
	 1jprlv8Llkj7+s7lNjahL5pSB5UWk4RIfX5hgBNAjnBgIwO1tez5gIc/WIOUDTbDA4
	 TsqFJyNygP3/eJvoTHCNfNBGEToPl4zIrKemUW/8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgHLBdu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgHLBdt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 005B220866;
        Wed, 12 Aug 2020 01:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196028;
        bh=CnttCatz5aXXAipjykb809MVJvAL/LiuDn5z8WVgGto=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sLX6SsxOiaSv+0vHj0vH/+Zoi0WffKrPkeNZF9H91a/mf8DSoghs5U374Eg5yB0nK
         gcjTjWCkKoSp/I4aKqoQfFLhivqlP7glaJyCyPUZAjvnSP16zlmWyM93xOrdFagS8F
         Sdzup1ORmuEhw9jHy5+kIykRaUtOqdPy8g4UPHOQ=
Date:   Tue, 11 Aug 2020 18:33:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, deanbo422@gmail.com,
        geert@linux-m68k.org, green.hu@gmail.com, hch@lst.de,
        linux-mm@kvack.org, mark.rutland@arm.com,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        torvalds@linux-foundation.org
Subject:  [patch 067/165] uaccess: add force_uaccess_{begin,end}
 helpers
Message-ID: <20200812013347.nFohV46Vo%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: uaccess: add force_uaccess_{begin,end} helpers

Add helpers to wrap the get_fs/set_fs magic for undoing any damange done
by set_fs(KERNEL_DS).  There is no real functional benefit, but this
documents the intent of these calls better, and will allow stubbing the
functions out easily for kernels builds that do not allow address space
overrides in the future.

[hch@lst.de: drop two incorrect hunks, fix a commit log typo]
  Link: http://lkml.kernel.org/r/20200714105505.935079-6-hch@lst.de
Link: http://lkml.kernel.org/r/20200710135706.537715-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Greentime Hu <green.hu@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/sdei.c         |    2 +-
 arch/m68k/include/asm/tlbflush.h |    6 +++---
 arch/mips/kernel/unaligned.c     |   27 +++++++++++++--------------
 arch/nds32/mm/alignment.c        |    7 +++----
 arch/sh/kernel/traps_32.c        |   12 +++++-------
 drivers/firmware/arm_sdei.c      |    5 ++---
 include/linux/uaccess.h          |   18 ++++++++++++++++++
 kernel/events/callchain.c        |    5 ++---
 kernel/events/core.c             |    5 ++---
 kernel/kthread.c                 |    5 ++---
 kernel/stacktrace.c              |    5 ++---
 mm/maccess.c                     |   22 ++++++++++------------
 12 files changed, 63 insertions(+), 56 deletions(-)

--- a/arch/arm64/kernel/sdei.c~uaccess-add-force_uaccess_beginend-helpers
+++ a/arch/arm64/kernel/sdei.c
@@ -180,7 +180,7 @@ static __kprobes unsigned long _sdei_han
 
 	/*
 	 * We didn't take an exception to get here, set PAN. UAO will be cleared
-	 * by sdei_event_handler()s set_fs(USER_DS) call.
+	 * by sdei_event_handler()s force_uaccess_begin() call.
 	 */
 	__uaccess_enable_hw_pan();
 
--- a/arch/m68k/include/asm/tlbflush.h~uaccess-add-force_uaccess_beginend-helpers
+++ a/arch/m68k/include/asm/tlbflush.h
@@ -85,10 +85,10 @@ static inline void flush_tlb_mm(struct m
 static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 {
 	if (vma->vm_mm == current->active_mm) {
-		mm_segment_t old_fs = get_fs();
-		set_fs(USER_DS);
+		mm_segment_t old_fs = force_uaccess_begin();
+
 		__flush_tlb_one(addr);
-		set_fs(old_fs);
+		force_uaccess_end(old_fs);
 	}
 }
 
--- a/arch/mips/kernel/unaligned.c~uaccess-add-force_uaccess_beginend-helpers
+++ a/arch/mips/kernel/unaligned.c
@@ -191,17 +191,16 @@ static void emulate_load_store_insn(stru
 			 * memory, so we need to "switch" the address limit to
 			 * user space, so that address check can work properly.
 			 */
-			seg = get_fs();
-			set_fs(USER_DS);
+			seg = force_uaccess_begin();
 			switch (insn.spec3_format.func) {
 			case lhe_op:
 				if (!access_ok(addr, 2)) {
-					set_fs(seg);
+					force_uaccess_end(seg);
 					goto sigbus;
 				}
 				LoadHWE(addr, value, res);
 				if (res) {
-					set_fs(seg);
+					force_uaccess_end(seg);
 					goto fault;
 				}
 				compute_return_epc(regs);
@@ -209,12 +208,12 @@ static void emulate_load_store_insn(stru
 				break;
 			case lwe_op:
 				if (!access_ok(addr, 4)) {
-					set_fs(seg);
+					force_uaccess_end(seg);
 					goto sigbus;
 				}
 				LoadWE(addr, value, res);
 				if (res) {
-					set_fs(seg);
+					force_uaccess_end(seg);
 					goto fault;
 				}
 				compute_return_epc(regs);
@@ -222,12 +221,12 @@ static void emulate_load_store_insn(stru
 				break;
 			case lhue_op:
 				if (!access_ok(addr, 2)) {
-					set_fs(seg);
+					force_uaccess_end(seg);
 					goto sigbus;
 				}
 				LoadHWUE(addr, value, res);
 				if (res) {
-					set_fs(seg);
+					force_uaccess_end(seg);
 					goto fault;
 				}
 				compute_return_epc(regs);
@@ -235,35 +234,35 @@ static void emulate_load_store_insn(stru
 				break;
 			case she_op:
 				if (!access_ok(addr, 2)) {
-					set_fs(seg);
+					force_uaccess_end(seg);
 					goto sigbus;
 				}
 				compute_return_epc(regs);
 				value = regs->regs[insn.spec3_format.rt];
 				StoreHWE(addr, value, res);
 				if (res) {
-					set_fs(seg);
+					force_uaccess_end(seg);
 					goto fault;
 				}
 				break;
 			case swe_op:
 				if (!access_ok(addr, 4)) {
-					set_fs(seg);
+					force_uaccess_end(seg);
 					goto sigbus;
 				}
 				compute_return_epc(regs);
 				value = regs->regs[insn.spec3_format.rt];
 				StoreWE(addr, value, res);
 				if (res) {
-					set_fs(seg);
+					force_uaccess_end(seg);
 					goto fault;
 				}
 				break;
 			default:
-				set_fs(seg);
+				force_uaccess_end(seg);
 				goto sigill;
 			}
-			set_fs(seg);
+			force_uaccess_end(seg);
 		}
 #endif
 		break;
--- a/arch/nds32/mm/alignment.c~uaccess-add-force_uaccess_beginend-helpers
+++ a/arch/nds32/mm/alignment.c
@@ -512,7 +512,7 @@ int do_unaligned_access(unsigned long ad
 {
 	unsigned long inst;
 	int ret = -EFAULT;
-	mm_segment_t seg = get_fs();
+	mm_segment_t seg;
 
 	inst = get_inst(regs->ipc);
 
@@ -520,13 +520,12 @@ int do_unaligned_access(unsigned long ad
 	      "Faulting addr: 0x%08lx, pc: 0x%08lx [inst: 0x%08lx ]\n", addr,
 	      regs->ipc, inst);
 
-	set_fs(USER_DS);
-
+	seg = force_uaccess_begin();
 	if (inst & NDS32_16BIT_INSTRUCTION)
 		ret = do_16((inst >> 16) & 0xffff, regs);
 	else
 		ret = do_32(inst, regs);
-	set_fs(seg);
+	force_uaccess_end(seg);
 
 	return ret;
 }
--- a/arch/sh/kernel/traps_32.c~uaccess-add-force_uaccess_beginend-helpers
+++ a/arch/sh/kernel/traps_32.c
@@ -482,8 +482,6 @@ asmlinkage void do_address_error(struct
 	error_code = lookup_exception_vector();
 #endif
 
-	oldfs = get_fs();
-
 	if (user_mode(regs)) {
 		int si_code = BUS_ADRERR;
 		unsigned int user_action;
@@ -491,13 +489,13 @@ asmlinkage void do_address_error(struct
 		local_irq_enable();
 		inc_unaligned_user_access();
 
-		set_fs(USER_DS);
+		oldfs = force_uaccess_begin();
 		if (copy_from_user(&instruction, (insn_size_t *)(regs->pc & ~1),
 				   sizeof(instruction))) {
-			set_fs(oldfs);
+			force_uaccess_end(oldfs);
 			goto uspace_segv;
 		}
-		set_fs(oldfs);
+		force_uaccess_end(oldfs);
 
 		/* shout about userspace fixups */
 		unaligned_fixups_notify(current, instruction, regs);
@@ -520,11 +518,11 @@ fixup:
 			goto uspace_segv;
 		}
 
-		set_fs(USER_DS);
+		oldfs = force_uaccess_begin();
 		tmp = handle_unaligned_access(instruction, regs,
 					      &user_mem_access, 0,
 					      address);
-		set_fs(oldfs);
+		force_uaccess_end(oldfs);
 
 		if (tmp == 0)
 			return; /* sorted */
--- a/drivers/firmware/arm_sdei.c~uaccess-add-force_uaccess_beginend-helpers
+++ a/drivers/firmware/arm_sdei.c
@@ -1136,15 +1136,14 @@ int sdei_event_handler(struct pt_regs *r
 	 * access kernel memory.
 	 * Do the same here because this doesn't come via the same entry code.
 	*/
-	orig_addr_limit = get_fs();
-	set_fs(USER_DS);
+	orig_addr_limit = force_uaccess_begin();
 
 	err = arg->callback(event_num, regs, arg->callback_arg);
 	if (err)
 		pr_err_ratelimited("event %u on CPU %u failed with error: %d\n",
 				   event_num, smp_processor_id(), err);
 
-	set_fs(orig_addr_limit);
+	force_uaccess_end(orig_addr_limit);
 
 	return err;
 }
--- a/include/linux/uaccess.h~uaccess-add-force_uaccess_beginend-helpers
+++ a/include/linux/uaccess.h
@@ -9,6 +9,24 @@
 #include <asm/uaccess.h>
 
 /*
+ * Force the uaccess routines to be wired up for actual userspace access,
+ * overriding any possible set_fs(KERNEL_DS) still lingering around.  Undone
+ * using force_uaccess_end below.
+ */
+static inline mm_segment_t force_uaccess_begin(void)
+{
+	mm_segment_t fs = get_fs();
+
+	set_fs(USER_DS);
+	return fs;
+}
+
+static inline void force_uaccess_end(mm_segment_t oldfs)
+{
+	set_fs(oldfs);
+}
+
+/*
  * Architectures should provide two primitives (raw_copy_{to,from}_user())
  * and get rid of their private instances of copy_{to,from}_user() and
  * __copy_{to,from}_user{,_inatomic}().
--- a/kernel/events/callchain.c~uaccess-add-force_uaccess_beginend-helpers
+++ a/kernel/events/callchain.c
@@ -217,10 +217,9 @@ get_perf_callchain(struct pt_regs *regs,
 			if (add_mark)
 				perf_callchain_store_context(&ctx, PERF_CONTEXT_USER);
 
-			fs = get_fs();
-			set_fs(USER_DS);
+			fs = force_uaccess_begin();
 			perf_callchain_user(&ctx, regs);
-			set_fs(fs);
+			force_uaccess_end(fs);
 		}
 	}
 
--- a/kernel/events/core.c~uaccess-add-force_uaccess_beginend-helpers
+++ a/kernel/events/core.c
@@ -6453,10 +6453,9 @@ perf_output_sample_ustack(struct perf_ou
 
 		/* Data. */
 		sp = perf_user_stack_pointer(regs);
-		fs = get_fs();
-		set_fs(USER_DS);
+		fs = force_uaccess_begin();
 		rem = __output_copy_user(handle, (void *) sp, dump_size);
-		set_fs(fs);
+		force_uaccess_end(fs);
 		dyn_size = dump_size - rem;
 
 		perf_output_skip(handle, rem);
--- a/kernel/kthread.c~uaccess-add-force_uaccess_beginend-helpers
+++ a/kernel/kthread.c
@@ -1258,8 +1258,7 @@ void kthread_use_mm(struct mm_struct *mm
 	if (active_mm != mm)
 		mmdrop(active_mm);
 
-	to_kthread(tsk)->oldfs = get_fs();
-	set_fs(USER_DS);
+	to_kthread(tsk)->oldfs = force_uaccess_begin();
 }
 EXPORT_SYMBOL_GPL(kthread_use_mm);
 
@@ -1274,7 +1273,7 @@ void kthread_unuse_mm(struct mm_struct *
 	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
 	WARN_ON_ONCE(!tsk->mm);
 
-	set_fs(to_kthread(tsk)->oldfs);
+	force_uaccess_end(to_kthread(tsk)->oldfs);
 
 	task_lock(tsk);
 	sync_mm_rss(mm);
--- a/kernel/stacktrace.c~uaccess-add-force_uaccess_beginend-helpers
+++ a/kernel/stacktrace.c
@@ -233,10 +233,9 @@ unsigned int stack_trace_save_user(unsig
 	if (current->flags & PF_KTHREAD)
 		return 0;
 
-	fs = get_fs();
-	set_fs(USER_DS);
+	fs = force_uaccess_begin();
 	arch_stack_walk_user(consume_entry, &c, task_pt_regs(current));
-	set_fs(fs);
+	force_uaccess_end(fs);
 
 	return c.len;
 }
--- a/mm/maccess.c~uaccess-add-force_uaccess_beginend-helpers
+++ a/mm/maccess.c
@@ -205,15 +205,14 @@ long strncpy_from_kernel_nofault(char *d
 long copy_from_user_nofault(void *dst, const void __user *src, size_t size)
 {
 	long ret = -EFAULT;
-	mm_segment_t old_fs = get_fs();
+	mm_segment_t old_fs = force_uaccess_begin();
 
-	set_fs(USER_DS);
 	if (access_ok(src, size)) {
 		pagefault_disable();
 		ret = __copy_from_user_inatomic(dst, src, size);
 		pagefault_enable();
 	}
-	set_fs(old_fs);
+	force_uaccess_end(old_fs);
 
 	if (ret)
 		return -EFAULT;
@@ -233,15 +232,14 @@ EXPORT_SYMBOL_GPL(copy_from_user_nofault
 long copy_to_user_nofault(void __user *dst, const void *src, size_t size)
 {
 	long ret = -EFAULT;
-	mm_segment_t old_fs = get_fs();
+	mm_segment_t old_fs = force_uaccess_begin();
 
-	set_fs(USER_DS);
 	if (access_ok(dst, size)) {
 		pagefault_disable();
 		ret = __copy_to_user_inatomic(dst, src, size);
 		pagefault_enable();
 	}
-	set_fs(old_fs);
+	force_uaccess_end(old_fs);
 
 	if (ret)
 		return -EFAULT;
@@ -270,17 +268,17 @@ EXPORT_SYMBOL_GPL(copy_to_user_nofault);
 long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
 			      long count)
 {
-	mm_segment_t old_fs = get_fs();
+	mm_segment_t old_fs;
 	long ret;
 
 	if (unlikely(count <= 0))
 		return 0;
 
-	set_fs(USER_DS);
+	old_fs = force_uaccess_begin();
 	pagefault_disable();
 	ret = strncpy_from_user(dst, unsafe_addr, count);
 	pagefault_enable();
-	set_fs(old_fs);
+	force_uaccess_end(old_fs);
 
 	if (ret >= count) {
 		ret = count;
@@ -310,14 +308,14 @@ long strncpy_from_user_nofault(char *dst
  */
 long strnlen_user_nofault(const void __user *unsafe_addr, long count)
 {
-	mm_segment_t old_fs = get_fs();
+	mm_segment_t old_fs;
 	int ret;
 
-	set_fs(USER_DS);
+	old_fs = force_uaccess_begin();
 	pagefault_disable();
 	ret = strnlen_user(unsafe_addr, count);
 	pagefault_enable();
-	set_fs(old_fs);
+	force_uaccess_end(old_fs);
 
 	return ret;
 }
_
