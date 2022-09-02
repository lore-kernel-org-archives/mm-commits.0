Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECE0C6FA82
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 19:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiIBTbN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 15:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiIBTbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 15:31:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85BAFCA0E
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 12:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67C6460DF4
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 19:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7E8C433C1;
        Fri,  2 Sep 2022 19:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662147070;
        bh=VQhL99hKOZIwIIB9Y5NjXVM//jhSYBlSIuL9o1wMrIY=;
        h=Date:To:From:Subject:From;
        b=Kqw0qFDs1hc/1kf8esWUCRUvPcwvi3Jimp1QsolMbJQKEfgQm34tT9CSjrPMKaJML
         N7rlZcJkUsUkiCtOOvbrr14swWi7ISky7sxKSvulPwfQtCPPdWvXf/0MgeqkJgAzvD
         ugjU9LTQ8y6xxYebEE65aeewP6p8w73zw+wnh4bU=
Date:   Fri, 02 Sep 2022 12:31:09 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-check-folio_test_private-not-folio_get_private.patch added to mm-hotfixes-unstable branch
Message-Id: <20220902193110.BA7E8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: check folio_test_private(), not folio_get_private()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     vmscan-check-folio_test_private-not-folio_get_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmscan-check-folio_test_private-not-folio_get_private.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmscan: check folio_test_private(), not folio_get_private()
Date: Fri, 2 Sep 2022 20:26:39 +0100

These two predicates are the same for file pages, but are not the same for
anonymous pages.

Link: https://lkml.kernel.org/r/20220902192639.1737108-3-willy@infradead.org
Fixes: 07f67a8dedc0 ("mm/vmscan: convert shrink_active_list() to use a folio")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~vmscan-check-folio_test_private-not-folio_get_private
+++ a/mm/vmscan.c
@@ -2550,8 +2550,8 @@ static void shrink_active_list(unsigned
 		}
 
 		if (unlikely(buffer_heads_over_limit)) {
-			if (folio_get_private(folio) && folio_trylock(folio)) {
-				if (folio_get_private(folio))
+			if (folio_test_private(folio) && folio_trylock(folio)) {
+				if (folio_test_private(folio))
 					filemap_release_folio(folio, 0);
 				folio_unlock(folio);
 			}
_

Patches currently in -mm which might be from willy@infradead.org are

tools-fix-compilation-after-gfp_typesh-split.patch
mm-fix-vm_bug_on-in-__delete_from_swap_cache.patch
vmscan-check-folio_test_private-not-folio_get_private.patch
support-highmem-pages-in-vmap_pages_range_noflush.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

