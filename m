Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30F1C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 19:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244911AbiDSTod (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 15:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243888AbiDSToc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 15:44:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1D940A3A
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 12:41:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88A9A6167E
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 19:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D348BC385A5;
        Tue, 19 Apr 2022 19:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650397307;
        bh=45fxnu+Ohhx6BwN6n8eGN9lnlCtjqSiV3xZUxr/ye50=;
        h=Date:To:From:Subject:From;
        b=XTOjl4qGhfd4l7/7AxgJ3GyLowpAjNwKxowaOXY0pQPP8oJ6DbVGIphz6vYRk3Chv
         vCfciLfqvNj8YmB0pI1rFG++pCJsEG+HNuB1rP9JJ8AIcV6Rf7yPbhWBdZQmq9fbTh
         U45tdTG37Ao6g8JvlfjCBReDPtDZ71aL9shGg304=
Date:   Tue, 19 Apr 2022 12:41:47 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        Liam.Howlett@oracle.com, catalin.marinas@arm.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-remove-mmap-linked-list-from-vdso-fix.patch added to -mm tree
Message-Id: <20220419194147.D348BC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: change elfcore for_each_mte_vma() to use VMA iterator
has been added to the -mm tree.  Its filename is
     arm64-remove-mmap-linked-list-from-vdso-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-remove-mmap-linked-list-from-vdso-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-remove-mmap-linked-list-from-vdso-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: arm64: change elfcore for_each_mte_vma() to use VMA iterator

Rework for_each_mte_vma() to use a VMA iterator instead of an explicit
linked-list.

Link: https://lore.kernel.org/r/20220218023650.672072-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20220419192157.2jn6olj7lg6jvo5e@revolver
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Will Deacon <will@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/elfcore.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/elfcore.c~arm64-remove-mmap-linked-list-from-vdso-fix
+++ a/arch/arm64/kernel/elfcore.c
@@ -8,9 +8,9 @@
 #include <asm/cpufeature.h>
 #include <asm/mte.h>
 
-#define for_each_mte_vma(tsk, vma)					\
+#define for_each_mte_vma(vmi, vma)					\
 	if (system_supports_mte())					\
-		for (vma = tsk->mm->mmap; vma; vma = vma->vm_next)	\
+		for_each_vma(vmi, vma)					\
 			if (vma->vm_flags & VM_MTE)
 
 static unsigned long mte_vma_tag_dump_size(struct vm_area_struct *vma)
@@ -81,8 +81,9 @@ Elf_Half elf_core_extra_phdrs(void)
 {
 	struct vm_area_struct *vma;
 	int vma_count = 0;
+	VMA_ITERATOR(vmi, current->mm, 0);
 
-	for_each_mte_vma(current, vma)
+	for_each_mte_vma(vmi, vma)
 		vma_count++;
 
 	return vma_count;
@@ -91,8 +92,9 @@ Elf_Half elf_core_extra_phdrs(void)
 int elf_core_write_extra_phdrs(struct coredump_params *cprm, loff_t offset)
 {
 	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, current->mm, 0);
 
-	for_each_mte_vma(current, vma) {
+	for_each_mte_vma(vmi, vma) {
 		struct elf_phdr phdr;
 
 		phdr.p_type = PT_ARM_MEMTAG_MTE;
@@ -116,8 +118,9 @@ size_t elf_core_extra_data_size(void)
 {
 	struct vm_area_struct *vma;
 	size_t data_size = 0;
+	VMA_ITERATOR(vmi, current->mm, 0);
 
-	for_each_mte_vma(current, vma)
+	for_each_mte_vma(vmi, vma)
 		data_size += mte_vma_tag_dump_size(vma);
 
 	return data_size;
@@ -126,8 +129,9 @@ size_t elf_core_extra_data_size(void)
 int elf_core_write_extra_data(struct coredump_params *cprm)
 {
 	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, current->mm, 0);
 
-	for_each_mte_vma(current, vma) {
+	for_each_mte_vma(vmi, vma) {
 		if (vma->vm_flags & VM_DONTDUMP)
 			continue;
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

radix-tree-test-suite-add-lockdep_is_held-to-header.patch
mips-rename-mt_init-to-mips_mt_init.patch
maple-tree-add-new-data-structure-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree.patch
mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch
arm64-remove-mmap-linked-list-from-vdso-fix.patch
riscv-use-vma-iterator-for-vdso.patch
mm-mmapc-pass-in-mapping-to-__vma_link_file.patch
mglru-vs-maple-tree-fix.patch

