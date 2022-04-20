Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4E8C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 20:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238088AbiDTUd5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 16:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348222AbiDTUd4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 16:33:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51818377C7
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 13:31:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04F3FB8215F
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 20:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC2AC385A1;
        Wed, 20 Apr 2022 20:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650486666;
        bh=n5uFQ7VM7EgDdEKlciAiuZLm0nlb9GuKfAQ4MmYnmDY=;
        h=Date:To:From:Subject:From;
        b=KURwUrS/wWItOcQgsf6vzVqKCdHgTMGy1tUkQ0f3wuV10gZxBUbdSVIYMrTE24qAt
         l9RAmXCisW/UfCD067UcMvLeHnpT7hKtEcp+qw2ElaTIGDPw8kphT3+5BIMIOW4QRt
         xZM80mGg3NShc1BZ1nMFakp/3dpX7s24KBKDUrwE=
Date:   Wed, 20 Apr 2022 13:31:05 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        Liam.Howlett@oracle.com, catalin.marinas@arm.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch added to -mm tree
Message-Id: <20220420203106.AEC2AC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: change elfcore for_each_mte_vma() to use VMA iterator
has been added to the -mm tree.  Its filename is
     arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch

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

--- a/arch/arm64/kernel/elfcore.c~arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator
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
arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch
riscv-use-vma-iterator-for-vdso.patch
mm-mmapc-pass-in-mapping-to-__vma_link_file.patch
mglru-vs-maple-tree-fix.patch

