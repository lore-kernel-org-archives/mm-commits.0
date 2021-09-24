Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74144C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 02:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52DA061100
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 02:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbhIXCvB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 22:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243928AbhIXCvA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 22:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A12E7610C9;
        Fri, 24 Sep 2021 02:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632451767;
        bh=fX1ENSqmBB3VxrZWicxFu1Es20R/MaJUE4pTkkxrILw=;
        h=Date:From:To:Subject:From;
        b=lqY8NxJHHcsjeSg0OO7PoBtqRqNfAFDaRixi4OOc8ktYO3M5m5/7ulpsqVGn/BYMm
         sayBPGWR7kK/AwUMWor9JptCCuwEshol2xSPR0oPz/eG58gJDray1P9wiPhWQTDBbz
         sPmCVyLh9amwPMHbr/yqtiVn9ODD4u7ehl6O6lhA=
Date:   Thu, 23 Sep 2021 19:49:27 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, gshan@redhat.com,
        guoren@linux.alibaba.com, mm-commits@vger.kernel.org
Subject:  + mm-debug_vm_pgtable-dont-use-__p000-directly.patch
 added to -mm tree
Message-ID: <20210924024927.H1Aj2QSF3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: debug_vm_pgtable: Don't use __P000 directly
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
Subject: mm: debug_vm_pgtable: Don't use __P000 directly

The __Pxxx/__Sxxx macros are only for init protection_map[].  All usage of
them in linux should come from protection_map array.

Because a lot of architectures would re-initilize protection_map[] array,
eg: x86-mem_encrypt, m68k-motorola, mips, arm, sparc.

Using __P000 maybe won't cause bug because hw would deny access with
PROT_NONE permission, but it's not rigorous.

Link: https://lkml.kernel.org/r/20210921201815.284412-1-guoren@kernel.org
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-dont-use-__p000-directly
+++ a/mm/debug_vm_pgtable.c
@@ -1104,13 +1104,13 @@ static int __init init_args(struct pgtab
 	/*
 	 * Initialize the debugging data.
 	 *
-	 * __P000 (or even __S000) will help create page table entries with
+	 * __P000 (protection_map[0]) will help create page table entries with
 	 * PROT_NONE permission as required for pxx_protnone_tests().
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

