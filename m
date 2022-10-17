Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76719C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 20:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiJQUmD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 16:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiJQUln (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 16:41:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96042EAF
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 13:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18242B81AE4
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41A6C433C1;
        Mon, 17 Oct 2022 20:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666039045;
        bh=11rvoCgGGQizpMKIaVKOeLcPRQb4bXAMNtgj8RBxeqA=;
        h=Date:To:From:Subject:From;
        b=MOwhPVkFtSTCZeglDOCT3fftbqXEEC785q82p5oenulkn5Czx+17JryBp+vd+Z6AE
         KFvs2JXCdy65SH7vyZNqCmnJdiv1sl7Aq8PTh7CjvM9sRSFcYrUYDbHsTA/NDdTLC8
         6igeon4E8BHB6ty4/ukHR386gZ7GvkuDPhu7vHiY=
Date:   Mon, 17 Oct 2022 13:37:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        songmuchun@bytedance.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkp@intel.com, hughd@google.com,
        ebiederm@xmission.com, dhowells@redhat.com, ccross@google.com,
        arnd@arndb.de, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-move_hugetlb_state-to-folios.patch added to mm-unstable branch
Message-Id: <20221017203725.C41A6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert move_hugetlb_state() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

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
Subject: mm/hugetlb: convert move_hugetlb_state() to folios
Date: Thu, 13 Oct 2022 20:13:03 -0700

Clean up unmap_and_move_huge_page() by converting move_hugetlb_state() to
take in folios.

Link: https://lkml.kernel.org/r/20221014031303.231740-10-sidhartha.kumar@oracle.com
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

 include/linux/hugetlb.h |    6 +++---
 mm/hugetlb.c            |   22 ++++++++++++----------
 mm/migrate.c            |    2 +-
 3 files changed, 16 insertions(+), 14 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-convert-move_hugetlb_state-to-folios
+++ a/include/linux/hugetlb.h
@@ -186,7 +186,7 @@ int isolate_hugetlb(struct page *page, s
 int get_hwpoison_huge_page(struct page *page, bool *hugetlb);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags);
 void putback_active_hugepage(struct page *page);
-void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
+void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
@@ -405,8 +405,8 @@ static inline void putback_active_hugepa
 {
 }
 
-static inline void move_hugetlb_state(struct page *oldpage,
-					struct page *newpage, int reason)
+static inline void move_hugetlb_state(struct folio *old_folio,
+					struct folio *new_folio, int reason)
 {
 }
 
--- a/mm/hugetlb.c~mm-hugetlb-convert-move_hugetlb_state-to-folios
+++ a/mm/hugetlb.c
@@ -7313,15 +7313,15 @@ void putback_active_hugepage(struct page
 	put_page(page);
 }
 
-void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason)
+void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason)
 {
-	struct hstate *h = page_hstate(oldpage);
+	struct hstate *h = folio_hstate(old_folio);
 
-	hugetlb_cgroup_migrate(page_folio(oldpage), page_folio(newpage));
-	set_page_owner_migrate_reason(newpage, reason);
+	hugetlb_cgroup_migrate(old_folio, new_folio);
+	set_page_owner_migrate_reason(&new_folio->page, reason);
 
 	/*
-	 * transfer temporary state of the new huge page. This is
+	 * transfer temporary state of the new hugetlb folio. This is
 	 * reverse to other transitions because the newpage is going to
 	 * be final while the old one will be freed so it takes over
 	 * the temporary status.
@@ -7330,12 +7330,14 @@ void move_hugetlb_state(struct page *old
 	 * here as well otherwise the global surplus count will not match
 	 * the per-node's.
 	 */
-	if (HPageTemporary(newpage)) {
-		int old_nid = page_to_nid(oldpage);
-		int new_nid = page_to_nid(newpage);
+	if (folio_test_hugetlb_temporary(new_folio)) {
+		int old_nid = folio_nid(old_folio);
+		int new_nid = folio_nid(new_folio);
+
+
+		folio_set_hugetlb_temporary(old_folio);
+		folio_clear_hugetlb_temporary(new_folio);
 
-		SetHPageTemporary(oldpage);
-		ClearHPageTemporary(newpage);
 
 		/*
 		 * There is no need to transfer the per-node surplus state
--- a/mm/migrate.c~mm-hugetlb-convert-move_hugetlb_state-to-folios
+++ a/mm/migrate.c
@@ -1348,7 +1348,7 @@ put_anon:
 		put_anon_vma(anon_vma);
 
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		move_hugetlb_state(hpage, new_hpage, reason);
+		move_hugetlb_state(src, dst, reason);
 		put_new_page = NULL;
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

