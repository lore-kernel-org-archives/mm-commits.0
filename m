Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4F5C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 21:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 573E561353
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 21:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352350AbhERVJa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 17:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240342AbhERVJ3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 17:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E96C261209;
        Tue, 18 May 2021 21:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621372091;
        bh=jZGCwNXf76oMRE6z0A21PzuwqHoJHfadEOZpPv0iILw=;
        h=Date:From:To:Subject:From;
        b=NtALuem+wvKeHffNDD+XBG0RPQkSYQQePFrBMnulXvJoDW4ocoExkg2ID+JucOwaV
         TYCrZOwGuGq2pqBY/0gbnrPXpQ682MnpKwYRE7q4f8PfXQ0UmPmnVtXiWbXGqduiiq
         +u43He6u5pZYZLZUyl6qrsCa6qY+rIcauNDRs/rI=
Date:   Tue, 18 May 2021 14:08:10 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  + mm-memory-make-numa_migrate_prep-non-static.patch added
 to -mm tree
Message-ID: <20210518210810.cdyVrF8DW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: make numa_migrate_prep() non-static
has been added to the -mm tree.  Its filename is
     mm-memory-make-numa_migrate_prep-non-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-make-numa_migrate_prep-non-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-make-numa_migrate_prep-non-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: memory: make numa_migrate_prep() non-static

The numa_migrate_prep() will be used by huge NUMA fault as well in the
following patch, make it non-static.

Link: https://lkml.kernel.org/r/20210518200801.7413-3-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 +++
 mm/memory.c   |    5 ++---
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/mm/internal.h~mm-memory-make-numa_migrate_prep-non-static
+++ a/mm/internal.h
@@ -647,4 +647,7 @@ int vmap_pages_range_noflush(unsigned lo
 
 void vunmap_range_noflush(unsigned long start, unsigned long end);
 
+int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
+		      unsigned long addr, int page_nid, int *flags);
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/memory.c~mm-memory-make-numa_migrate_prep-non-static
+++ a/mm/memory.c
@@ -4129,9 +4129,8 @@ static vm_fault_t do_fault(struct vm_fau
 	return ret;
 }
 
-static int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
-				unsigned long addr, int page_nid,
-				int *flags)
+int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
+		      unsigned long addr, int page_nid, int *flags)
 {
 	get_page(page);
 
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-thp-check-total_mapcount-instead-of-page_mapcount.patch
mm-memory-add-orig_pmd-to-struct-vm_fault.patch
mm-memory-make-numa_migrate_prep-non-static.patch
mm-thp-refactor-numa-fault-handling.patch
mm-migrate-account-thp-numa-migration-counters-correctly.patch
mm-migrate-dont-split-thp-for-misplaced-numa-page.patch
mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch
mm-thp-skip-make-pmd-prot_none-if-thp-migration-is-not-supported.patch

