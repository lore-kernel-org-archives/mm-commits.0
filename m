Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8CAC07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiI0CxR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiI0CvP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:51:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB152FAC5B
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 814BFB8191F
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252F6C433D7;
        Tue, 27 Sep 2022 02:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246953;
        bh=KbU1HhHNor3dtS2C30YIUrjfT/S2diUmcRTJLgTXpAk=;
        h=Date:To:From:Subject:From;
        b=ZXd1PxkXeLV6NLyc9VNfL7fyFIYCyRot3W86o3B8iQm2uv+uP20kCDkQu11ZrZqCf
         JT/kNj/tKREwvXev+oqHmaN6jxfCoLwWNHybeCHNKfDym6Ldq58A0Li9LzM1Uxz0To
         8hWTvPGaxLcvyvcWA3lundIn3hdDDifNwpEaER6k=
Date:   Mon, 26 Sep 2022 19:49:12 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, Liam.Howlett@oracle.com, dhowells@redhat.com,
        david@redhat.com, dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch removed from -mm tree
Message-Id: <20220927024913.252F6C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: change elfcore for_each_mte_vma() to use VMA iterator
has been removed from the -mm tree.  Its filename was
     arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: arm64: Change elfcore for_each_mte_vma() to use VMA iterator
Date: Tue, 6 Sep 2022 19:48:53 +0000

Rework for_each_mte_vma() to use a VMA iterator instead of an explicit
linked-list.

Link: https://lkml.kernel.org/r/20220906194824.2110408-32-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220218023650.672072-1-Liam.Howlett@oracle.com
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
 
 		phdr.p_type = PT_AARCH64_MEMTAG_MTE;
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

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


