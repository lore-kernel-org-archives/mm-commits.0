Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFB6C43334
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 00:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiGBAHD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiGBAHD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 20:07:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA28D369CB
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 17:07:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61665B83107
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 00:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA03C3411E;
        Sat,  2 Jul 2022 00:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656720419;
        bh=XE/iuDIOTvoALvXsvjPpY3lQbGQNhiyuV+zTp/64njI=;
        h=Date:To:From:Subject:From;
        b=aLEH6qZ1+HkW5INQelF+QFfXEvkEUvHu8jlp5l06PyXn5u/3XBUuP/bKk9bhoV4PL
         EWmsdHURvCrFxybHgLIkrZULVDeQeHYX1rlOcAw7Pdei6WZJcZHM78X7DPn5tYBF15
         IdxE5pVvuFFZCzl9G+9EjhVdtAN+UDyTf7B1uWcY=
Date:   Fri, 01 Jul 2022 17:06:58 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-build-protect-protection_map-with-__p000.patch added to mm-unstable branch
Message-Id: <20220702000659.0DA03C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: build protect protection_map[] with __P000
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-build-protect-protection_map-with-__p000.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-build-protect-protection_map-with-__p000.patch

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
Subject: mm/mmap: build protect protection_map[] with __P000
Date: Thu, 30 Jun 2022 10:46:05 +0530

Patch series "mm/mmap: Drop __SXXX/__PXXX macros from across platforms",
v6.

__SXXX/__PXXX macros are an unnecessary abstraction layer in creating the
generic protection_map[] array which is used for vm_get_page_prot().  This
abstraction layer can be avoided, if the platforms just define the array
protection_map[] for all possible vm_flags access permission combinations
and also export vm_get_page_prot() implementation.

This series drops __SXXX/__PXXX macros from across platforms in the tree. 
First it build protects generic protection_map[] array with '#ifdef
__P000' and moves it inside platforms which enable
ARCH_HAS_VM_GET_PAGE_PROT.  Later this build protects same array with
'#ifdef ARCH_HAS_VM_GET_PAGE_PROT' and moves inside remaining platforms
while enabling ARCH_HAS_VM_GET_PAGE_PROT.  This adds a new macro
DECLARE_VM_GET_PAGE_PROT defining the current generic vm_get_page_prot(),
in order for it to be reused on platforms that do not require custom
implementation.  Finally, ARCH_HAS_VM_GET_PAGE_PROT can just be dropped,
as all platforms now define and export vm_get_page_prot(), via looking up
a private and static protection_map[] array.  protection_map[] data type
has been changed as 'static const' on all platforms that do not change it
during boot.


This patch (of 26):

Build protect generic protection_map[] array with __P000, so that it can
be moved inside all the platforms one after the other.  Otherwise there
will be build failures during this process. 
CONFIG_ARCH_HAS_VM_GET_PAGE_PROT cannot be used for this purpose as only
certain platforms enable this config now.

Link: https://lkml.kernel.org/r/20220630051630.1718927-1-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/20220630051630.1718927-2-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/mmap.c          |    2 ++
 2 files changed, 4 insertions(+)

--- a/include/linux/mm.h~mm-mmap-build-protect-protection_map-with-__p000
+++ a/include/linux/mm.h
@@ -424,7 +424,9 @@ extern unsigned int kobjsize(const void
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
  */
+#ifdef __P000
 extern pgprot_t protection_map[16];
+#endif
 
 /*
  * The default fault flags that should be used by most of the
--- a/mm/mmap.c~mm-mmap-build-protect-protection_map-with-__p000
+++ a/mm/mmap.c
@@ -100,6 +100,7 @@ static void unmap_region(struct mm_struc
  *								w: (no) no
  *								x: (yes) yes
  */
+#ifdef __P000
 pgprot_t protection_map[16] __ro_after_init = {
 	[VM_NONE]					= __P000,
 	[VM_READ]					= __P001,
@@ -118,6 +119,7 @@ pgprot_t protection_map[16] __ro_after_i
 	[VM_SHARED | VM_EXEC | VM_WRITE]		= __S110,
 	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= __S111
 };
+#endif
 
 #ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
 pgprot_t vm_get_page_prot(unsigned long vm_flags)
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

