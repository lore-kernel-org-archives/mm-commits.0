Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92966C43460
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7499D613CD
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhEGBHJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230444AbhEGBHJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 086A0613C9;
        Fri,  7 May 2021 01:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349570;
        bh=h5xWlw++/J4KekLzEuGg8WbQkHU2W0pu3hpoaSnOsMI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uzO6wtt1Bm/SKdmnEPF/ccl9MHUC7yjqCStteFEh/zcZ2OpHF6g1qe/RjZTHMgYrT
         t1vZFZGkqwMcFD7OY4eY5PyOc/K9BYJuXyrRsf3GNrfr8h5cza097iWW7LzYYMynBo
         GOgv6TgyNNdirkfhEDDYOPLLtAlQua6adkG0qNjA=
Date:   Thu, 06 May 2021 18:06:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     0x7f454c46@gmail.com, akpm@linux-foundation.org, cl@linux.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, linux@armlinux.org.uk,
        maninder1.s@samsung.com, mm-commits@vger.kernel.org,
        paulmck@kernel.org, penberg@kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org, v.narang@samsung.com,
        vbabka@suse.cz, viro@zeniv.linux.org.uk
Subject:  [patch 77/91] arm: print alloc free paths for address in
 registers
Message-ID: <20210507010609.arjStHN5i%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Maninder Singh <maninder1.s@samsung.com>
Subject: arm: print alloc free paths for address in registers

In case of a use after free kernel oops, the freeing path of the object is
required to debug futher.  In most of cases the object address is present
in one of the registers.

Thus check the register's address and if it belongs to slab, print its
alloc and free path.

e.g.  in the below issue register r6 belongs to slab, and a use after free
issue occurred on one of its dereferenced values:

[   20.182197] Unable to handle kernel paging request at virtual address 6b6b6b6f
....
[   20.185035] pc : [<c0538afc>]    lr : [<c0465674>]    psr: 60000013
[   20.185271] sp : c8927d40  ip : ffffefff  fp : c8aa8020
[   20.185462] r10: c8927e10  r9 : 00000001  r8 : 00400cc0
[   20.185674] r7 : 00000000  r6 : c8ab0180  r5 : c1804a80  r4 : c8aa8008
[   20.185924] r3 : c1a5661c  r2 : 00000000  r1 : 6b6b6b6b  r0 : c139bf48
.....
[   20.191499] Register r6 information: slab kmalloc-64 start c8ab0140 data offset 64 pointer offset 0 size 64 allocated at meminfo_proc_show+0x40/0x4fc
[   20.192078]     meminfo_proc_show+0x40/0x4fc
[   20.192263]     seq_read_iter+0x18c/0x4c4
[   20.192430]     proc_reg_read_iter+0x84/0xac
[   20.192617]     generic_file_splice_read+0xe8/0x17c
[   20.192816]     splice_direct_to_actor+0xb8/0x290
[   20.193008]     do_splice_direct+0xa0/0xe0
[   20.193185]     do_sendfile+0x2d0/0x438
[   20.193345]     sys_sendfile64+0x12c/0x140
[   20.193523]     ret_fast_syscall+0x0/0x58
[   20.193695]     0xbeeacde4
[   20.193822]  Free path:
[   20.193935]     meminfo_proc_show+0x5c/0x4fc
[   20.194115]     seq_read_iter+0x18c/0x4c4
[   20.194285]     proc_reg_read_iter+0x84/0xac
[   20.194475]     generic_file_splice_read+0xe8/0x17c
[   20.194685]     splice_direct_to_actor+0xb8/0x290
[   20.194870]     do_splice_direct+0xa0/0xe0
[   20.195014]     do_sendfile+0x2d0/0x438
[   20.195174]     sys_sendfile64+0x12c/0x140
[   20.195336]     ret_fast_syscall+0x0/0x58
[   20.195491]     0xbeeacde4

Link: https://lkml.kernel.org/r/1615891032-29160-3-git-send-email-maninder1.s@samsung.com
Co-developed-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/bug.h |    1 +
 arch/arm/kernel/process.c  |   11 +++++++++++
 arch/arm/kernel/traps.c    |    1 +
 3 files changed, 13 insertions(+)

--- a/arch/arm/include/asm/bug.h~arm-print-alloc-free-paths-for-address-in-registers
+++ a/arch/arm/include/asm/bug.h
@@ -88,5 +88,6 @@ extern asmlinkage void c_backtrace(unsig
 struct mm_struct;
 void show_pte(const char *lvl, struct mm_struct *mm, unsigned long addr);
 extern void __show_regs(struct pt_regs *);
+extern void __show_regs_alloc_free(struct pt_regs *regs);
 
 #endif
--- a/arch/arm/kernel/process.c~arm-print-alloc-free-paths-for-address-in-registers
+++ a/arch/arm/kernel/process.c
@@ -92,6 +92,17 @@ void arch_cpu_idle_exit(void)
 	ledtrig_cpu(CPU_LED_IDLE_END);
 }
 
+void __show_regs_alloc_free(struct pt_regs *regs)
+{
+	int i;
+
+	/* check for r0 - r12 only */
+	for (i = 0; i < 13; i++) {
+		pr_alert("Register r%d information:", i);
+		mem_dump_obj((void *)regs->uregs[i]);
+	}
+}
+
 void __show_regs(struct pt_regs *regs)
 {
 	unsigned long flags;
--- a/arch/arm/kernel/traps.c~arm-print-alloc-free-paths-for-address-in-registers
+++ a/arch/arm/kernel/traps.c
@@ -287,6 +287,7 @@ static int __die(const char *str, int er
 
 	print_modules();
 	__show_regs(regs);
+	__show_regs_alloc_free(regs);
 	pr_emerg("Process %.*s (pid: %d, stack limit = 0x%p)\n",
 		 TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk), end_of_stack(tsk));
 
_
