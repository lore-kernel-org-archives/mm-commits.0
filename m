Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B9BC05027
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjAUBGK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjAUBGI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:06:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962CC3B671
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:06:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8B5E3CE2A76
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7017C4339B;
        Sat, 21 Jan 2023 01:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263163;
        bh=SJa75yziWUZnWW45XsAeOO2QhD4aSZ9HDsSAYtm9nB8=;
        h=Date:To:From:Subject:From;
        b=z5WB44CtdAp5b9vsPm+mXDOTJIomRV740h5YonSHsg2JetE64Se/FwO/jAPkf3QUL
         OlnKx9GNtVxp9h0ffWPs2UI6PXlUtKRE+vef1DVNOqEw/l1wiSgHZtKA5OJwi9cTA5
         uMeYbA5yt+A3W8CYNj58w7QWMEktqkdBRHNoEgjs=
Date:   Fri, 20 Jan 2023 17:06:03 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-potential-rcu-issue.patch added to mm-unstable branch
Message-Id: <20230121010603.A7017C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix potential rcu issue
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-potential-rcu-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-potential-rcu-issue.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: fix potential rcu issue
Date: Fri, 20 Jan 2023 11:26:03 -0500

Ensure the node isn't dead after reading the node end.

Link: https://lkml.kernel.org/r/20230120162650.984577-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~maple_tree-fix-potential-rcu-issue
+++ a/lib/maple_tree.c
@@ -4654,13 +4654,13 @@ static inline void *mas_next_nentry(stru
 	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
 	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	count = ma_data_end(node, type, pivots, mas->max);
 	if (ma_dead_node(node))
 		return NULL;
 
 	if (mas->index > max)
 		return NULL;
 
-	count = ma_data_end(node, type, pivots, mas->max);
 	if (mas->offset > count)
 		return NULL;
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-add-mas_init-function.patch
maple_tree-fix-potential-rcu-issue.patch
maple_tree-reduce-user-error-potential.patch
test_maple_tree-test-modifications-while-iterating.patch
mm-expand-vma-iterator-interface.patch
mm-mmap-convert-brk-to-use-vma-iterator.patch
kernel-fork-convert-forking-to-using-the-vmi-iterator.patch
mmap-convert-vma_link-vma-iterator.patch
mm-mmap-remove-preallocation-from-do_mas_align_munmap.patch
mmap-change-do_mas_munmap-and-do_mas_aligned_munmap-to-use-vma-iterator.patch
mmap-convert-vma_expand-to-use-vma-iterator.patch
mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma.patch
ipc-shm-use-the-vma-iterator-for-munmap-calls.patch
userfaultfd-use-vma-iterator.patch
mm-change-mprotect_fixup-to-vma-iterator.patch
mlock-convert-mlock-to-vma-iterator.patch
coredump-convert-to-vma-iterator.patch
mempolicy-convert-to-vma-iterator.patch
task_mmu-convert-to-vma-iterator.patch
sched-convert-to-vma-iterator.patch
madvise-use-vmi-iterator-for-__split_vma-and-vma_merge.patch
mmap-pass-through-vmi-iterator-to-__split_vma.patch
mmap-use-vmi-version-of-vma_merge.patch
mm-mremap-use-vmi-version-of-vma_merge.patch
nommu-convert-nommu-to-using-the-vma-iterator.patch
mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator.patch
mmap-convert-__vma_adjust-to-use-vma-iterator.patch
mm-pass-through-vma-iterator-to-__vma_adjust.patch
madvise-use-split_vma-instead-of-__split_vma.patch
mm-remove-unnecessary-write-to-vma-iterator-in-__vma_adjust.patch
mm-pass-vma-iterator-through-to-__vma_adjust.patch
mm-add-vma-iterator-to-vma_adjust-arguments.patch
mmap-clean-up-mmap_region-unrolling.patch
mm-change-munmap-splitting-order-and-move_vma.patch
mm-mmap-move-anon_vma-setting-in-__vma_adjust.patch
mm-mmap-refactor-locking-out-of-__vma_adjust.patch
mm-mmap-use-vma_prepare-and-vma_complete-in-vma_expand.patch
mm-mmap-introduce-init_vma_prep-and-init_multi_vma_prep.patch
mm-dont-use-__vma_adjust-in-__split_vma.patch
mm-mmap-dont-use-__vma_adjust-in-shift_arg_pages.patch
mm-mmap-introduce-dup_vma_anon-helper.patch
mm-mmap-convert-do_brk_flags-to-use-vma_prepare-and-vma_complete.patch
mm-mmap-remove-__vma_adjust.patch
vma_merge-set-vma-iterator-to-correct-position.patch

