Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296A8C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 20:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbiJQUlv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 16:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiJQUl3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 16:41:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA17977EA9
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 13:38:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0279B81AD8
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D54AC433D6;
        Mon, 17 Oct 2022 20:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666039034;
        bh=0tnU8jz7V1sTws6vjzoANNeTKlHKsNu/BLSsEHBaRto=;
        h=Date:To:From:Subject:From;
        b=p37DFjofkmr6NwnCzflNGzrDyg4oOxbiWswp7m2Ud81RDy7aAUC/cwRuqPfguwLIG
         bh9kJkdr1kvOv9jyr9qT4HsgeJndnbZ2ugESr0USHyozWqODzl4BbmPCY8Adwu4qVG
         0sH2BPdK5NK/jOIxQ7X0bH6M7whGyvRD+5ZEKJm4=
Date:   Mon, 17 Oct 2022 13:37:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        songmuchun@bytedance.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkp@intel.com, hughd@google.com,
        ebiederm@xmission.com, dhowells@redhat.com, ccross@google.com,
        arnd@arndb.de, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch added to mm-unstable branch
Message-Id: <20221017203714.6D54AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert isolate_or_dissolve_huge_page to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch

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
Subject: mm/hugetlb: convert isolate_or_dissolve_huge_page to folios
Date: Thu, 13 Oct 2022 20:12:59 -0700

Remove a call to compound_head() by using a folio when operating on the
head page of a hugetlb compound page.

Link: https://lkml.kernel.org/r/20221014031303.231740-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Cross <ccross@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -2822,7 +2822,7 @@ free_new:
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
 {
 	struct hstate *h;
-	struct page *head;
+	struct folio *folio = page_folio(page);
 	int ret = -EBUSY;
 
 	/*
@@ -2831,9 +2831,8 @@ int isolate_or_dissolve_huge_page(struct
 	 * Return success when racing as if we dissolved the page ourselves.
 	 */
 	spin_lock_irq(&hugetlb_lock);
-	if (PageHuge(page)) {
-		head = compound_head(page);
-		h = page_hstate(head);
+	if (folio_test_hugetlb(folio)) {
+		h = folio_hstate(folio);
 	} else {
 		spin_unlock_irq(&hugetlb_lock);
 		return 0;
@@ -2848,10 +2847,10 @@ int isolate_or_dissolve_huge_page(struct
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (page_count(head) && !isolate_hugetlb(head, list))
+	if (folio_ref_count(folio) && !isolate_hugetlb(&folio->page, list))
 		ret = 0;
-	else if (!page_count(head))
-		ret = alloc_and_dissolve_huge_page(h, head, list);
+	else if (!folio_ref_count(folio))
+		ret = alloc_and_dissolve_huge_page(h, &folio->page, list);
 
 	return ret;
 }
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

