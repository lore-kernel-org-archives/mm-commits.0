Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0274C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiKIBiV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiKIBiP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D35606AF
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4808BCE1D2A
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628B8C433C1;
        Wed,  9 Nov 2022 01:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957890;
        bh=9ThjezHcKpPJ2mFT4Lp/dRGyAt/VbCl2Hi670HntbXk=;
        h=Date:To:From:Subject:From;
        b=LRUd9oTIwpeV/vEZxA3vmC8SmAMpqAgBiES2BX2U4QCMycBAJ/s5V7zLsmc/lISRW
         ji9fxhpGTwCuI/zMgVLR9NHHA6QLnJtKG5MMCEBY07Pm/Hzr/o8AoWu7rIm/47Pwdv
         cex3H4xwzULwXq8fY9V94C4pDYAFNqWoZKYrjK0g=
Date:   Tue, 08 Nov 2022 17:38:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        songmuchun@bytedance.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkp@intel.com, hughd@google.com,
        ebiederm@xmission.com, dhowells@redhat.com, ccross@google.com,
        arnd@arndb.de, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-add-folio-support-to-hugetlb-specific-flag-macros.patch removed from -mm tree
Message-Id: <20221109013810.628B8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: add folio support to hugetlb specific flag macros
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-folio-support-to-hugetlb-specific-flag-macros.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: add folio support to hugetlb specific flag macros
Date: Thu, 22 Sep 2022 10:42:03 -0500

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

Allow the macros which test, set, and clear hugetlb specific page flags to
take a hugetlb folio as an input.  The macrros are generated as
folio_{test, set, clear}_hugetlb_{restore_reserve, migratable, temporary,
freed, vmemmap_optimized, raw_hwp_unreliable}.

Link: https://lkml.kernel.org/r/20220922154207.1575343-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20220922154207.1575343-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Cross <ccross@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/include/linux/hugetlb.h~mm-hugetlb-add-folio-support-to-hugetlb-specific-flag-macros
+++ a/include/linux/hugetlb.h
@@ -589,26 +589,50 @@ enum hugetlb_page_flags {
  */
 #ifdef CONFIG_HUGETLB_PAGE
 #define TESTHPAGEFLAG(uname, flname)				\
+static __always_inline						\
+bool folio_test_hugetlb_##flname(struct folio *folio)		\
+	{	void *private = &folio->private;		\
+		return test_bit(HPG_##flname, private);		\
+	}							\
 static inline int HPage##uname(struct page *page)		\
 	{ return test_bit(HPG_##flname, &(page->private)); }
 
 #define SETHPAGEFLAG(uname, flname)				\
+static __always_inline						\
+void folio_set_hugetlb_##flname(struct folio *folio)		\
+	{	void *private = &folio->private;		\
+		set_bit(HPG_##flname, private);			\
+	}							\
 static inline void SetHPage##uname(struct page *page)		\
 	{ set_bit(HPG_##flname, &(page->private)); }
 
 #define CLEARHPAGEFLAG(uname, flname)				\
+static __always_inline						\
+void folio_clear_hugetlb_##flname(struct folio *folio)		\
+	{	void *private = &folio->private;		\
+		clear_bit(HPG_##flname, private);		\
+	}							\
 static inline void ClearHPage##uname(struct page *page)		\
 	{ clear_bit(HPG_##flname, &(page->private)); }
 #else
 #define TESTHPAGEFLAG(uname, flname)				\
+static inline bool						\
+folio_test_hugetlb_##flname(struct folio *folio)		\
+	{ return 0; }						\
 static inline int HPage##uname(struct page *page)		\
 	{ return 0; }
 
 #define SETHPAGEFLAG(uname, flname)				\
+static inline void						\
+folio_set_hugetlb_##flname(struct folio *folio) 		\
+	{ }							\
 static inline void SetHPage##uname(struct page *page)		\
 	{ }
 
 #define CLEARHPAGEFLAG(uname, flname)				\
+static inline void						\
+folio_clear_hugetlb_##flname(struct folio *folio)		\
+	{ }							\
 static inline void ClearHPage##uname(struct page *page)		\
 	{ }
 #endif
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

