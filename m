Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CD0C48BD1
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 00:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A844613E3
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 00:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhFKAP4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 20:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230336AbhFKAP4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 20:15:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAA2E613CA;
        Fri, 11 Jun 2021 00:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623370425;
        bh=Un6POHH4qXgbiILKDDkKOeAkr77PfD0DRNWypYxqKZ8=;
        h=Date:From:To:Subject:From;
        b=1XgEMKMhMoJXi8x+84YYzmR9deptRZcaOFm5Y/0TMW44CgCDttOtkD9xV2Qi1E6sd
         NkbQOOKC/Y/TgDXIyGq87g6j2PgdySz1AFjRwNCaiuVr3/6a/pCLfok9mI0AqL2aOs
         cechqxgAjEIaJXSLnakCt6tvD6DOXGubjF/GpOsM=
Date:   Thu, 10 Jun 2021 17:13:44 -0700
From:   akpm@linux-foundation.org
To:     anil.s.keshavamurthy@intel.com, borntraeger@de.ibm.com,
        bp@alien8.de, davem@davemloft.net, gor@linux.ibm.com,
        hca@linux.ibm.com, hch@lst.de, hpa@zytor.com, liuqi115@huawei.com,
        mhiramat@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        naveen.n.rao@linux.ibm.com, song.bao.hua@hisilicon.com,
        tglx@linutronix.de
Subject:  +
 kprobes-remove-duplicated-strong-free_insn_page-in-x86-and-s390.patch added
 to -mm tree
Message-ID: <20210611001344.HkVBjjQcO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: remove duplicated strong free_insn_page in x86 and s390
has been added to the -mm tree.  Its filename is
     kprobes-remove-duplicated-strong-free_insn_page-in-x86-and-s390.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kprobes-remove-duplicated-strong-free_insn_page-in-x86-and-s390.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kprobes-remove-duplicated-strong-free_insn_page-in-x86-and-s390.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: kprobes: remove duplicated strong free_insn_page in x86 and s390

free_insn_page() in x86 and s390 is same with the common weak function in
kernel/kprobes.c.  Plus, the comment "Recover page to RW mode before
releasing it" in x86 seems insensible to be there since resetting mapping
is done by common code in vfree() of module_memfree().  So drop these two
duplicated strong functions and related comment, then mark the common one
in kernel/kprobes.c strong.

Link: https://lkml.kernel.org/r/20210608065736.32656-1-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Qi Liu <liuqi115@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/kprobes.c     |    5 -----
 arch/x86/kernel/kprobes/core.c |    6 ------
 include/linux/kprobes.h        |    1 -
 kernel/kprobes.c               |    2 +-
 4 files changed, 1 insertion(+), 13 deletions(-)

--- a/arch/s390/kernel/kprobes.c~kprobes-remove-duplicated-strong-free_insn_page-in-x86-and-s390
+++ a/arch/s390/kernel/kprobes.c
@@ -44,11 +44,6 @@ void *alloc_insn_page(void)
 	return page;
 }
 
-void free_insn_page(void *page)
-{
-	module_memfree(page);
-}
-
 static void *alloc_s390_insn_page(void)
 {
 	if (xchg(&insn_page_in_use, 1) == 1)
--- a/arch/x86/kernel/kprobes/core.c~kprobes-remove-duplicated-strong-free_insn_page-in-x86-and-s390
+++ a/arch/x86/kernel/kprobes/core.c
@@ -422,12 +422,6 @@ void *alloc_insn_page(void)
 	return page;
 }
 
-/* Recover page to RW mode before releasing it */
-void free_insn_page(void *page)
-{
-	module_memfree(page);
-}
-
 /* Kprobe x86 instruction emulation - only regs->ip or IF flag modifiers */
 
 static void kprobe_emulate_ifmodifiers(struct kprobe *p, struct pt_regs *regs)
--- a/include/linux/kprobes.h~kprobes-remove-duplicated-strong-free_insn_page-in-x86-and-s390
+++ a/include/linux/kprobes.h
@@ -407,7 +407,6 @@ int enable_kprobe(struct kprobe *kp);
 void dump_kprobe(struct kprobe *kp);
 
 void *alloc_insn_page(void);
-void free_insn_page(void *page);
 
 int kprobe_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 		       char *sym);
--- a/kernel/kprobes.c~kprobes-remove-duplicated-strong-free_insn_page-in-x86-and-s390
+++ a/kernel/kprobes.c
@@ -106,7 +106,7 @@ void __weak *alloc_insn_page(void)
 	return module_alloc(PAGE_SIZE);
 }
 
-void __weak free_insn_page(void *page)
+static void free_insn_page(void *page)
 {
 	module_memfree(page);
 }
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

kprobes-remove-duplicated-strong-free_insn_page-in-x86-and-s390.patch

