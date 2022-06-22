Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FA8C43334
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 00:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355370AbiFVAyt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 20:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355410AbiFVAyr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 20:54:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C6431206
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 17:54:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6581B81BE6
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 00:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869E8C3411C;
        Wed, 22 Jun 2022 00:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655859283;
        bh=MdZyS2S4Lr55zufLjJY7pWEjSmNXLITibrAnY2yb5YY=;
        h=Date:To:From:Subject:From;
        b=uIqCtUJ9eo3iUYqmhOjVIaYPzXUbFDtNroEic0q1zY9KZXIg6DJPAl+FLeukmFJNn
         zLH62fdgF99QpMT/Z5/a5dlKBe1HWBJC8Y1cb2L4o7zVxJO6OSF9n1Zbejshwqs/Fu
         euk2iPN+t7L2JOujTZX+VZzKd91SB/KG8vrk3Reg=
Date:   Tue, 21 Jun 2022 17:54:34 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-kill-transparent_hugepage_active-fix.patch added to mm-unstable branch
Message-Id: <20220622005441.869E8C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-kill-transparent_hugepage_active-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-kill-transparent_hugepage_active-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-kill-transparent_hugepage_active-fix.patch

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
Subject: mm-thp-kill-transparent_hugepage_active-fix
Date: Tue Jun 21 05:51:42 PM PDT 2022

check vma->vm_mm, per Zach

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/huge_memory.c~mm-thp-kill-transparent_hugepage_active-fix
+++ a/mm/huge_memory.c
@@ -73,6 +73,9 @@ bool hugepage_vma_check(struct vm_area_s
 			unsigned long vm_flags,
 			bool smaps)
 {
+	if (!vma->vm_mm)
+		return false;
+
 	if (!transhuge_vma_enabled(vma, vm_flags))
 		return false;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-page_alloc-replace-local_lock-with-normal-spinlock-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch
mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch

