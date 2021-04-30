Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0E3C43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CA86613F8
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhD3Fyg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhD3Fyg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F69861424;
        Fri, 30 Apr 2021 05:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762028;
        bh=iE4JsVw3HLB6rRaLNJnNhc1mBLUfYXpHqOZZvtJ50iI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FqJK3+RQyPuzuD+GKWY5Fw8LCTVXChZFLF913JSTN0Eg85g0jYj1nd6Z5a3vgDela
         tGfeP3weATH89zWOT6B1qpimEYPTRtPXW8Hjtdr1/g6XTJtvxdh13m4B3KUbGn/R7P
         cNQHmUiS4jw8wfwGuS7mzHSZQq1bWgMPfDNKWh+8=
Date:   Thu, 29 Apr 2021 22:53:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, slyfox@gentoo.org,
        torvalds@linux-foundation.org
Subject:  [patch 011/178] ia64: module: fix symbolizer crash on
 fdescr
Message-ID: <20210430055348.KC54UfE1I%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: ia64: module: fix symbolizer crash on fdescr

Noticed failure as a crash on ia64 when tried to symbolize all backtraces
collected by page_owner=on:

    $ cat /sys/kernel/debug/page_owner
    <oops>

    CPU: 1 PID: 2074 Comm: cat Not tainted 5.12.0-rc4 #226
    Hardware name: hp server rx3600, BIOS 04.03 04/08/2008
    ip is at dereference_module_function_descriptor+0x41/0x100

Crash happens at dereference_module_function_descriptor() due to
use-after-free when dereferencing ".opd" section header.

All section headers are already freed after module is laoded successfully.

To keep symbolizer working the change stores ".opd" address and size after
module is relocated to a new place and before section headers are
discarded.

To make similar errors less obscure module_finalize() now zeroes out all
variables relevant to module loading only.

Link: https://lkml.kernel.org/r/20210403074803.3309096-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/module.h |    6 +++++-
 arch/ia64/kernel/module.c      |   29 +++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 5 deletions(-)

--- a/arch/ia64/include/asm/module.h~ia64-module-fix-symbolizer-crash-on-fdescr
+++ a/arch/ia64/include/asm/module.h
@@ -14,16 +14,20 @@
 struct elf64_shdr;			/* forward declration */
 
 struct mod_arch_specific {
+	/* Used only at module load time. */
 	struct elf64_shdr *core_plt;	/* core PLT section */
 	struct elf64_shdr *init_plt;	/* init PLT section */
 	struct elf64_shdr *got;		/* global offset table */
 	struct elf64_shdr *opd;		/* official procedure descriptors */
 	struct elf64_shdr *unwind;	/* unwind-table section */
 	unsigned long gp;		/* global-pointer for module */
+	unsigned int next_got_entry;	/* index of next available got entry */
 
+	/* Used at module run and cleanup time. */
 	void *core_unw_table;		/* core unwind-table cookie returned by unwinder */
 	void *init_unw_table;		/* init unwind-table cookie returned by unwinder */
-	unsigned int next_got_entry;	/* index of next available got entry */
+	void *opd_addr;			/* symbolize uses .opd to get to actual function */
+	unsigned long opd_size;
 };
 
 #define ARCH_SHF_SMALL	SHF_IA_64_SHORT
--- a/arch/ia64/kernel/module.c~ia64-module-fix-symbolizer-crash-on-fdescr
+++ a/arch/ia64/kernel/module.c
@@ -905,9 +905,31 @@ register_unwind_table (struct module *mo
 int
 module_finalize (const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs, struct module *mod)
 {
+	struct mod_arch_specific *mas = &mod->arch;
+
 	DEBUGP("%s: init: entry=%p\n", __func__, mod->init);
-	if (mod->arch.unwind)
+	if (mas->unwind)
 		register_unwind_table(mod);
+
+	/*
+	 * ".opd" was already relocated to the final destination. Store
+	 * it's address for use in symbolizer.
+	 */
+	mas->opd_addr = (void *)mas->opd->sh_addr;
+	mas->opd_size = mas->opd->sh_size;
+
+	/*
+	 * Module relocation was already done at this point. Section
+	 * headers are about to be deleted. Wipe out load-time context.
+	 */
+	mas->core_plt = NULL;
+	mas->init_plt = NULL;
+	mas->got = NULL;
+	mas->opd = NULL;
+	mas->unwind = NULL;
+	mas->gp = 0;
+	mas->next_got_entry = 0;
+
 	return 0;
 }
 
@@ -926,10 +948,9 @@ module_arch_cleanup (struct module *mod)
 
 void *dereference_module_function_descriptor(struct module *mod, void *ptr)
 {
-	Elf64_Shdr *opd = mod->arch.opd;
+	struct mod_arch_specific *mas = &mod->arch;
 
-	if (ptr < (void *)opd->sh_addr ||
-			ptr >= (void *)(opd->sh_addr + opd->sh_size))
+	if (ptr < mas->opd_addr || ptr >= mas->opd_addr + mas->opd_size)
 		return ptr;
 
 	return dereference_function_descriptor(ptr);
_
