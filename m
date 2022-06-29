Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7173C43334
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jun 2022 23:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiF2Xqo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Jun 2022 19:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiF2Xqn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jun 2022 19:46:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376541BE91
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 16:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D41CFB827AC
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 23:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C40C34114;
        Wed, 29 Jun 2022 23:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656546399;
        bh=tjgpz7108upklWHn5R1fMFXQBLFwhh/HghL+5O9LD3s=;
        h=Date:To:From:Subject:From;
        b=XOqXgV1F+5W+ophPEbrqJAS2CiF6uTw1UNke7yzUiDewF90HgM4VuVglTlzKyy7Dm
         mAUmLWU0DmPjAWkClfib2dIqjwKMkTxwZbYwW9O/qMuUNUyENE6lThq8QeV40WFHqa
         XPEFV0dpjCJw/4iriaz6CJR6RiBsN+aWfa/VbbE8=
Date:   Wed, 29 Jun 2022 16:46:38 -0700
To:     mm-commits@vger.kernel.org, mchehab@kernel.org,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-vma-linked-list-fix-2-fix.patch added to mm-unstable branch
Message-Id: <20220629234639.73C40C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-the-vma-linked-list-fix-2-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-vma-linked-list-fix-2-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-vma-linked-list-fix-2-fix.patch

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
Subject: mm-remove-the-vma-linked-list-fix-2-fix
Date: Wed Jun 29 04:45:49 PM PDT 2022

alter description, per Liam

Cc: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory.c~mm-remove-the-vma-linked-list-fix-2-fix
+++ a/mm/memory.c
@@ -1699,8 +1699,7 @@ static void unmap_single_vma(struct mmu_
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
  * @tlb: address of the caller's struct mmu_gather
- * @mt: maple tree pointer. A maple tree is a RCU-safe range based B-tree
- *	designed to use modern processor cache efficiently
+ * @mt: The maple tree pointer for the VMAs
  * @vma: the starting vma
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-remove-the-vma-linked-list-fix-2-fix.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch
mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch

