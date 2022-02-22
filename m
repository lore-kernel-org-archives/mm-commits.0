Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9E4C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiBVDOU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:14:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239645AbiBVDOP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:14:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3EBDFA3
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:13:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79ADA61504
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAE1C340E9;
        Tue, 22 Feb 2022 03:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499625;
        bh=rHnyaE3A0o/yDvoOaMK9hOjZQATzRTOzgQ5BuKgHDqk=;
        h=Date:To:From:Subject:From;
        b=RI8OmVHC0UUj3p3bTMKYBG1G4Ku4biElSdK7IqsGClZr1Wh8Bdn4lXplBSRHd58xL
         axeL5jE2/3YDv+7ZjUYcTEzX1pcu6AHUDqNPXmQWrQNvEe04ca65OID9s6voOJTDFO
         +y7HRaIjByMxR0TwmXImXMSnXdLevd8jYRV6K5+g=
Date:   Mon, 21 Feb 2022 19:13:45 -0800
To:     mm-commits@vger.kernel.org, guoren@kernel.org, chris@zankel.net,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + extensa-mm-enable-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220222031345.CAAE1C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: extensa/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     extensa-mm-enable-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/extensa-mm-enable-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/extensa-mm-enable-arch_has_vm_get_page_prot.patch

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
Subject: extensa/mm: enable ARCH_HAS_VM_GET_PAGE_PROT

This defines and exports a platform specific custom vm_get_page_prot() via
subscribing ARCH_HAS_VM_GET_PAGE_PROT.  Subsequently all __SXXX and __PXXX
macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/1645425519-9034-21-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Kconfig               |    1 
 arch/xtensa/include/asm/pgtable.h |   18 --------------
 arch/xtensa/mm/init.c             |   35 ++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 18 deletions(-)

--- a/arch/xtensa/include/asm/pgtable.h~extensa-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -200,24 +200,6 @@
  * What follows is the closest we can get by reasonable means..
  * See linux/mm/mmap.c for protection_map[] array that uses these definitions.
  */
-#define __P000	PAGE_NONE		/* private --- */
-#define __P001	PAGE_READONLY		/* private --r */
-#define __P010	PAGE_COPY		/* private -w- */
-#define __P011	PAGE_COPY		/* private -wr */
-#define __P100	PAGE_READONLY_EXEC	/* private x-- */
-#define __P101	PAGE_READONLY_EXEC	/* private x-r */
-#define __P110	PAGE_COPY_EXEC		/* private xw- */
-#define __P111	PAGE_COPY_EXEC		/* private xwr */
-
-#define __S000	PAGE_NONE		/* shared  --- */
-#define __S001	PAGE_READONLY		/* shared  --r */
-#define __S010	PAGE_SHARED		/* shared  -w- */
-#define __S011	PAGE_SHARED		/* shared  -wr */
-#define __S100	PAGE_READONLY_EXEC	/* shared  x-- */
-#define __S101	PAGE_READONLY_EXEC	/* shared  x-r */
-#define __S110	PAGE_SHARED_EXEC	/* shared  xw- */
-#define __S111	PAGE_SHARED_EXEC	/* shared  xwr */
-
 #ifndef __ASSEMBLY__
 
 #define pte_ERROR(e) \
--- a/arch/xtensa/Kconfig~extensa-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/xtensa/Kconfig
@@ -9,6 +9,7 @@ config XTENSA
 	select ARCH_HAS_DMA_SET_UNCACHED if MMU
 	select ARCH_HAS_STRNCPY_FROM_USER if !KASAN
 	select ARCH_HAS_STRNLEN_USER
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
--- a/arch/xtensa/mm/init.c~extensa-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/xtensa/mm/init.c
@@ -216,3 +216,38 @@ static int __init parse_memmap_opt(char
 	return 0;
 }
 early_param("memmap", parse_memmap_opt);
+
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	switch (vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) {
+	case VM_NONE:
+		return PAGE_NONE;
+	case VM_READ:
+		return PAGE_READONLY;
+	case VM_WRITE:
+	case VM_WRITE | VM_READ:
+		return PAGE_COPY;
+	case VM_EXEC:
+	case VM_EXEC | VM_READ:
+		return PAGE_READONLY_EXEC;
+	case VM_EXEC | VM_WRITE:
+	case VM_EXEC | VM_WRITE | VM_READ:
+		return PAGE_COPY_EXEC;
+	case VM_SHARED:
+		return PAGE_NONE;
+	case VM_SHARED | VM_READ:
+		return PAGE_READONLY;
+	case VM_SHARED | VM_WRITE:
+	case VM_SHARED | VM_WRITE | VM_READ:
+		return PAGE_SHARED;
+	case VM_SHARED | VM_EXEC:
+	case VM_SHARED | VM_EXEC | VM_READ:
+		return PAGE_READONLY_EXEC;
+	case VM_SHARED | VM_EXEC | VM_WRITE:
+	case VM_SHARED | VM_EXEC | VM_WRITE | VM_READ:
+		return PAGE_SHARED_EXEC;
+	default:
+		BUILD_BUG();
+	}
+}
+EXPORT_SYMBOL(vm_get_page_prot);
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

