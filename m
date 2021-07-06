Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E3AC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EDF761C96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhGFTWN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231803AbhGFTWM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9888761C7F;
        Tue,  6 Jul 2021 19:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599174;
        bh=HR/gH4PPxcRUykuTxEk4kVAuhkjojYh/ljSIztEsrrA=;
        h=Date:From:To:Subject:From;
        b=FIARHX51ezdFNwtaGzg6Z6QmRpqLCPIyiFBDcyECQ5y3xeIAjIaJzQZwpVaELarDW
         ejng5O8acAMVgu8omLRKPd8LsTdaJ5Ii8O9Z/MeGvNlFE9hf+7Jb6b/swlNwdhatHN
         LG0Qw6EJhZxcR3nwWCFRqTnt20E5I9BwynBAn4YI=
Date:   Tue, 06 Jul 2021 12:19:33 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged]
 mm-memory-make-numa_migrate_prep-non-static.patch removed from -mm tree
Message-ID: <20210706191933._zlfZ4Ey2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: make numa_migrate_prep() non-static
has been removed from the -mm tree.  Its filename was
     mm-memory-make-numa_migrate_prep-non-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -672,4 +672,7 @@ int vmap_pages_range_noflush(unsigned lo
 
 void vunmap_range_noflush(unsigned long start, unsigned long end);
 
+int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
+		      unsigned long addr, int page_nid, int *flags);
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/memory.c~mm-memory-make-numa_migrate_prep-non-static
+++ a/mm/memory.c
@@ -4175,9 +4175,8 @@ static vm_fault_t do_fault(struct vm_fau
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


