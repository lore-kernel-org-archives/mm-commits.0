Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC285C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbiBVDOB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:14:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239558AbiBVDOA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:14:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6925EDE97
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:13:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F02DB8184D
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0140C340E9;
        Tue, 22 Feb 2022 03:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499605;
        bh=4rb7uIOQpw7EeGyramV61NPx6UOHD3TASCQScfW6TmA=;
        h=Date:To:From:Subject:From;
        b=otgDv/J59PZDqMIe8zo1VOf0pF2SQPiWV4XxhKDaULHBcyCiBkudsAkbmXqh5vJkZ
         wkfxuoQkHXOChnnsXH+YN0x3uvV6X7kI04957AHgigEsjx1HabyJus5rhgtPrWYEjv
         9kRkfTAFc7xrEfKxq8G0LU9bomqSibq9aHP04ClY=
Date:   Mon, 21 Feb 2022 19:13:25 -0800
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-drop-arch_vm_get_page_pgprot.patch added to -mm tree
Message-Id: <20220222031325.C0140C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: drop arch_vm_get_page_pgprot()
has been added to the -mm tree.  Its filename is
     mm-mmap-drop-arch_vm_get_page_pgprot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-drop-arch_vm_get_page_pgprot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-drop-arch_vm_get_page_pgprot.patch

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
Subject: mm/mmap: drop arch_vm_get_page_pgprot()

There are no platforms left which use arch_vm_get_page_prot().  Just drop
arch_vm_get_page_prot() construct and simplify remaining code.

Link: https://lkml.kernel.org/r/1645425519-9034-14-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |    4 ----
 mm/mmap.c            |   10 +---------
 2 files changed, 1 insertion(+), 13 deletions(-)

--- a/include/linux/mman.h~mm-mmap-drop-arch_vm_get_page_pgprot
+++ a/include/linux/mman.h
@@ -93,10 +93,6 @@ static inline void vm_unacct_memory(long
 #define arch_calc_vm_flag_bits(flags) 0
 #endif
 
-#ifndef arch_vm_get_page_prot
-#define arch_vm_get_page_prot(vm_flags) __pgprot(0)
-#endif
-
 #ifndef arch_validate_prot
 /*
  * This is called from mprotect().  PROT_GROWSDOWN and PROT_GROWSUP have
--- a/mm/mmap.c~mm-mmap-drop-arch_vm_get_page_pgprot
+++ a/mm/mmap.c
@@ -102,7 +102,7 @@ static void unmap_region(struct mm_struc
  *								w: (no) no
  *								x: (yes) yes
  */
-static inline pgprot_t __vm_get_page_prot(unsigned long vm_flags)
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
 {
 	switch (vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) {
 	case VM_NONE:
@@ -141,14 +141,6 @@ static inline pgprot_t __vm_get_page_pro
 		BUILD_BUG();
 	}
 }
-
-pgprot_t vm_get_page_prot(unsigned long vm_flags)
-{
-	pgprot_t ret = __pgprot(pgprot_val(__vm_get_page_prot(vm_flags)) |
-			pgprot_val(arch_vm_get_page_prot(vm_flags)));
-
-	return ret;
-}
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

