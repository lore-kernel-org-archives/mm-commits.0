Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A270BC3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbjAFAfH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbjAFAfG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:35:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B98D51304
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:35:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97C0360DFA
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5CBC433EF;
        Fri,  6 Jan 2023 00:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672965304;
        bh=GdGQc+FJm9Y4mEFntbd/7o+r6b8/ItY9d5bqSiDiZ7A=;
        h=Date:To:From:Subject:From;
        b=dAhLRxon+4EJ03liZZr6B+7srbPbGhxhjx3Fv7JBQaSRIelaCzrizoI2gT9ltdX72
         Jq8+gmH5oVJTj+XALCUj+M/bOS6P3X2/QIlEoso7OHONXIqUIFVmQVXNqw7jus7IF8
         5hraz9BjDTQw8mQkGIzSLE0j6dKmDmH2dycsCE9Y=
Date:   Thu, 05 Jan 2023 16:35:03 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + test_maple_tree-test-modifications-while-iterating.patch added to mm-unstable branch
Message-Id: <20230106003503.ED5CBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: test_maple_tree: test modifications while iterating
has been added to the -mm mm-unstable branch.  Its filename is
     test_maple_tree-test-modifications-while-iterating.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_maple_tree-test-modifications-while-iterating.patch

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
Subject: test_maple_tree: test modifications while iterating
Date: Thu, 5 Jan 2023 19:15:53 +0000

Add a testcase to ensure the iterator detects bad states on modifications
and does what the user expects

Link: https://lkml.kernel.org/r/20230105191517.3099082-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   72 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

--- a/lib/test_maple_tree.c~test_maple_tree-test-modifications-while-iterating
+++ a/lib/test_maple_tree.c
@@ -1709,6 +1709,74 @@ static noinline void check_forking(struc
 	mtree_destroy(&newmt);
 }
 
+static noinline void check_iteration(struct maple_tree *mt)
+{
+	int i, nr_entries = 125;
+	void *val;
+	MA_STATE(mas, mt, 0, 0);
+
+	for (i = 0; i <= nr_entries; i++)
+		mtree_store_range(mt, i * 10, i * 10 + 9,
+				  xa_mk_value(i), GFP_KERNEL);
+
+	mt_set_non_kernel(99999);
+
+	i = 0;
+	mas_lock(&mas);
+	mas_for_each(&mas, val, 925) {
+		MT_BUG_ON(mt, mas.index != i * 10);
+		MT_BUG_ON(mt, mas.last != i * 10 + 9);
+		/* Overwrite end of entry 92 */
+		if (i == 92) {
+			mas.index = 925;
+			mas.last = 929;
+			mas_store(&mas, val);
+		}
+		i++;
+	}
+	/* Ensure mas_find() gets the next value */
+	val = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, val != xa_mk_value(i));
+
+	mas_set(&mas, 0);
+	i = 0;
+	mas_for_each(&mas, val, 785) {
+		MT_BUG_ON(mt, mas.index != i * 10);
+		MT_BUG_ON(mt, mas.last != i * 10 + 9);
+		/* Overwrite start of entry 78 */
+		if (i == 78) {
+			mas.index = 780;
+			mas.last = 785;
+			mas_store(&mas, val);
+		} else {
+			i++;
+		}
+	}
+	val = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, val != xa_mk_value(i));
+
+	mas_set(&mas, 0);
+	i = 0;
+	mas_for_each(&mas, val, 765) {
+		MT_BUG_ON(mt, mas.index != i * 10);
+		MT_BUG_ON(mt, mas.last != i * 10 + 9);
+		/* Overwrite end of entry 76 and advance to the end */
+		if (i == 76) {
+			mas.index = 760;
+			mas.last = 765;
+			mas_store(&mas, val);
+			mas_next(&mas, ULONG_MAX);
+		}
+		i++;
+	}
+	/* Make sure the next find returns the one after 765, 766-769 */
+	val = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, val != xa_mk_value(76));
+	mas_unlock(&mas);
+	mas_destroy(&mas);
+	mt_set_non_kernel(0);
+}
+
 static noinline void check_mas_store_gfp(struct maple_tree *mt)
 {
 
@@ -2575,6 +2643,10 @@ static int maple_tree_seed(void)
 #endif
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_iteration(&tree);
+	mtree_destroy(&tree);
+
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_forking(&tree);
 	mtree_destroy(&tree);
 
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

