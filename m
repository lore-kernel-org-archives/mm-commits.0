Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A18C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EC4D6105A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbhGAByK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238427AbhGAByJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6011561241;
        Thu,  1 Jul 2021 01:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104299;
        bh=ncayqTaMm8i8J06ewDQI1J4TfCvG093pumynsfT/Ys8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zBASmNfCsjnXP1EjM/7Ua2tELl3i+tZYO/x9RC38PRtzG4mOPsTkF1FOxST/lvg0c
         6PJ8eIPsrzZjJmkhWYX5VnTFvoTMmwkso3692ZcHrHRczUNCMPbqIuiBZVuNcBswWv
         s7qoBElcZfPMWVJKhyuASk7bx/TeDxxoyEzKTrag=
Date:   Wed, 30 Jun 2021 18:51:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, borntraeger@de.ibm.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [patch 084/192] mm: memory: make numa_migrate_prep()
 non-static
Message-ID: <20210701015139.o4cDNVwiX%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
