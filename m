Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9824C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238751AbiBVDNX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:13:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239715AbiBVDNW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:13:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F209B85D
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:12:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E51B61525
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D868DC340E9;
        Tue, 22 Feb 2022 03:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499575;
        bh=21QfLKoCTOcj+L+9p/iCjjbCHs5iwQWiU3KrXVUSeUM=;
        h=Date:To:From:Subject:From;
        b=sWvz1lRaz75VISHaPaujIKMl2uJsoqDB5QO/P4NFPgtZJkIVcCMiXKtLb8ppGnsah
         MS2MuXRNrIPoGPOgdbbSR2N0jhOoDMB5lZKJ8Qdah5qmqF7OrP6HjWbQEYsv3rt+9n
         R/EPYT5P+6LF8BoaZdJghJFGahQCLvCGHx38keKg=
Date:   Mon, 21 Feb 2022 19:12:55 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220222031255.D868DC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: add new config ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch

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
Subject: mm/mmap: add new config ARCH_HAS_VM_GET_PAGE_PROT

Add a new config ARCH_HAS_VM_GET_PAGE_PROT, which when subscribed enables
a given platform to define its own vm_get_page_prot().  This framework
will help remove protection_map[] dependency going forward.

Link: https://lkml.kernel.org/r/1645425519-9034-4-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 +++
 mm/mmap.c  |    2 ++
 2 files changed, 5 insertions(+)

--- a/mm/Kconfig~mm-mmap-add-new-config-arch_has_vm_get_page_prot
+++ a/mm/Kconfig
@@ -747,6 +747,9 @@ config ARCH_HAS_CACHE_LINE_SIZE
 config ARCH_HAS_FILTER_PGPROT
 	bool
 
+config ARCH_HAS_VM_GET_PAGE_PROT
+	bool
+
 config ARCH_HAS_PTE_DEVMAP
 	bool
 
--- a/mm/mmap.c~mm-mmap-add-new-config-arch_has_vm_get_page_prot
+++ a/mm/mmap.c
@@ -81,6 +81,7 @@ static void unmap_region(struct mm_struc
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
 
+#ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
 /* description of effects of mapping type and prot in current implementation.
  * this is due to the limited x86 page protection hardware.  The expected
  * behavior is in parens:
@@ -136,6 +137,7 @@ pgprot_t vm_get_page_prot(unsigned long
 	return arch_filter_pgprot(ret);
 }
 EXPORT_SYMBOL(vm_get_page_prot);
+#endif	/* CONFIG_ARCH_HAS_VM_GET_PAGE_PROT */
 
 static pgprot_t vm_pgprot_modify(pgprot_t oldprot, unsigned long vm_flags)
 {
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

