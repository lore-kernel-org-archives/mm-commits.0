Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9259C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 18:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354181AbiDSSi1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357672AbiDSSh6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 14:37:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327F1165A4
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 11:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E217DB818E0
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 18:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EFCC385A5;
        Tue, 19 Apr 2022 18:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650393171;
        bh=6NWsz0ftcvOEBHU1RNm6W1Asors96kbnGE8eJQ+VXhk=;
        h=Date:To:From:Subject:From;
        b=mJ68OGH+rNhzlsXprGTiVMpp4AZhAtTEObSLDochrPhSi00RHoNwdEN+OSAyEiZhn
         kijsdnMmNsGAwvDmHaEPIRhKcHsgtTa6xBOm5R8bzt9gTzVm7//26s+hyiZO/PATP/
         zzqePDD6YcPglbyM46K1eT6anGdAG+wXJ5GNsTKo=
Date:   Tue, 19 Apr 2022 11:32:50 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mglru-vs-maple-tree-fix.patch added to -mm tree
Message-Id: <20220419183251.75EFCC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: Use VMA_ITERATOR in get_next_vma()
has been added to the -mm tree.  Its filename is
     mglru-vs-maple-tree-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mglru-vs-maple-tree-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mglru-vs-maple-tree-fix.patch

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
Subject: mm/vmscan: Use VMA_ITERATOR in get_next_vma()

The next vma may actually be many VMAs away, so use the VMA_ITERATOR to
continue searching from vm_end onwards.

Link: https://lkml.kernel.org/r/20220419174757.2tptlbkebiletmck@revolver
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mglru-vs-maple-tree-fix
+++ a/mm/vmscan.c
@@ -3697,24 +3697,21 @@ static bool get_next_vma(struct mm_walk
 			 unsigned long *start, unsigned long *end)
 {
 	unsigned long next = round_up(*end, size);
+	VMA_ITERATOR(vmi, walk->mm, walk->vma->vm_end)
 
 	VM_BUG_ON(mask & size);
 	VM_BUG_ON(*start >= *end);
 	VM_BUG_ON((next & mask) != (*start & mask));
 
-	while (walk->vma) {
-		if (next >= walk->vma->vm_end) {
-			walk->vma = find_vma(walk->mm, walk->vma->vm_end);
+	for_each_mte_vma(vmi, walk->vma) {
+		if (next >= walk->vma->vm_end)
 			continue;
-		}
 
 		if ((next & mask) != (walk->vma->vm_start & mask))
 			return false;
 
-		if (should_skip_vma(walk->vma->vm_start, walk->vma->vm_end, walk)) {
-			walk->vma = find_vma(walk->mm, walk->vma->vm_end);
+		if (should_skip_vma(walk->vma->vm_start, walk->vma->vm_end, walk))
 			continue;
-		}
 
 		*start = max(next, walk->vma->vm_start);
 		next = (next | ~mask) + 1;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

radix-tree-test-suite-add-lockdep_is_held-to-header.patch
mips-rename-mt_init-to-mips_mt_init.patch
lib-test_maple_tree-add-testing-for-maple-tree.patch
mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch
riscv-use-vma-iterator-for-vdso.patch
mm-mmapc-pass-in-mapping-to-__vma_link_file.patch
mglru-vs-maple-tree-fix.patch

