Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768EEC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 20:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJQUla (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 16:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiJQUkx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 16:40:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD8A816BA
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 13:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AE9BB81AD3
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CFFC433D6;
        Mon, 17 Oct 2022 20:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666039021;
        bh=nW8xKnf6ke50SU3Anhag+OG0r6UsxvUI3R9XdKowvrU=;
        h=Date:To:From:Subject:From;
        b=W4rgESUNYo1j9Y4s177oKttGdQ5ZAZu3qOAW/t6PRKuqcX622YMribmAUaokggMGo
         YHZHEv9VxajZpQjSOp1qrug55Htk/mrhQNrZkGlKjAMUZyGfjCiT7crT78qu+bdd0C
         iLI17BDGzbi10b4Mj9ZNpBpPGrqxHrWq/YCqeqeU=
Date:   Mon, 17 Oct 2022 13:37:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        songmuchun@bytedance.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkp@intel.com, hughd@google.com,
        ebiederm@xmission.com, dhowells@redhat.com, ccross@google.com,
        arnd@arndb.de, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-folio_hstate.patch added to mm-unstable branch
Message-Id: <20221017203701.54CFFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add folio_hstate()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-add-folio_hstate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-add-folio_hstate.patch

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
Subject: mm/hugetlb: add folio_hstate()
Date: Thu, 22 Sep 2022 10:42:07 -0500

Patch series "begin converting hugetlb code to folios", v4.

This patch series starts the conversion of the hugetlb code to operate on
struct folios rather than struct pages.  This removes the ambiguitiy of
whether functions are operating on head pages, tail pages of compound
pages, or base pages.  

This series passes the linux test project hugetlb test cases.

Patch 1 adds hugeltb specific page macros that can operate on folios.

Patch 2 adds the private field of the first tail page to struct page.  For
32-bit, _private_1 alinging with page[1].private was confirmed by using
pahole.

Patch 3 introduces hugetlb subpool helper functions which operate on
struct folios. These patches were tested using the hugepage-mmap.c
selftest along with the migratepages command.

Patch 4 converts hugetlb_delete_from_page_cache() to use folios.

Patch 5 adds a folio_hstate() function to get hstate information from a
folio and adds a user of folio_hstate().

Bpftrace was used to track time spent in the free_huge_pages function
during the ltp test cases as it is a caller of the hugetlb subpool
functions. From the histogram, the performance is similar before and
after the patch series. 

Time spent in 'free_huge_page'

6.0.0-rc2.master.20220823
@nsecs:
[256, 512)         14770 |@@@@@@@@@@@@@@@@@@@@@@@@@@@
			 |@@@@@@@@@@@@@@@@@@@@@@@@@			      |
[512, 1K)            155 |                                                    |
[1K, 2K)             169 |                                                    |
[2K, 4K)              50 |                                                    |
[4K, 8K)              14 |                                                    |
[8K, 16K)              3 |                                                    |
[16K, 32K)             3 |                                                    |


6.0.0-rc2.master.20220823 + patch series
@nsecs:
[256, 512)         13678 |@@@@@@@@@@@@@@@@@@@@@@@@@@@			      |
			 |@@@@@@@@@@@@@@@@@@@@@@@@@			      |
[512, 1K)            142 |                                                    |
[1K, 2K)             199 |                                                    |
[2K, 4K)              44 |                                                    |
[4K, 8K)              13 |                                                    |
[8K, 16K)              4 |                                                    |
[16K, 32K)             1 |                                                    |


This patch (of 5):

Helper function to retrieve hstate information from a hugetlb folio.

Link: https://lkml.kernel.org/r/20220922154207.1575343-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Cross <ccross@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   14 ++++++++++++--
 mm/migrate.c            |    2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-add-folio_hstate
+++ a/include/linux/hugetlb.h
@@ -824,10 +824,15 @@ static inline pte_t arch_make_huge_pte(p
 }
 #endif
 
+static inline struct hstate *folio_hstate(struct folio *folio)
+{
+	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
+	return size_to_hstate(folio_size(folio));
+}
+
 static inline struct hstate *page_hstate(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
-	return size_to_hstate(page_size(page));
+	return folio_hstate(page_folio(page));
 }
 
 static inline unsigned hstate_index_to_shift(unsigned index)
@@ -1035,6 +1040,11 @@ static inline struct hstate *hstate_vma(
 {
 	return NULL;
 }
+
+static inline struct hstate *folio_hstate(struct folio *folio)
+{
+	return NULL;
+}
 
 static inline struct hstate *page_hstate(struct page *page)
 {
--- a/mm/migrate.c~mm-hugetlb-add-folio_hstate
+++ a/mm/migrate.c
@@ -1613,7 +1613,7 @@ struct page *alloc_migration_target(stru
 		nid = folio_nid(folio);
 
 	if (folio_test_hugetlb(folio)) {
-		struct hstate *h = page_hstate(&folio->page);
+		struct hstate *h = folio_hstate(folio);
 
 		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
 		return alloc_huge_page_nodemask(h, nid, mtc->nmask, gfp_mask);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-add-folio-support-to-hugetlb-specific-flag-macros.patch
mm-add-private-field-of-first-tail-to-struct-page-and-struct-folio.patch
mm-hugetlb-add-hugetlb_folio_subpool-helpers.patch
hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios.patch
mm-hugetlb-add-folio_hstate.patch
mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

