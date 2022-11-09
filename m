Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81429C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiKIBig (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiKIBic (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B444657C9
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFDA8B81CD6
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBB7C433D7;
        Wed,  9 Nov 2022 01:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957896;
        bh=TzsuwGn0lZMqeMeiwFgEiFuYQgT/lnmGMl8I5HfX4I0=;
        h=Date:To:From:Subject:From;
        b=rT1PXBp1NoJ0oxSiSa56PHqESmV+4kWqwLfzKxFS3f5WaaQBoT5ggl2JhJWOg5eax
         WFhLE++91APpc7N4jtgtvyqw7hqklYbqLBTx+zApSw04Vxc2vmudQvkjRscQF4lp85
         28eDx2umIpShy8wdp2bgVMxc6EhvIBU7202TYEO0=
Date:   Tue, 08 Nov 2022 17:38:15 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        songmuchun@bytedance.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkp@intel.com, hughd@google.com,
        ebiederm@xmission.com, dhowells@redhat.com, ccross@google.com,
        arnd@arndb.de, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-add-folio_hstate.patch removed from -mm tree
Message-Id: <20221109013816.5EBB7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: add folio_hstate()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-folio_hstate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: add folio_hstate()
Date: Thu, 22 Sep 2022 10:42:07 -0500

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
@@ -1620,7 +1620,7 @@ struct page *alloc_migration_target(stru
 		nid = folio_nid(folio);
 
 	if (folio_test_hugetlb(folio)) {
-		struct hstate *h = page_hstate(&folio->page);
+		struct hstate *h = folio_hstate(folio);
 
 		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
 		return alloc_huge_page_nodemask(h, nid, mtc->nmask, gfp_mask);
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

