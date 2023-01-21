Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD04FC38141
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjAUBGH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjAUBGH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:06:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1392E3EFC1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:06:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78AA5B82AA3
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB01EC433EF;
        Sat, 21 Jan 2023 01:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263162;
        bh=yG32Cccyn8+e39WkiV6Lh6Z3P2iTr94zGd/7LoiGMss=;
        h=Date:To:From:Subject:From;
        b=O7WhpR7jv8zzUAkBZcX9Ukjm1/v+lJeKBYj+gNwJtzAF0LTd7PmnsG5Y5OfgQ8x1J
         jX4QammmLY8r2uzj4BZHEdzM7lvDVjfqJ+RRw7QIEdZsN0D08RWpVV81ij0a4R17E/
         M4Y5iW1BKYZEgcQuigVXLrt2itebl0lVno5sTnrM=
Date:   Fri, 20 Jan 2023 17:06:01 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-mas_init-function.patch added to mm-unstable branch
Message-Id: <20230121010601.EB01EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: add mas_init() function
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-add-mas_init-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-mas_init-function.patch

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
Subject: maple_tree: add mas_init() function
Date: Fri, 20 Jan 2023 11:26:02 -0500

Patch series "VMA tree type safety and remove __vma_adjust()", v4.

This patchset does two things: 1.  Clean up, including removal of
__vma_adjust() and 2.  Extends the VMA iterator API to provide type safety
to the VMA operations using the maple tree, as requested by Linus [1].

It also addresses another issue of usability brought up by Linus about
needing to modify the maple state within the loops.  The maple state has
been replaced by the VMA iterator and the iterator is now modified within
the MM code so the caller should not need to worry about doing the work
themselves when tree modifications occur.

This brought up a potential inconsistency of the iterator state and what
the user expects, so the inconsistency is addressed to keep the VMA
iterator safe for use after the looping over a VMA range.  This is
addressed in patch 3 ("maple_tree: Reduce user error potential") and 4
("test_maple_tree: Test modifications while iterating").

While cleaning up the state, the duplicate locking code in mm/mmap.c
introduced by the maple tree has been address by abstracting it to two
functions: vma_prepare() and vma_complete().  These abstractions allowed
for a much simpler __vma_adjust(), which eventually leads to the removal
of the __vma_adjust() function by placing the logic into the vma_merge()
function itself.

1. https://lore.kernel.org/linux-mm/CAHk-=wg9WQXBGkNdKD2bqocnN73rDswuWsavBB7T-tekykEn_A@mail.gmail.com/


This patch (of 49):

Add a function that will zero out the maple state struct and set some
basic defaults.

Link: https://lkml.kernel.org/r/20230120162650.984577-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230120162650.984577-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/maple_tree.h~maple_tree-add-mas_init-function
+++ a/include/linux/maple_tree.h
@@ -432,6 +432,7 @@ struct ma_wr_state {
 		.min = 0,						\
 		.max = ULONG_MAX,					\
 		.alloc = NULL,						\
+		.mas_flags = 0,						\
 	}
 
 #define MA_WR_STATE(name, ma_state, wr_entry)				\
@@ -470,6 +471,16 @@ void *mas_next(struct ma_state *mas, uns
 int mas_empty_area(struct ma_state *mas, unsigned long min, unsigned long max,
 		   unsigned long size);
 
+static inline void mas_init(struct ma_state *mas, struct maple_tree *tree,
+			    unsigned long addr)
+{
+	memset(mas, 0, sizeof(struct ma_state));
+	mas->tree = tree;
+	mas->index = mas->last = addr;
+	mas->max = ULONG_MAX;
+	mas->node = MAS_START;
+}
+
 /* Checks if a mas has not found anything */
 static inline bool mas_is_none(struct ma_state *mas)
 {
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

