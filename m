Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE28C6FA89
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiILDae (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiILD3C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B5627DE7
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 614176117F
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56E2C433B5;
        Mon, 12 Sep 2022 03:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953336;
        bh=czFmR0Dsv90n7p9srzgYJdwkxSC8booByYwynrFtpUU=;
        h=Date:To:From:Subject:From;
        b=o35I4TCAmfN126UbG0ZxQiX5RuRWCWb3NetG4gnYHhuRwCFwky8RscpKyrwj4VnTz
         v6x2ShvKA4ZMrg03tM2o19aO8s3RRAiyHI3nxX53sKO+YKuPlIqjVz02WKSUr6i+d0
         dXdX5y+aP5EixcCDhvBfT28jSFCxnfPyQUM//Lec=
Date:   Sun, 11 Sep 2022 20:28:56 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb_cgroup-remove-unneeded-return-value.patch removed from -mm tree
Message-Id: <20220912032856.B56E2C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb_cgroup: remove unneeded return value
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-remove-unneeded-return-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

