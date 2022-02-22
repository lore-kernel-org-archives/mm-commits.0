Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CFAC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239724AbiBVDOP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:14:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbiBVDOE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:14:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC6DDEC3
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:13:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3958FB8184F
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7189C340E9;
        Tue, 22 Feb 2022 03:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499616;
        bh=hldkc7dNUjHPhGz8WzgVclpaANe5XT0TZ+/1YGCKo2A=;
        h=Date:To:From:Subject:From;
        b=jJcMibQnTe+11z3ttvTZU4R0OuskFfe5UQjcF0slJCYLq1CyCmLucsmZKg0uSubxX
         +7SmC0WAZ6vP7ZGFyyLNcga08rDXE3hntILtS7a6l75DO8E7aGwaDNvdlUAyxC5KG5
         ZAUlWoiVrkzB30L0s2WahMTNHQIbQZD2HFtTxNnw=
Date:   Mon, 21 Feb 2022 19:13:36 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        dalias@libc.org, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-mm-enable-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220222031336.C7189C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     sh-mm-enable-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sh-mm-enable-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sh-mm-enable-arch_has_vm_get_page_prot.patch

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
Subject: sh/mm: enable ARCH_HAS_VM_GET_PAGE_PROT

This defines and exports a platform specific custom vm_get_page_prot() via
subscribing ARCH_HAS_VM_GET_PAGE_PROT.  Subsequently all __SXXX and __PXXX
macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/1645425519-9034-18-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/Kconfig               |    1 
 arch/sh/include/asm/pgtable.h |   17 --------------
 arch/sh/mm/mmap.c             |   38 ++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 17 deletions(-)

--- a/arch/sh/include/asm/pgtable.h~sh-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sh/include/asm/pgtable.h
@@ -89,23 +89,6 @@ static inline unsigned long phys_addr_ma
  * completely separate permission bits for user and kernel space.
  */
 	 /*xwr*/
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY
-#define __P100	PAGE_EXECREAD
-#define __P101	PAGE_EXECREAD
-#define __P110	PAGE_COPY
-#define __P111	PAGE_COPY
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_WRITEONLY
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_EXECREAD
-#define __S101	PAGE_EXECREAD
-#define __S110	PAGE_RWX
-#define __S111	PAGE_RWX
 
 typedef pte_t *pte_addr_t;
 
--- a/arch/sh/Kconfig~sh-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sh/Kconfig
@@ -11,6 +11,7 @@ config SUPERH
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HIBERNATION_POSSIBLE if MMU
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
--- a/arch/sh/mm/mmap.c~sh-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sh/mm/mmap.c
@@ -162,3 +162,41 @@ int valid_mmap_phys_addr_range(unsigned
 {
 	return 1;
 }
+
+#ifdef CONFIG_MMU
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
+		return PAGE_EXECREAD;
+	case VM_EXEC | VM_WRITE:
+	case VM_EXEC | VM_WRITE | VM_READ:
+		return PAGE_COPY;
+	case VM_SHARED:
+		return PAGE_NONE;
+	case VM_SHARED | VM_READ:
+		return PAGE_READONLY;
+	case VM_SHARED | VM_WRITE:
+		return PAGE_WRITEONLY;
+	case VM_SHARED | VM_WRITE | VM_READ:
+		return PAGE_SHARED;
+	case VM_SHARED | VM_EXEC:
+	case VM_SHARED | VM_EXEC | VM_READ:
+		return PAGE_EXECREAD;
+	case VM_SHARED | VM_EXEC | VM_WRITE:
+	case VM_SHARED | VM_EXEC | VM_WRITE | VM_READ:
+		return PAGE_RWX;
+	default:
+		BUILD_BUG();
+	}
+}
+EXPORT_SYMBOL(vm_get_page_prot);
+#endif
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

