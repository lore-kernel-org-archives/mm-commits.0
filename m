Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59139C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 20:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiJQUkp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 16:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiJQUkE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 16:40:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612187859F
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 13:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BF5D61269
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43BBC433D6;
        Mon, 17 Oct 2022 20:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666039031;
        bh=/Pm4/YAVPNABL994aHbas2v580QDhzJ+/DE4oqwvM5I=;
        h=Date:To:From:Subject:From;
        b=RYSzowA7k2GagkXK+CXQiJLpH5p2CrkT6YjoLSmwcODGj7PKlL4SubH0cde2XzLgO
         AHT5CloE2u5mkvmzaTIY+dfo4byKVufhVMTMGZkS0SjhCoLO9AN9r1wBExyfPt+rgz
         y6/ebhhtzXPb/8mm3yt0Ef68Mv+15wBC7pydOcSs=
Date:   Mon, 17 Oct 2022 13:37:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        songmuchun@bytedance.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkp@intel.com, hughd@google.com,
        ebiederm@xmission.com, dhowells@redhat.com, ccross@google.com,
        arnd@arndb.de, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch added to mm-unstable branch
Message-Id: <20221017203711.C43BBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb_cgroup: convert hugetlb_cgroup_migrate to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch

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
Subject: mm/hugetlb_cgroup: convert hugetlb_cgroup_migrate to folios
Date: Thu, 13 Oct 2022 20:12:58 -0700

Clean up intermediate page to folio conversion code in
hugetlb_cgroup_migrate() by changing its arguments from pages to folios.

Link: https://lkml.kernel.org/r/20221014031303.231740-5-sidhartha.kumar@oracle.com
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

 include/linux/hugetlb_cgroup.h |    8 ++++----
 mm/hugetlb.c                   |    2 +-
 mm/hugetlb_cgroup.c            |    8 +++-----
 3 files changed, 8 insertions(+), 10 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios
+++ a/include/linux/hugetlb_cgroup.h
@@ -177,8 +177,8 @@ extern void hugetlb_cgroup_uncharge_file
 						bool region_del);
 
 extern void hugetlb_cgroup_file_init(void) __init;
-extern void hugetlb_cgroup_migrate(struct page *oldhpage,
-				   struct page *newhpage);
+extern void hugetlb_cgroup_migrate(struct folio *old_folio,
+				   struct folio *new_folio);
 
 #else
 static inline void hugetlb_cgroup_uncharge_file_region(struct resv_map *resv,
@@ -286,8 +286,8 @@ static inline void hugetlb_cgroup_file_i
 {
 }
 
-static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
-					  struct page *newhpage)
+static inline void hugetlb_cgroup_migrate(struct folio *old_folio,
+					  struct folio *new_folio)
 {
 }
 
--- a/mm/hugetlb.c~mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios
+++ a/mm/hugetlb.c
@@ -7314,7 +7314,7 @@ void move_hugetlb_state(struct page *old
 {
 	struct hstate *h = page_hstate(oldpage);
 
-	hugetlb_cgroup_migrate(oldpage, newpage);
+	hugetlb_cgroup_migrate(page_folio(oldpage), page_folio(newpage));
 	set_page_owner_migrate_reason(newpage, reason);
 
 	/*
--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios
+++ a/mm/hugetlb_cgroup.c
@@ -885,13 +885,11 @@ void __init hugetlb_cgroup_file_init(voi
  * hugetlb_lock will make sure a parallel cgroup rmdir won't happen
  * when we migrate hugepages
  */
-void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
+void hugetlb_cgroup_migrate(struct folio *old_folio, struct folio *new_folio)
 {
 	struct hugetlb_cgroup *h_cg;
 	struct hugetlb_cgroup *h_cg_rsvd;
-	struct hstate *h = page_hstate(oldhpage);
-	struct folio *old_folio = page_folio(oldhpage);
-	struct folio *new_folio = page_folio(newhpage);
+	struct hstate *h = folio_hstate(old_folio);
 
 	if (hugetlb_cgroup_disabled())
 		return;
@@ -905,7 +903,7 @@ void hugetlb_cgroup_migrate(struct page
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(new_folio, h_cg);
 	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
-	list_move(&newhpage->lru, &h->hugepage_activelist);
+	list_move(&new_folio->lru, &h->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
 	return;
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

