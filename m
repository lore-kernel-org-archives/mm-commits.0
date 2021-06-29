Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0D8C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99D661CF6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhF2AXC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhF2AXB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:23:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17D5961CF4;
        Tue, 29 Jun 2021 00:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926034;
        bh=Igwio66jyLhXqR/hnvyx/iNmFhhnaDS30Dif+2dicws=;
        h=Date:From:To:Subject:From;
        b=nvRZcrWL7lWNMQDouXB4ukTdyBvRECtt7X7FIALWhvW787Rzn+zgj1gvv+O068uN3
         s20VFzOHf1Xqo+amNAJJgReJTbBuH/GjU7YBFJEll/vDAsdzMc+y9TuADcECiIL94f
         YHN+GRp6Hut/jvbgSog/VkW2Lqw6vGlBQE3nh1mE=
Date:   Mon, 28 Jun 2021 17:20:33 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  [folded-merged]
 mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch removed
 from -mm tree
Message-ID: <20210629002033.bOsVFa176%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-gup-pack-has_pinned-in-mmf_has_pinned.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#25: 
[peterx@redhat.com: fix build for task_mmu.c, introduce mm_set_has_pinned_flag, fix comments]

WARNING: please, no spaces at the start of a line
#130: FILE: mm/gup.c:1280:
+       if (!test_bit(MMF_HAS_PINNED, mm_flags))$

WARNING: suspect code indent for conditional statements (7, 15)
#130: FILE: mm/gup.c:1280:
+       if (!test_bit(MMF_HAS_PINNED, mm_flags))
+               set_bit(MMF_HAS_PINNED, mm_flags);

ERROR: code indent should use tabs where possible
#131: FILE: mm/gup.c:1281:
+               set_bit(MMF_HAS_PINNED, mm_flags);$

WARNING: please, no spaces at the start of a line
#131: FILE: mm/gup.c:1281:
+               set_bit(MMF_HAS_PINNED, mm_flags);$

total: 1 errors, 4 warnings, 90 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-gup-pack-has_pinned-in-mmf_has_pinned.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes
+++ a/mm/gup.c
@@ -1305,8 +1305,8 @@ EXPORT_SYMBOL_GPL(fixup_user_fault);
  */
 static inline void mm_set_has_pinned_flag(unsigned long *mm_flags)
 {
-       if (!test_bit(MMF_HAS_PINNED, mm_flags))
-               set_bit(MMF_HAS_PINNED, mm_flags);
+	if (!test_bit(MMF_HAS_PINNED, mm_flags))
+		set_bit(MMF_HAS_PINNED, mm_flags);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-pack-has_pinned-in-mmf_has_pinned.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

