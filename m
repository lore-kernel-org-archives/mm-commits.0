Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E4EC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB3161242
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345170AbhIXUzX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 16:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhIXUzW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 16:55:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6A1E60F13;
        Fri, 24 Sep 2021 20:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632516829;
        bh=ZpWwFAnBf2WSGRRryxNNkNnixlZSqr5tpWgKQcJgHGU=;
        h=Date:From:To:Subject:From;
        b=rhW4r3/JL53CW34zodZZk6JlOwyUc4A/0oqbLzlJ8RONPTOgtQZJVWIZ4db8f1XLR
         o3kitwCgRi9txrIoorK7kG4DMvS4q8NvSc2/Oz78QuooDMJFWInCzNZ0BhhxsUfTWe
         Bpu6wkDQp2142SVugrTDZYYS7+4eELsD4STgiCu8=
Date:   Fri, 24 Sep 2021 13:53:48 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, gerald.schaefer@linux.ibm.com,
        gshan@redhat.com, guoren@linux.alibaba.com,
        mm-commits@vger.kernel.org
Subject:  + mm-debug_vm_pgtable-dont-use-__p000-directly.patch
 added to -mm tree
Message-ID: <20210924205348.S4Xs3w0EN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: debug_vm_pgtable: don't use __P000 directly
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-dont-use-__p000-directly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-dont-use-__p000-directly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-dont-use-__p000-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
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

mm-debug_vm_pgtable-dont-use-__p000-directly.patch

