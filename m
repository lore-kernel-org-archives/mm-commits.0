Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26EA5C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1803161263
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhKEUiv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232734AbhKEUit (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AB5E611C0;
        Fri,  5 Nov 2021 20:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144569;
        bh=0d6uitbGLF/OFI0q7D4CCJ+ru0RJkFAdz8ZbF1SChaI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VK9w1Ki85O9htaQwpGSCOlwnTWjr9XRth1E+UFUpLXIll0zqI2QzFHLOdIeOYP6xp
         g0m3yjfZe8Ck0fC+Cy11F7igbNbQfIp0fqnjCJqnjpnnN++hoKrsZU+kNcrXbjHN16
         2GZ79jTJskreyIYTs2vycuyIew/qzSPpK+yHVU2g=
Date:   Fri, 05 Nov 2021 13:36:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, gerald.schaefer@linux.ibm.com,
        gshan@redhat.com, guoren@linux.alibaba.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 030/262] mm: debug_vm_pgtable: don't use __P000
 directly
Message-ID: <20211105203609.pRPXEXXRp%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
