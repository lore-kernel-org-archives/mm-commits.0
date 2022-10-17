Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E7EC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 20:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJQUl2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 16:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbiJQUkt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 16:40:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD4680BFF
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 13:37:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAEA3B81AE1
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B4BC433C1;
        Mon, 17 Oct 2022 20:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666039043;
        bh=eO9Gcb4f0tHzKPIqz9+ds28jTruYMuHAqDPI5fR0jNs=;
        h=Date:To:From:Subject:From;
        b=mchEGiD/zuzTLNIM0MTttHHGQFDYC1rtr9rn+/608TqZa/7efjRbgz54xuJ8NAWyc
         dnhQRi90uqmeq6kePtc4fbrnqX+yMpoXhXR+qI5Q6WzOksrIWRwe7nToA9prgO+uw/
         hS5TJx9jlouqvwsGYNfe+ZYoHVt0b64fG2oouqfc=
Date:   Mon, 17 Oct 2022 13:37:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz,
        songmuchun@bytedance.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lkp@intel.com, hughd@google.com,
        ebiederm@xmission.com, dhowells@redhat.com, ccross@google.com,
        arnd@arndb.de, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch added to mm-unstable branch
Message-Id: <20221017203723.98B4BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugeltb_cgroup: convert hugetlb_cgroup_commit_charge*() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch

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
Subject: mm/hugeltb_cgroup: convert hugetlb_cgroup_commit_charge*() to folios
Date: Thu, 13 Oct 2022 20:13:02 -0700

Convert hugetlb_cgroup_commit_charge*() to internally use folios to clean
up the code after __set_hugetlb_cgroup() was changed to take a folio.

Link: https://lkml.kernel.org/r/20221014031303.231740-9-sidhartha.kumar@oracle.com
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

 mm/hugetlb_cgroup.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/hugetlb_cgroup.c~mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios
+++ a/mm/hugetlb_cgroup.c
@@ -310,21 +310,21 @@ int hugetlb_cgroup_charge_cgroup_rsvd(in
 /* Should be called with hugetlb_lock held */
 static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg,
-					   struct page *page, bool rsvd)
+					   struct folio *folio, bool rsvd)
 {
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
 
-	__set_hugetlb_cgroup(page_folio(page), h_cg, rsvd);
+	__set_hugetlb_cgroup(folio, h_cg, rsvd);
 	if (!rsvd) {
 		unsigned long usage =
-			h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
+			h_cg->nodeinfo[folio_nid(folio)]->usage[idx];
 		/*
 		 * This write is not atomic due to fetching usage and writing
 		 * to it, but that's fine because we call this with
 		 * hugetlb_lock held anyway.
 		 */
-		WRITE_ONCE(h_cg->nodeinfo[page_to_nid(page)]->usage[idx],
+		WRITE_ONCE(h_cg->nodeinfo[folio_nid(folio)]->usage[idx],
 			   usage + nr_pages);
 	}
 }
@@ -333,14 +333,18 @@ void hugetlb_cgroup_commit_charge(int id
 				  struct hugetlb_cgroup *h_cg,
 				  struct page *page)
 {
-	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, page, false);
+	struct folio *folio = page_folio(page);
+
+	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio, false);
 }
 
 void hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
 				       struct hugetlb_cgroup *h_cg,
 				       struct page *page)
 {
-	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, page, true);
+	struct folio *folio = page_folio(page);
+
+	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio, true);
 }
 
 /*
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

