Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78B8C001E0
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 16:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbjHJQbd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 12:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjHJQba (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 12:31:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7C5A8
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 09:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 888DF66308
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 16:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53BAC433C8;
        Thu, 10 Aug 2023 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691685089;
        bh=YyElAyZhxrAlci3ZP5kPbl51v7WyuU72aksKwW8zRq4=;
        h=Date:To:From:Subject:From;
        b=BVCLAYh7XXpHlKQnMWKW4TR4FsJODZA8n23IU6805C5sMqjbhjBIrrRomX/rtf8pH
         m/lQ5CEi+bIZ5rNd6zUCbmPhtPpKndh4HpLn2q6Vo8us4ekqAqbKWxdBf89IdGkUeF
         yfvJnQoWZIgfH5GKGmA1IFbIx/c5a1msFQeW1lYM=
Date:   Thu, 10 Aug 2023 09:31:28 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        mcgrof@kernel.org, kirill.shutemov@linux.intel.com,
        itaru.kitayama@gmail.com, fengwei.yin@intel.com, david@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch added to mm-unstable branch
Message-Id: <20230810163128.D53BAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: non-pmd-mappable, large folios for folio_add_new_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: non-pmd-mappable, large folios for folio_add_new_anon_rmap()
Date: Thu, 10 Aug 2023 15:29:39 +0100

In preparation for LARGE_ANON_FOLIO support, improve
folio_add_new_anon_rmap() to allow a non-pmd-mappable, large folio to be
passed to it.  In this case, all contained pages are accounted using the
order-0 folio (or base page) scheme.

Link: https://lkml.kernel.org/r/20230810142942.3169679-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/mm/rmap.c~mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap
+++ a/mm/rmap.c
@@ -1266,31 +1266,44 @@ void page_add_anon_rmap(struct page *pag
  * This means the inc-and-test can be bypassed.
  * The folio does not have to be locked.
  *
- * If the folio is large, it is accounted as a THP.  As the folio
+ * If the folio is pmd-mappable, it is accounted as a THP.  As the folio
  * is new, it's assumed to be mapped exclusively by a single process.
  */
 void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 		unsigned long address)
 {
-	int nr;
+	int nr = folio_nr_pages(folio);
 
-	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
+	VM_BUG_ON_VMA(address < vma->vm_start ||
+			address + (nr << PAGE_SHIFT) > vma->vm_end, vma);
 	__folio_set_swapbacked(folio);
 
-	if (likely(!folio_test_pmd_mappable(folio))) {
+	if (likely(!folio_test_large(folio))) {
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_mapcount, 0);
-		nr = 1;
+		__page_set_anon_rmap(folio, &folio->page, vma, address, 1);
+	} else if (!folio_test_pmd_mappable(folio)) {
+		int i;
+
+		for (i = 0; i < nr; i++) {
+			struct page *page = folio_page(folio, i);
+
+			/* increment count (starts at -1) */
+			atomic_set(&page->_mapcount, 0);
+			__page_set_anon_rmap(folio, page, vma,
+					address + (i << PAGE_SHIFT), 1);
+		}
+
+		atomic_set(&folio->_nr_pages_mapped, nr);
 	} else {
 		/* increment count (starts at -1) */
 		atomic_set(&folio->_entire_mapcount, 0);
 		atomic_set(&folio->_nr_pages_mapped, COMPOUND_MAPPED);
-		nr = folio_nr_pages(folio);
+		__page_set_anon_rmap(folio, &folio->page, vma, address, 1);
 		__lruvec_stat_mod_folio(folio, NR_ANON_THPS, nr);
 	}
 
 	__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
-	__page_set_anon_rmap(folio, &folio->page, vma, address, 1);
 }
 
 /**
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-line-buffer-test-programs-stdout.patch
selftests-line-buffer-test-programs-stdout-fix.patch
selftests-mm-skip-soft-dirty-tests-on-arm64.patch
selftests-mm-enable-mrelease_test-for-arm64.patch
selftests-mm-fix-thuge-gen-test-bugs.patch
selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch
selftests-mm-make-migration-test-robust-to-failure.patch
selftests-mm-optionally-pass-duration-to-transhuge-stress.patch
selftests-mm-run-all-tests-from-run_vmtestssh.patch
mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-large_anon_folio-for-improved-performance.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-large-anon-folio-tests.patch

