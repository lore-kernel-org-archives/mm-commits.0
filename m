Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6EB8C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 12 Mar 2022 20:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiCLUkD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Mar 2022 15:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiCLUkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Mar 2022 15:40:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318EB37A1F
        for <mm-commits@vger.kernel.org>; Sat, 12 Mar 2022 12:38:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD239611A4
        for <mm-commits@vger.kernel.org>; Sat, 12 Mar 2022 20:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6EAC340EB;
        Sat, 12 Mar 2022 20:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647117535;
        bh=z+Y/zVNMubLZGaAxxwdj220Mxb5QFg8VAPDHpis0tTs=;
        h=Date:To:From:Subject:From;
        b=UAZG3c8g8Ai0iICTo4v2BPJCzDAO1DKaOamrKlTsM5aaDYwAgXIR84Zpk0Jv+6maz
         aLkoSEXPaYIRiwVVUJZUeghIL623tvKq0RtbKVKlywuxbNNj3NgfFoG3JeF9i+hIi8
         J5+iI3PfKkQ2JOgqOZBiFLo6KBdhuR7IQRKWsKGU=
Date:   Sat, 12 Mar 2022 12:38:54 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, bp@alien8.de, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failurec-fix-race-with-changing-page-compound-again.patch added to -mm tree
Message-Id: <20220312203854.EC6EAC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: fix race with changing page compound again
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-fix-race-with-changing-page-compound-again.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-fix-race-with-changing-page-compound-again.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-fix-race-with-changing-page-compound-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: fix race with changing page compound again

Patch series "A few fixup patches for memory failure", v2.

This series contains a few patches to fix the race with changing page
compound page, make non-LRU movable pages unhandlable and so on.  More
details can be found in the respective changelogs.


There is a race window where we got the compound_head, the hugetlb page
could be freed to buddy, or even changed to another compound page just
before we try to get hwpoison page.  Think about the below race window:

  CPU 1					  CPU 2
  memory_failure_hugetlb
  struct page *head = compound_head(p);
					  hugetlb page might be freed to
					  buddy, or even changed to another
					  compound page.

  get_hwpoison_page -- page is not what we want now...

If this race happens, just bail out.  Also MF_MSG_DIFFERENT_PAGE_SIZE is
introduced to record this event.

Link: https://lkml.kernel.org/r/20220312074613.4798-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220312074613.4798-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    1 +
 include/ras/ras_event.h |    1 +
 mm/memory-failure.c     |   12 ++++++++++++
 3 files changed, 14 insertions(+)

--- a/include/linux/mm.h~mm-memory-failurec-fix-race-with-changing-page-compound-again
+++ a/include/linux/mm.h
@@ -3239,6 +3239,7 @@ enum mf_action_page_type {
 	MF_MSG_BUDDY,
 	MF_MSG_DAX,
 	MF_MSG_UNSPLIT_THP,
+	MF_MSG_DIFFERENT_PAGE_SIZE,
 	MF_MSG_UNKNOWN,
 };
 
--- a/include/ras/ras_event.h~mm-memory-failurec-fix-race-with-changing-page-compound-again
+++ a/include/ras/ras_event.h
@@ -374,6 +374,7 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_BUDDY, "free buddy page" )				\
 	EM ( MF_MSG_DAX, "dax page" )					\
 	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
+	EM ( MF_MSG_DIFFERENT_PAGE_SIZE, "different page size" )	\
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
 
 /*
--- a/mm/memory-failure.c~mm-memory-failurec-fix-race-with-changing-page-compound-again
+++ a/mm/memory-failure.c
@@ -732,6 +732,7 @@ static const char * const action_page_ty
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
+	[MF_MSG_DIFFERENT_PAGE_SIZE]	= "different page size",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1532,6 +1533,17 @@ static int memory_failure_hugetlb(unsign
 	}
 
 	lock_page(head);
+
+	/**
+	 * The page could have changed compound pages due to race window.
+	 * If this happens just bail out.
+	 */
+	if (!PageHuge(p) || compound_head(p) != head) {
+		action_result(pfn, MF_MSG_DIFFERENT_PAGE_SIZE, MF_IGNORED);
+		res = -EBUSY;
+		goto out;
+	}
+
 	page_flags = head->flags;
 
 	if (hwpoison_filter(p)) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-writeback-minor-clean-up-for-highmem_dirtyable_memory.patch
mm-use-helper-function-range_in_vma.patch
mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch
mm-mmap-remove-obsolete-comment-in-ksys_mmap_pgoff.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch
mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch
mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch
mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch
mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch
mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch
mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch
mm-memory-failurec-remove-unnecessary-pagetranstail-check.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch
mm-memory-failurec-fix-race-with-changing-page-compound-again.patch
mm-memory-failurec-avoid-calling-invalidate_inode_page-with-unexpected-pages.patch
mm-memory-failurec-make-non-lru-movable-pages-unhandlable.patch
mm-mlock-fix-potential-imbalanced-rlimit-ucounts-adjustment.patch
mm-hugetlb-use-helper-macro-__attr_rw.patch
mm-remove-unneeded-local-variable-follflags-v2.patch
mm-mempolicy-fix-potential-mpol_new-leak-in-shared_policy_replace.patch
mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch
mm-ksm-use-helper-macro-__attr_rw.patch
mm-madvise-use-vma_lookup-instead-of-find_vma.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch
kernel-ksysfsc-use-helper-macro-__attr_rw.patch
kernel-resource-fix-kfree-of-bootmem-memory-again.patch
mm-huge_memory-make-is_transparent_hugepage-static.patch

