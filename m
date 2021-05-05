Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFD1C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CED1F613CB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhEEA7b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 20:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhEEA7b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 20:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DEA161078;
        Wed,  5 May 2021 00:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176315;
        bh=5wFPTN4WOW+YFLFEOCsUxGXW9ji+dUD2IWqvbzSY4fw=;
        h=Date:From:To:Subject:From;
        b=rtUPpK2sEVQ6L+OsgPR23EsQu5nqmtUw/T4Jz3GCxfuEdVbA12kKPkqM1/btzzozE
         Olb2f45l8LsW9gOrvW8NJAzBfM9r4MpvGlLK5YNuiV18zt8y7Y8oV8ZXkWeFk0ybDa
         mwCywGkitqkghBvsXCEhCJIku/xHpzBSFz9Lscjk=
Date:   Tue, 04 May 2021 17:58:34 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, rppt@linux.ibm.com
Subject:  [folded-merged]
 mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin-fix.patch removed from
 -mm tree
Message-ID: <20210505005834.ieZFh8-xm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugeltb: fix renaming of PF_MEMALLOC_NOCMA to PF_MEMALLOC_PIN
has been removed from the -mm tree.  Its filename was
     mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin-fix.patch

This patch was dropped because it was folded into mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/hugeltb: fix renaming of PF_MEMALLOC_NOCMA to PF_MEMALLOC_PIN

The renaming of PF_MEMALLOC_NOCMA to PF_MEMALLOC_PIN missed one occurrence
in mm/hugetlb.c which causes build error:

  CC      mm/hugetlb.o
mm/hugetlb.c: In function `dequeue_huge_page_node_exact':
mm/hugetlb.c:1081:33: error: `PF_MEMALLOC_NOCMA' undeclared (first use in this function); did you mean `PF_MEMALLOC_NOFS'?
  bool pin = !!(current->flags & PF_MEMALLOC_NOCMA);
                                 ^~~~~~~~~~~~~~~~~
                                 PF_MEMALLOC_NOFS
mm/hugetlb.c:1081:33: note: each undeclared identifier is reported only once for each function it appears in
scripts/Makefile.build:273: recipe for target 'mm/hugetlb.o' failed
make[2]: *** [mm/hugetlb.o] Error 1

Link: https://lkml.kernel.org/r/20210331163816.11517-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin-fix
+++ a/mm/hugetlb.c
@@ -1079,7 +1079,7 @@ static void enqueue_huge_page(struct hst
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
 {
 	struct page *page;
-	bool pin = !!(current->flags & PF_MEMALLOC_NOCMA);
+	bool pin = !!(current->flags & PF_MEMALLOC_PIN);
 
 	lockdep_assert_held(&hugetlb_lock);
 	list_for_each_entry(page, &h->hugepage_freelists[nid], lru) {
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-fix-existing-kernel-doc-comments-and-link-them-to-core-api.patch
mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

