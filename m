Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E00C43334
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 00:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiGBAHH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiGBAHF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 20:07:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E157A369CB
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 17:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AD76B8326F
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 00:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22440C3411E;
        Sat,  2 Jul 2022 00:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656720421;
        bh=SUzIuI8pxiaB9GLwoXZLefdvtpTG+xiZJSfr1t9xSJw=;
        h=Date:To:From:Subject:From;
        b=tPVFWpJ0R/2nfWEYaTLoRyNZWw5evY2sa+U9ja8cMG6cvuWhc23KjyoJAaE3V8GuQ
         km1WFkqh6zrpPM89vkCU1eUwgEsvXzMo3PK+LGtLICwl9+xcIgSNz+iz+ywDgz3Kjo
         uKmhqLmDo2P+m7pxCem/YwxiPI6u3X5DJDLWkJZo=
Date:   Fri, 01 Jul 2022 17:07:00 -0700
To:     mm-commits@vger.kernel.org, hch@infradead.org,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-define-declare_vm_get_page_prot.patch added to mm-unstable branch
Message-Id: <20220702000701.22440C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: define DECLARE_VM_GET_PAGE_PROT
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-define-declare_vm_get_page_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-define-declare_vm_get_page_prot.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/mmap: define DECLARE_VM_GET_PAGE_PROT
Date: Thu, 30 Jun 2022 10:46:06 +0530

This just converts the generic vm_get_page_prot() implementation into a
new macro i.e DECLARE_VM_GET_PAGE_PROT which later can be used across
platforms when enabling them with ARCH_HAS_VM_GET_PAGE_PROT.  This does
not create any functional change.

Link: https://lkml.kernel.org/r/20220630051630.1718927-3-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   28 ++++++++++++++++++++++++++++
 mm/mmap.c               |   26 +-------------------------
 2 files changed, 29 insertions(+), 25 deletions(-)

--- a/include/linux/pgtable.h~mm-mmap-define-declare_vm_get_page_prot
+++ a/include/linux/pgtable.h
@@ -1689,4 +1689,32 @@ typedef unsigned int pgtbl_mod_mask;
 #define MAX_PTRS_PER_P4D PTRS_PER_P4D
 #endif
 
+/* description of effects of mapping type and prot in current implementation.
+ * this is due to the limited x86 page protection hardware.  The expected
+ * behavior is in parens:
+ *
+ * map_type	prot
+ *		PROT_NONE	PROT_READ	PROT_WRITE	PROT_EXEC
+ * MAP_SHARED	r: (no) no	r: (yes) yes	r: (no) yes	r: (no) yes
+ *		w: (no) no	w: (no) no	w: (yes) yes	w: (no) no
+ *		x: (no) no	x: (no) yes	x: (no) yes	x: (yes) yes
+ *
+ * MAP_PRIVATE	r: (no) no	r: (yes) yes	r: (no) yes	r: (no) yes
+ *		w: (no) no	w: (no) no	w: (copy) copy	w: (no) no
+ *		x: (no) no	x: (no) yes	x: (no) yes	x: (yes) yes
+ *
+ * On arm64, PROT_EXEC has the following behaviour for both MAP_SHARED and
+ * MAP_PRIVATE (with Enhanced PAN supported):
+ *								r: (no) no
+ *								w: (no) no
+ *								x: (yes) yes
+ */
+#define DECLARE_VM_GET_PAGE_PROT					\
+pgprot_t vm_get_page_prot(unsigned long vm_flags)			\
+{									\
+		return protection_map[vm_flags &			\
+			(VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)];	\
+}									\
+EXPORT_SYMBOL(vm_get_page_prot);
+
 #endif /* _LINUX_PGTABLE_H */
--- a/mm/mmap.c~mm-mmap-define-declare_vm_get_page_prot
+++ a/mm/mmap.c
@@ -80,26 +80,6 @@ static void unmap_region(struct mm_struc
 		struct vm_area_struct *next, unsigned long start,
 		unsigned long end);
 
-/* description of effects of mapping type and prot in current implementation.
- * this is due to the limited x86 page protection hardware.  The expected
- * behavior is in parens:
- *
- * map_type	prot
- *		PROT_NONE	PROT_READ	PROT_WRITE	PROT_EXEC
- * MAP_SHARED	r: (no) no	r: (yes) yes	r: (no) yes	r: (no) yes
- *		w: (no) no	w: (no) no	w: (yes) yes	w: (no) no
- *		x: (no) no	x: (no) yes	x: (no) yes	x: (yes) yes
- *
- * MAP_PRIVATE	r: (no) no	r: (yes) yes	r: (no) yes	r: (no) yes
- *		w: (no) no	w: (no) no	w: (copy) copy	w: (no) no
- *		x: (no) no	x: (no) yes	x: (no) yes	x: (yes) yes
- *
- * On arm64, PROT_EXEC has the following behaviour for both MAP_SHARED and
- * MAP_PRIVATE (with Enhanced PAN supported):
- *								r: (no) no
- *								w: (no) no
- *								x: (yes) yes
- */
 #ifdef __P000
 pgprot_t protection_map[16] __ro_after_init = {
 	[VM_NONE]					= __P000,
@@ -122,11 +102,7 @@ pgprot_t protection_map[16] __ro_after_i
 #endif
 
 #ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
-pgprot_t vm_get_page_prot(unsigned long vm_flags)
-{
-	return protection_map[vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
-}
-EXPORT_SYMBOL(vm_get_page_prot);
+DECLARE_VM_GET_PAGE_PROT
 #endif	/* CONFIG_ARCH_HAS_VM_GET_PAGE_PROT */
 
 static pgprot_t vm_pgprot_modify(pgprot_t oldprot, unsigned long vm_flags)
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-mmap-build-protect-protection_map-with-__p000.patch
mm-mmap-define-declare_vm_get_page_prot.patch
powerpc-mm-move-protection_map-inside-the-platform.patch
sparc-mm-move-protection_map-inside-the-platform.patch
arm64-mm-move-protection_map-inside-the-platform.patch
x86-mm-move-protection_map-inside-the-platform.patch
mm-mmap-build-protect-protection_map-with-arch_has_vm_get_page_prot.patch
microblaze-mm-enable-arch_has_vm_get_page_prot.patch
loongarch-mm-enable-arch_has_vm_get_page_prot.patch
openrisc-mm-enable-arch_has_vm_get_page_prot.patch
xtensa-mm-enable-arch_has_vm_get_page_prot.patch
hexagon-mm-enable-arch_has_vm_get_page_prot.patch
parisc-mm-enable-arch_has_vm_get_page_prot.patch
alpha-mm-enable-arch_has_vm_get_page_prot.patch
nios2-mm-enable-arch_has_vm_get_page_prot.patch
riscv-mm-enable-arch_has_vm_get_page_prot.patch
csky-mm-enable-arch_has_vm_get_page_prot.patch
s390-mm-enable-arch_has_vm_get_page_prot.patch
ia64-mm-enable-arch_has_vm_get_page_prot.patch
mips-mm-enable-arch_has_vm_get_page_prot.patch
m68k-mm-enable-arch_has_vm_get_page_prot.patch
arc-mm-enable-arch_has_vm_get_page_prot.patch
arm-mm-enable-arch_has_vm_get_page_prot.patch
um-mm-enable-arch_has_vm_get_page_prot.patch
sh-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-arch_has_vm_get_page_prot.patch

