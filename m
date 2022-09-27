Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67274C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiI0C4L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiI0CyZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:54:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B010211458
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 564D9B81987
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A060C433D6;
        Tue, 27 Sep 2022 02:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246999;
        bh=1vHiHVYlOXRld0IO2OkRGc0BcsktCsKiumMehl8opqU=;
        h=Date:To:From:Subject:From;
        b=vqxIc+Cs9aGAaPI34SvfIh6q8TPdS6PIJbFTMVbKl5/RWQo9NTAj4WroJIq+UO8iy
         zFiOpqcbufFeN40DXHwwApXVzfvnBoLCGoUBws/4FFVr96CYyw/6Em/hYkszvHXG/l
         YO6FtwBZQE/f6byno4GoJrU+KyXUllnyXDj8pFxk=
Date:   Mon, 26 Sep 2022 19:49:58 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, Liam.Howlett@oracle.com, dhowells@redhat.com,
        david@redhat.com, dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-use-vma-iterator-for-vdso.patch removed from -mm tree
Message-Id: <20220927024959.0A060C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: riscv: use vma iterator for vdso
has been removed from the -mm tree.  Its filename was
     riscv-use-vma-iterator-for-vdso.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: riscv: use vma iterator for vdso
Date: Tue, 6 Sep 2022 19:49:05 +0000

Remove the linked list use in favour of the vma iterator.

Link: https://lkml.kernel.org/r/20220906194824.2110408-67-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/vdso.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/vdso.c~riscv-use-vma-iterator-for-vdso
+++ a/arch/riscv/kernel/vdso.c
@@ -114,11 +114,12 @@ int vdso_join_timens(struct task_struct
 {
 	struct mm_struct *mm = task->mm;
 	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, mm, 0);
 	struct __vdso_info *vdso_info = mm->context.vdso_info;
 
 	mmap_read_lock(mm);
 
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+	for_each_vma(vmi, vma) {
 		unsigned long size = vma->vm_end - vma->vm_start;
 
 		if (vma_is_special_mapping(vma, vdso_info->dm))
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


