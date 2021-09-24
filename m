Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C293C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B39361242
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 20:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343663AbhIXUyN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 16:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhIXUyM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 16:54:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4C6E611C8;
        Fri, 24 Sep 2021 20:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632516759;
        bh=y0eMlTkhxggb05jCaENvWCcUGCcWdHdNdJU1R9K3jG4=;
        h=Date:From:To:Subject:From;
        b=0q6iBPQTEV1xYkTAScY/gV1If8MxpFecsP6dhDvyAJM8HIft/IyOtwGNcHs5pxVvs
         vz67tfJT0wfIsVvUkMRSl6ivgI4dc1rdDisQw9jD7/oVqfNrUPCqHZ4Ieqex+BeDqq
         JYAbRnaaKsv7HAprwa0mAGTt8IWz75BiS6meEGzk=
Date:   Fri, 24 Sep 2021 13:52:38 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, gshan@redhat.com,
        guoren@linux.alibaba.com, mm-commits@vger.kernel.org
Subject:  [to-be-updated]
 mm-debug_vm_pgtable-dont-use-__p000-directly.patch removed from -mm tree
Message-ID: <20210924205238.sBEOsKBFe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: debug_vm_pgtable: Don't use __P000 directly
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-dont-use-__p000-directly.patch

This patch was dropped because an updated version will be merged

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


