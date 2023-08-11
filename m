Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B689C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbjHKXDM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbjHKXBa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:01:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8613C38
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AE456492A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CCFC433C7;
        Fri, 11 Aug 2023 23:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794849;
        bh=yBptG4eaXgKJ82BV/lAWBPTuq7eO3oHBM1SPXk5hbXg=;
        h=Date:To:From:Subject:From;
        b=b+bU8AHgfnHeIOyLUIIco4331VcOTMkqQLR8xV7SxYt8hhYsW5Jr8LfFrtVvqPCKo
         3Rq28HZoURN02V2RC8SECSjN6j+sfUBnhADrarpWHcx+HReZTmYmAz1EPXXHR2QH4M
         IL6MxmQQD9W7mE8pa4781FA8VbBf9VgdtbVnwEek=
Date:   Fri, 11 Aug 2023 16:00:49 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        jthoughton@google.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-check-if-a-raw-page-in-a-hugetlb-folio-is-raw-hwpoison.patch removed from -mm tree
Message-Id: <20230811230049.A0CCFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hwpoison: check if a raw page in a hugetlb folio is raw HWPOISON
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-check-if-a-raw-page-in-a-hugetlb-folio-is-raw-hwpoison.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm/hwpoison: check if a raw page in a hugetlb folio is raw HWPOISON
Date: Thu, 13 Jul 2023 00:18:31 +0000

Add the functionality, is_raw_hwpoison_page_in_hugepage, to tell if a raw
page in a hugetlb folio is HWPOISON.  This functionality relies on
RawHwpUnreliable to be not set; otherwise hugepage's raw HWPOISON list
becomes meaningless.

is_raw_hwpoison_page_in_hugepage holds mf_mutex in order to synchronize
with folio_set_hugetlb_hwpoison and folio_free_raw_hwp who iterate,
insert, or delete entry in raw_hwp_list.  llist itself doesn't ensure
insertion and removal are synchornized with the llist_for_each_entry used
by is_raw_hwpoison_page_in_hugepage (unless iterated entries are already
deleted from the list).  Caller can minimize the overhead of lock cycles
by first checking HWPOISON flag of the folio.

Exports this functionality to be immediately used in the read operation
for hugetlbfs.

Link: https://lkml.kernel.org/r/20230713001833.3778937-3-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 ++++
 mm/memory-failure.c     |   40 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

--- a/include/linux/hugetlb.h~mm-hwpoison-check-if-a-raw-page-in-a-hugetlb-folio-is-raw-hwpoison
+++ a/include/linux/hugetlb.h
@@ -997,6 +997,11 @@ void hugetlb_register_node(struct node *
 void hugetlb_unregister_node(struct node *node);
 #endif
 
+/*
+ * Check if a given raw @page in a hugepage is HWPOISON.
+ */
+bool is_raw_hwpoison_page_in_hugepage(struct page *page);
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
--- a/mm/memory-failure.c~mm-hwpoison-check-if-a-raw-page-in-a-hugetlb-folio-is-raw-hwpoison
+++ a/mm/memory-failure.c
@@ -72,6 +72,8 @@ atomic_long_t num_poisoned_pages __read_
 
 static bool hw_memory_failure __read_mostly = false;
 
+static DEFINE_MUTEX(mf_mutex);
+
 void num_poisoned_pages_inc(unsigned long pfn)
 {
 	atomic_long_inc(&num_poisoned_pages);
@@ -1814,6 +1816,7 @@ EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
 #endif /* CONFIG_FS_DAX */
 
 #ifdef CONFIG_HUGETLB_PAGE
+
 /*
  * Struct raw_hwp_page represents information about "raw error page",
  * constructing singly linked list from ->_hugetlb_hwpoison field of folio.
@@ -1828,6 +1831,41 @@ static inline struct llist_head *raw_hwp
 	return (struct llist_head *)&folio->_hugetlb_hwpoison;
 }
 
+bool is_raw_hwpoison_page_in_hugepage(struct page *page)
+{
+	struct llist_head *raw_hwp_head;
+	struct raw_hwp_page *p;
+	struct folio *folio = page_folio(page);
+	bool ret = false;
+
+	if (!folio_test_hwpoison(folio))
+		return false;
+
+	if (!folio_test_hugetlb(folio))
+		return PageHWPoison(page);
+
+	/*
+	 * When RawHwpUnreliable is set, kernel lost track of which subpages
+	 * are HWPOISON. So return as if ALL subpages are HWPOISONed.
+	 */
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
+		return true;
+
+	mutex_lock(&mf_mutex);
+
+	raw_hwp_head = raw_hwp_list_head(folio);
+	llist_for_each_entry(p, raw_hwp_head->first, node) {
+		if (page == p->page) {
+			ret = true;
+			break;
+		}
+	}
+
+	mutex_unlock(&mf_mutex);
+
+	return ret;
+}
+
 static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 {
 	struct llist_node *t, *tnode, *head;
@@ -2110,8 +2148,6 @@ out:
 	return rc;
 }
 
-static DEFINE_MUTEX(mf_mutex);
-
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-hwpoison-rename-hwp_walk-to-hwpoison_walk.patch

