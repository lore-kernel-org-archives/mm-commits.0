Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CA0C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDB8E61260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbhKKCnb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:43:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233906AbhKKCnb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:43:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9013E61354;
        Thu, 11 Nov 2021 02:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598442;
        bh=ZHU/szrwqaIcrfit1bLc1bEsq2w/V2pu4TCVvIEI6jY=;
        h=Date:From:To:Subject:From;
        b=clnG0MZyr+N1ZSLLMwZPStJ/LMo8wTlRqn4LVVHRHdCtJ2EdTk1ZfW/TP9OFCIufH
         BRyk1MhLfLY+mP8oWZoCMcnyvaSEh5SxfagGq2Q75/IN8fl+r43E6iUkEes+MusJQh
         qr0bcxFErQ+iVY+I2xhLKHhGVN+P3hHBaonqC50w=
Date:   Wed, 10 Nov 2021 18:40:42 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, gerald.schaefer@linux.ibm.com,
        gshan@redhat.com, guoren@linux.alibaba.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-debug_vm_pgtable-dont-use-__p000-directly.patch removed from -mm tree
Message-ID: <20211111024042.bYQZJ6npZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: debug_vm_pgtable: don't use __P000 directly
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-dont-use-__p000-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Ren <guoren@linux.alibaba.com>
Subject: mm: debug_vm_pgtable: don't use __P000 directly

The __Pxxx/__Sxxx macros are only for protection_map[] init.  All usage of
them in linux should come from protection_map array.

Because a lot of architectures would re-initilize protection_map[] array,
eg: x86-mem_encrypt, m68k-motorola, mips, arm, sparc.

Using __P000 is not rigorous.

Link: https://lkml.kernel.org/r/20210924060821.1138281-1-guoren@kernel.org
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-dont-use-__p000-directly
+++ a/mm/debug_vm_pgtable.c
@@ -1104,13 +1104,14 @@ static int __init init_args(struct pgtab
 	/*
 	 * Initialize the debugging data.
 	 *
-	 * __P000 (or even __S000) will help create page table entries with
-	 * PROT_NONE permission as required for pxx_protnone_tests().
+	 * protection_map[0] (or even protection_map[8]) will help create
+	 * page table entries with PROT_NONE permission as required for
+	 * pxx_protnone_tests().
 	 */
 	memset(args, 0, sizeof(*args));
 	args->vaddr              = get_random_vaddr();
 	args->page_prot          = vm_get_page_prot(VMFLAGS);
-	args->page_prot_none     = __P000;
+	args->page_prot_none     = protection_map[0];
 	args->is_contiguous_page = false;
 	args->pud_pfn            = ULONG_MAX;
 	args->pmd_pfn            = ULONG_MAX;
_

Patches currently in -mm which might be from guoren@linux.alibaba.com are


