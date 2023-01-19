Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADDAC46467
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 04:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjATE2a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 23:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjATE2Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 23:28:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E2946B5
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 20:28:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4374B82758
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779C0C433D2;
        Thu, 19 Jan 2023 22:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674167545;
        bh=Q73C6Wv0aOUk9sksmT25Lxmadv6sHzOFlIi/L5Xu+Dw=;
        h=Date:To:From:Subject:From;
        b=GabfddosrhiqpYNbumBCEWZwiPVouJDaL5pKHaSGcMT/EjgzWyLFCf543RlxbGWn1
         iJRiSL4QkhEncNcCr4WNMwmbPbvd0yvGjawl8TUPZM/MJwssX5ipZonjNfGDomoX5q
         tU4kBFFHCoz03HL4u+zFQ68Nn67DHubPYTRpjlGc=
Date:   Thu, 19 Jan 2023 14:32:24 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-hugetlb_install_page-to-folios.patch added to mm-unstable branch
Message-Id: <20230119223225.779C0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert hugetlb_install_page to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-hugetlb_install_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-hugetlb_install_page-to-folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert hugetlb_install_page to folios
Date: Thu, 19 Jan 2023 13:14:38 -0800

Patch series "convert hugetlb fault functions to folios".

This series converts the hugetlb page faulting functions to operate on
folios.  These include hugetlb_no_page(), hugetlb_wp(),
copy_hugetlb_page_range(), and hugetlb_mcopy_atomic_pte().


This patch (of 9):

Change hugetlb_install_page() to hugetlb_install_folio().  This reduces
one user of the Huge Page flag macros which take in a page.

Link: https://lkml.kernel.org/r/20230119211446.54165-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20230119211446.54165-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlb_install_page-to-folios
+++ a/mm/hugetlb.c
@@ -4946,14 +4946,14 @@ static bool is_hugetlb_entry_hwpoisoned(
 }
 
 static void
-hugetlb_install_page(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
-		     struct page *new_page)
+hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
+		     struct folio *new_folio)
 {
-	__SetPageUptodate(new_page);
-	hugepage_add_new_anon_rmap(new_page, vma, addr);
-	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, new_page, 1));
+	__folio_mark_uptodate(new_folio);
+	hugepage_add_new_anon_rmap(&new_folio->page, vma, addr);
+	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, &new_folio->page, 1));
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
-	SetHPageMigratable(new_page);
+	folio_set_hugetlb_migratable(new_folio);
 }
 
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
@@ -5107,7 +5107,7 @@ again:
 					/* huge_ptep of dst_pte won't change as in child */
 					goto again;
 				}
-				hugetlb_install_page(dst_vma, dst_pte, addr, new);
+				hugetlb_install_folio(dst_vma, dst_pte, addr, page_folio(new));
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				continue;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch
mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch
mm-hugetlb-convert-hugetlb_install_page-to-folios.patch
mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch
mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch
mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio.patch
mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

