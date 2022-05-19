Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13575C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 19:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbiESTYH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 15:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244555AbiESTYE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 15:24:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365355E779
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 12:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D181961BE9
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 19:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272B1C385AA;
        Thu, 19 May 2022 19:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652988237;
        bh=4lQKuCXTTHOmII/Frak5jXKE2CZb8S7ORgIpeKbwlI0=;
        h=Date:To:From:Subject:From;
        b=GK4yK9yo1RUYzeFcjJIDPA1Z/ieukUsqWcqto8MRE12JQDgtwc+PGR3bsMyUTu/V4
         8oy73sMO95ubrLT4ZdaMwZpKsLoFMmnMRvHgggSo+Gc7QPVVbuo6XU5v58IdmiQL3h
         pGlIObcX8bVWBERwDAFdwzNEUYRufyqJ5aSBn89s=
Date:   Thu, 19 May 2022 12:23:56 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-vma-linked-list-fix-fix.patch added to mm-unstable branch
Message-Id: <20220519192357.272B1C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-the-vma-linked-list-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-vma-linked-list-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-vma-linked-list-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-the-vma-linked-list-fix-fix
Date: Thu May 19 12:23:01 PM PDT 2022

make comment in exit_mmap() more accurate

Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-remove-the-vma-linked-list-fix-fix
+++ a/mm/mmap.c
@@ -3213,7 +3213,7 @@ void exit_mmap(struct mm_struct *mm)
 	flush_cache_mm(mm);
 	tlb_gather_mmu_fullmm(&tlb, mm);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
-	/* Use -1 here to ensure all VMAs in the mm are unmapped */
+	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, &mm->mm_mt, vma, 0, ULONG_MAX);
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch
mm-swap-add-helper-swap_offset_available-fix.patch
mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

