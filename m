Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3811C04FF3
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 00:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76EF461155
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 00:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhEVAWz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 May 2021 20:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231174AbhEVAWR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 May 2021 20:22:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85306613D8;
        Sat, 22 May 2021 00:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621642853;
        bh=s6vtTSrYkIofZpeYj1KpiMsr6lbK963XRLtT89YasRQ=;
        h=Date:From:To:Subject:From;
        b=0mNURoJB7EJGQ7jXDmdsqkKHMTFKyIAFalu0PHjXBv9t3Q7ek2XiQ52kKZD+8ytGw
         H5iHqXXq0MOjQEYBJvalnWmosHvOCS0yQSaEqpHXmq4tNDJ0IsQEgbIjQnwaEuNCDq
         Z08lxCWDmnXdPuFIM6+Ea71ZWjLBd1tGMw87r+Y0=
Date:   Fri, 21 May 2021 17:20:52 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, ananth@in.ibm.com,
        christian.brauner@ubuntu.com, corbet@lwn.net, hca@linux.ibm.com,
        joe@perches.com, jszhang@kernel.org, jthumshirn@suse.de,
        marc@koderer.com, mathieu.desnoyers@polymtl.ca,
        mchehab+huawei@kernel.org, mhiramat@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        schwidefsky@de.ibm.com, yangtiezhu@loongson.cn
Subject:  [merged] samples-kprobes-fix-typo-in-handler_post.patch
 removed from -mm tree
Message-ID: <20210522002052.enhJNKWg9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: samples/kprobes: fix typo in handler_post()
has been removed from the -mm tree.  Its filename was
     samples-kprobes-fix-typo-in-handler_post.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: samples/kprobes: fix typo in handler_post()

It should use post_handler instead of pre_handler in handler_post().

As Joe Perches suggested, it would be better to use pr_fmt and remove all
the embedded pre/post/fault strings.  This would change the style of the
output through.

Link: https://lkml.kernel.org/r/1621218083-23519-3-git-send-email-yangtiezhu@loongson.cn
Fixes: e16c5dd5157e ("samples/kprobes: Add s390 case in kprobe example module")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: Marc Koderer <marc@koderer.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Jisheng Zhang <jszhang@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/kprobe_example.c |   33 ++++++++++++++---------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/samples/kprobes/kprobe_example.c~samples-kprobes-fix-typo-in-handler_post
+++ a/samples/kprobes/kprobe_example.c
@@ -10,6 +10,8 @@
  * whenever kernel_clone() is invoked to create a new process.
  */
 
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kprobes.h>
@@ -27,32 +29,31 @@ static struct kprobe kp = {
 static int __kprobes handler_pre(struct kprobe *p, struct pt_regs *regs)
 {
 #ifdef CONFIG_X86
-	pr_info("<%s> pre_handler: p->addr = 0x%p, ip = %lx, flags = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, ip = %lx, flags = 0x%lx\n",
 		p->symbol_name, p->addr, regs->ip, regs->flags);
 #endif
 #ifdef CONFIG_PPC
-	pr_info("<%s> pre_handler: p->addr = 0x%p, nip = 0x%lx, msr = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, nip = 0x%lx, msr = 0x%lx\n",
 		p->symbol_name, p->addr, regs->nip, regs->msr);
 #endif
 #ifdef CONFIG_MIPS
-	pr_info("<%s> pre_handler: p->addr = 0x%p, epc = 0x%lx, status = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, epc = 0x%lx, status = 0x%lx\n",
 		p->symbol_name, p->addr, regs->cp0_epc, regs->cp0_status);
 #endif
 #ifdef CONFIG_ARM64
-	pr_info("<%s> pre_handler: p->addr = 0x%p, pc = 0x%lx,"
-			" pstate = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, pc = 0x%lx, pstate = 0x%lx\n",
 		p->symbol_name, p->addr, (long)regs->pc, (long)regs->pstate);
 #endif
 #ifdef CONFIG_ARM
-	pr_info("<%s> pre_handler: p->addr = 0x%p, pc = 0x%lx, cpsr = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, pc = 0x%lx, cpsr = 0x%lx\n",
 		p->symbol_name, p->addr, (long)regs->ARM_pc, (long)regs->ARM_cpsr);
 #endif
 #ifdef CONFIG_RISCV
-	pr_info("<%s> pre_handler: p->addr = 0x%p, pc = 0x%lx, status = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, pc = 0x%lx, status = 0x%lx\n",
 		p->symbol_name, p->addr, regs->epc, regs->status);
 #endif
 #ifdef CONFIG_S390
-	pr_info("<%s> pre_handler: p->addr, 0x%p, ip = 0x%lx, flags = 0x%lx\n",
+	pr_info("<%s> p->addr, 0x%p, ip = 0x%lx, flags = 0x%lx\n",
 		p->symbol_name, p->addr, regs->psw.addr, regs->flags);
 #endif
 
@@ -65,31 +66,31 @@ static void __kprobes handler_post(struc
 				unsigned long flags)
 {
 #ifdef CONFIG_X86
-	pr_info("<%s> post_handler: p->addr = 0x%p, flags = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, flags = 0x%lx\n",
 		p->symbol_name, p->addr, regs->flags);
 #endif
 #ifdef CONFIG_PPC
-	pr_info("<%s> post_handler: p->addr = 0x%p, msr = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, msr = 0x%lx\n",
 		p->symbol_name, p->addr, regs->msr);
 #endif
 #ifdef CONFIG_MIPS
-	pr_info("<%s> post_handler: p->addr = 0x%p, status = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, status = 0x%lx\n",
 		p->symbol_name, p->addr, regs->cp0_status);
 #endif
 #ifdef CONFIG_ARM64
-	pr_info("<%s> post_handler: p->addr = 0x%p, pstate = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, pstate = 0x%lx\n",
 		p->symbol_name, p->addr, (long)regs->pstate);
 #endif
 #ifdef CONFIG_ARM
-	pr_info("<%s> post_handler: p->addr = 0x%p, cpsr = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, cpsr = 0x%lx\n",
 		p->symbol_name, p->addr, (long)regs->ARM_cpsr);
 #endif
 #ifdef CONFIG_RISCV
-	pr_info("<%s> post_handler: p->addr = 0x%p, status = 0x%lx\n",
+	pr_info("<%s> p->addr = 0x%p, status = 0x%lx\n",
 		p->symbol_name, p->addr, regs->status);
 #endif
 #ifdef CONFIG_S390
-	pr_info("<%s> pre_handler: p->addr, 0x%p, flags = 0x%lx\n",
+	pr_info("<%s> p->addr, 0x%p, flags = 0x%lx\n",
 		p->symbol_name, p->addr, regs->flags);
 #endif
 }
@@ -101,7 +102,7 @@ static void __kprobes handler_post(struc
  */
 static int handler_fault(struct kprobe *p, struct pt_regs *regs, int trapnr)
 {
-	pr_info("fault_handler: p->addr = 0x%p, trap #%d\n", p->addr, trapnr);
+	pr_info("p->addr = 0x%p, trap #%d\n", p->addr, trapnr);
 	/* Return 0 because we don't handle the fault. */
 	return 0;
 }
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


