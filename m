Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F711C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239761AbiBVDOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:14:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239621AbiBVDNv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:13:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D031FBF63
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:13:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FAE4612C8
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5789C340E9;
        Tue, 22 Feb 2022 03:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499603;
        bh=9YDCyhIFwiZurWS8pFiaiR5HhWuofcpvKkPRaqHECuY=;
        h=Date:To:From:Subject:From;
        b=ujBtTLVf3CbfOhs0cB1l2CGAEcl1UcWf/B4ccqiHQ0Xd5gYMRcwvvlI9C37RK6iGp
         fvnm5xt67c9Ur0lEPAopbMWJKSCi1RW57tlZfBc2tHw6Z+GLk3qR/3PeT6hU6JWI39
         Hw748orwK1EkPfnGfURtSiLL7rArCj5fXgzXiagI=
Date:   Mon, 21 Feb 2022 19:13:23 -0800
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-drop-arch_filter_pgprot.patch added to -mm tree
Message-Id: <20220222031323.C5789C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: drop arch_filter_pgprot()
has been added to the -mm tree.  Its filename is
     mm-mmap-drop-arch_filter_pgprot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-drop-arch_filter_pgprot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-drop-arch_filter_pgprot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/mmap: drop arch_filter_pgprot()

There are no platforms left which subscribe ARCH_HAS_FILTER_PGPROT.  Hence
just drop arch_filter_pgprot() and also the config ARCH_HAS_FILTER_PGPROT.

Link: https://lkml.kernel.org/r/1645425519-9034-13-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 ---
 mm/mmap.c  |   10 +---------
 2 files changed, 1 insertion(+), 12 deletions(-)

--- a/mm/Kconfig~mm-mmap-drop-arch_filter_pgprot
+++ a/mm/Kconfig
@@ -744,9 +744,6 @@ config IDLE_PAGE_TRACKING
 config ARCH_HAS_CACHE_LINE_SIZE
 	bool
 
-config ARCH_HAS_FILTER_PGPROT
-	bool
-
 config ARCH_HAS_VM_GET_PAGE_PROT
 	bool
 
--- a/mm/mmap.c~mm-mmap-drop-arch_filter_pgprot
+++ a/mm/mmap.c
@@ -102,14 +102,6 @@ static void unmap_region(struct mm_struc
  *								w: (no) no
  *								x: (yes) yes
  */
-
-#ifndef CONFIG_ARCH_HAS_FILTER_PGPROT
-static inline pgprot_t arch_filter_pgprot(pgprot_t prot)
-{
-	return prot;
-}
-#endif
-
 static inline pgprot_t __vm_get_page_prot(unsigned long vm_flags)
 {
 	switch (vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) {
@@ -155,7 +147,7 @@ pgprot_t vm_get_page_prot(unsigned long
 	pgprot_t ret = __pgprot(pgprot_val(__vm_get_page_prot(vm_flags)) |
 			pgprot_val(arch_vm_get_page_prot(vm_flags)));
 
-	return arch_filter_pgprot(ret);
+	return ret;
 }
 EXPORT_SYMBOL(vm_get_page_prot);
 #endif	/* CONFIG_ARCH_HAS_VM_GET_PAGE_PROT */
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch
mm-merge-pte_mkhuge-call-into-arch_make_huge_pte.patch
mm-debug_vm_pgtable-drop-protection_map-usage.patch
mm-mmap-clarify-protection_map-indices.patch
mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
powerpc-mm-enable-arch_has_vm_get_page_prot.patch
arm64-mm-enable-arch_has_vm_get_page_prot.patch
sparc-mm-enable-arch_has_vm_get_page_prot.patch
mips-mm-enable-arch_has_vm_get_page_prot.patch
m68k-mm-enable-arch_has_vm_get_page_prot.patch
arm-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-protection_map.patch
mm-mmap-drop-arch_filter_pgprot.patch
mm-mmap-drop-arch_vm_get_page_pgprot.patch
s390-mm-enable-arch_has_vm_get_page_prot.patch
riscv-mm-enable-arch_has_vm_get_page_prot.patch
alpha-mm-enable-arch_has_vm_get_page_prot.patch
sh-mm-enable-arch_has_vm_get_page_prot.patch
arc-mm-enable-arch_has_vm_get_page_prot.patch
csky-mm-enable-arch_has_vm_get_page_prot.patch
extensa-mm-enable-arch_has_vm_get_page_prot.patch
parisc-mm-enable-arch_has_vm_get_page_prot.patch
openrisc-mm-enable-arch_has_vm_get_page_prot.patch
um-mm-enable-arch_has_vm_get_page_prot.patch
microblaze-mm-enable-arch_has_vm_get_page_prot.patch
nios2-mm-enable-arch_has_vm_get_page_prot.patch
hexagon-mm-enable-arch_has_vm_get_page_prot.patch
nds32-mm-enable-arch_has_vm_get_page_prot.patch
ia64-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-generic-vm_get_page_prot.patch
mm-mmap-drop-arch_has_vm_get_page_prot.patch
mm-hugetlb-generalize-arch_want_general_hugetlb.patch
mm-migration-add-trace-events-for-thp-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch

