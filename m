Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B162EC25B08
	for <mm-commits@archiver.kernel.org>; Mon, 15 Aug 2022 00:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiHOAGK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 20:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiHOAGJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 20:06:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED08F59A
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 17:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05B09B80B77
        for <mm-commits@vger.kernel.org>; Mon, 15 Aug 2022 00:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1EAC433C1;
        Mon, 15 Aug 2022 00:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660521962;
        bh=ksbeuf5/LfCGGf5Tkogkext5XARCXmTzZPM6eH6yIPA=;
        h=Date:To:From:Subject:From;
        b=Z8c6ferRvSVmzKyQitRroxfq1kbkQ2opuzVyb7mUdprZOdh3aCyGvHwUMXLImITiz
         HiLS6YahnqUnZMD8WsH8c63uGwhHnzXGn7AOIf2En9dKzcVEOGkEB/xs1HwNKq4bpz
         6Y+RTAAmdY9T8x2+XZow5MqZsLJubvo43uvtKIXw=
Date:   Sun, 14 Aug 2022 17:06:01 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb_cgroup-remove-unneeded-return-value.patch added to mm-unstable branch
Message-Id: <20220815000602.9F1EAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: remove unneeded return value
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb_cgroup-remove-unneeded-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb_cgroup-remove-unneeded-return-value.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb_cgroup: remove unneeded return value
Date: Fri, 29 Jul 2022 16:01:04 +0800

The return value of set_hugetlb_cgroup and set_hugetlb_cgroup_rsvd are
always ignored. Remove them to clean up the code.

Link: https://lkml.kernel.org/r/20220729080106.12752-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~hugetlb_cgroup-remove-unneeded-return-value
+++ a/include/linux/hugetlb_cgroup.h
@@ -90,32 +90,31 @@ hugetlb_cgroup_from_page_rsvd(struct pag
 	return __hugetlb_cgroup_from_page(page, true);
 }
 
-static inline int __set_hugetlb_cgroup(struct page *page,
+static inline void __set_hugetlb_cgroup(struct page *page,
 				       struct hugetlb_cgroup *h_cg, bool rsvd)
 {
 	VM_BUG_ON_PAGE(!PageHuge(page), page);
 
 	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
-		return -1;
+		return;
 	if (rsvd)
 		set_page_private(page + SUBPAGE_INDEX_CGROUP_RSVD,
 				 (unsigned long)h_cg);
 	else
 		set_page_private(page + SUBPAGE_INDEX_CGROUP,
 				 (unsigned long)h_cg);
-	return 0;
 }
 
-static inline int set_hugetlb_cgroup(struct page *page,
+static inline void set_hugetlb_cgroup(struct page *page,
 				     struct hugetlb_cgroup *h_cg)
 {
-	return __set_hugetlb_cgroup(page, h_cg, false);
+	__set_hugetlb_cgroup(page, h_cg, false);
 }
 
-static inline int set_hugetlb_cgroup_rsvd(struct page *page,
+static inline void set_hugetlb_cgroup_rsvd(struct page *page,
 					  struct hugetlb_cgroup *h_cg)
 {
-	return __set_hugetlb_cgroup(page, h_cg, true);
+	__set_hugetlb_cgroup(page, h_cg, true);
 }
 
 static inline bool hugetlb_cgroup_disabled(void)
@@ -199,16 +198,14 @@ hugetlb_cgroup_from_page_rsvd(struct pag
 	return NULL;
 }
 
-static inline int set_hugetlb_cgroup(struct page *page,
+static inline void set_hugetlb_cgroup(struct page *page,
 				     struct hugetlb_cgroup *h_cg)
 {
-	return 0;
 }
 
-static inline int set_hugetlb_cgroup_rsvd(struct page *page,
+static inline void set_hugetlb_cgroup_rsvd(struct page *page,
 					  struct hugetlb_cgroup *h_cg)
 {
-	return 0;
 }
 
 static inline bool hugetlb_cgroup_disabled(void)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch

