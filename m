Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B878EB64D9
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jul 2023 21:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjGGVGJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jul 2023 17:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjGGVGH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2023 17:06:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63D8213D
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 14:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3865560302
        for <mm-commits@vger.kernel.org>; Fri,  7 Jul 2023 21:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938EDC433C7;
        Fri,  7 Jul 2023 21:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688763961;
        bh=P3MqSQY3Jn1G/hCpiHj1VzD7P0YO0C0XZXGYmD9Sejo=;
        h=Date:To:From:Subject:From;
        b=EPqwgQQQ+y6/OI80cyQQqESRJQHETyit2f6yBViwCUaf6/YAdsQXZAlB7gF3yNjor
         Y3zPGbs/3tVQsoOhyc9cOi3s2lE3dfewHaxFYbOqTVaTY6volv4WFNmcXC5xYKH+lE
         i+F/cfAK7aG8K7nDBH+YCuALGHgjzCx/B1/4yHUw=
Date:   Fri, 07 Jul 2023 14:06:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, shy828301@gmail.com,
        naoya.horiguchi@nec.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com,
        axelrasmussen@google.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-check-if-a-subpage-of-a-hugetlb-folio-is-raw-hwpoison.patch added to mm-unstable branch
Message-Id: <20230707210601.938EDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: check if a subpage of a hugetlb folio is raw HWPOISON
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-check-if-a-subpage-of-a-hugetlb-folio-is-raw-hwpoison.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-check-if-a-subpage-of-a-hugetlb-folio-is-raw-hwpoison.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm/hwpoison: check if a subpage of a hugetlb folio is raw HWPOISON
Date: Fri, 7 Jul 2023 20:19:02 +0000

Add the functionality, is_raw_hwp_subpage, to tell if a subpage of a
hugetlb folio is a raw HWPOISON page.  This functionality relies on
RawHwpUnreliable to be not set; otherwise hugepage's raw HWPOISON list
becomes meaningless.

is_raw_hwp_subpage needs to hold hugetlb_lock in order to synchronize with
__get_huge_page_for_hwpoison, who iterates and inserts an entry to
raw_hwp_list.  llist itself doesn't ensure insertion is synchornized with
the iterating used by __is_raw_hwp_list.  Caller can minimize the overhead
of lock cycles by first checking if folio / head page's HWPOISON flag is
set.

Exports this functionality to be immediately used in the read operation
for hugetlbfs.

Link: https://lkml.kernel.org/r/20230707201904.953262-3-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   19 +++++++++++++++++++
 include/linux/mm.h      |    7 +++++++
 mm/hugetlb.c            |   10 ++++++++++
 mm/memory-failure.c     |   34 ++++++++++++++++++++++++----------
 4 files changed, 60 insertions(+), 10 deletions(-)

--- a/include/linux/hugetlb.h~mm-hwpoison-check-if-a-subpage-of-a-hugetlb-folio-is-raw-hwpoison
+++ a/include/linux/hugetlb.h
@@ -997,6 +997,25 @@ void hugetlb_register_node(struct node *
 void hugetlb_unregister_node(struct node *node);
 #endif
 
+/*
+ * Struct raw_hwp_page represents information about "raw error page",
+ * constructing singly linked list from ->_hugetlb_hwpoison field of folio.
+ */
+struct raw_hwp_page {
+	struct llist_node node;
+	struct page *page;
+};
+
+static inline struct llist_head *raw_hwp_list_head(struct folio *folio)
+{
+	return (struct llist_head *)&folio->_hugetlb_hwpoison;
+}
+
+/*
+ * Check if a given raw @subpage in a hugepage @folio is HWPOISON.
+ */
+bool is_raw_hwp_subpage(struct folio *folio, struct page *subpage);
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
--- a/include/linux/mm.h~mm-hwpoison-check-if-a-subpage-of-a-hugetlb-folio-is-raw-hwpoison
+++ a/include/linux/mm.h
@@ -3699,6 +3699,7 @@ extern const struct attribute_group memo
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 					bool *migratable_cleared);
+extern bool __is_raw_hwp_subpage(struct folio *folio, struct page *subpage);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
 struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
@@ -3713,6 +3714,12 @@ static inline int __get_huge_page_for_hw
 	return 0;
 }
 
+static inline bool __is_raw_hwp_subpage(struct folio *folio,
+					struct page *subpage)
+{
+	return false;
+}
+
 static inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 }
--- a/mm/hugetlb.c~mm-hwpoison-check-if-a-subpage-of-a-hugetlb-folio-is-raw-hwpoison
+++ a/mm/hugetlb.c
@@ -7177,6 +7177,16 @@ int get_huge_page_for_hwpoison(unsigned
 	return ret;
 }
 
+bool is_raw_hwp_subpage(struct folio *folio, struct page *subpage)
+{
+	bool ret;
+
+	spin_lock_irq(&hugetlb_lock);
+	ret = __is_raw_hwp_subpage(folio, subpage);
+	spin_unlock_irq(&hugetlb_lock);
+	return ret;
+}
+
 void folio_putback_active_hugetlb(struct folio *folio)
 {
 	spin_lock_irq(&hugetlb_lock);
--- a/mm/memory-failure.c~mm-hwpoison-check-if-a-subpage-of-a-hugetlb-folio-is-raw-hwpoison
+++ a/mm/memory-failure.c
@@ -1808,18 +1808,32 @@ EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
 #endif /* CONFIG_FS_DAX */
 
 #ifdef CONFIG_HUGETLB_PAGE
-/*
- * Struct raw_hwp_page represents information about "raw error page",
- * constructing singly linked list from ->_hugetlb_hwpoison field of folio.
- */
-struct raw_hwp_page {
-	struct llist_node node;
-	struct page *page;
-};
 
-static inline struct llist_head *raw_hwp_list_head(struct folio *folio)
+bool __is_raw_hwp_subpage(struct folio *folio, struct page *subpage)
 {
-	return (struct llist_head *)&folio->_hugetlb_hwpoison;
+	struct llist_head *raw_hwp_head;
+	struct raw_hwp_page *p, *tmp;
+	bool ret = false;
+
+	if (!folio_test_hwpoison(folio))
+		return false;
+
+	/*
+	 * When RawHwpUnreliable is set, kernel lost track of which subpages
+	 * are HWPOISON. So return as if ALL subpages are HWPOISONed.
+	 */
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
+		return true;
+
+	raw_hwp_head = raw_hwp_list_head(folio);
+	llist_for_each_entry_safe(p, tmp, raw_hwp_head->first, node) {
+		if (subpage == p->page) {
+			ret = true;
+			break;
+		}
+	}
+
+	return ret;
 }
 
 static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-hwpoison-delete-all-entries-before-traversal-in-__folio_free_raw_hwp.patch
mm-hwpoison-check-if-a-subpage-of-a-hugetlb-folio-is-raw-hwpoison.patch
hugetlbfs-improve-read-hwpoison-hugepage.patch
selftests-mm-add-tests-for-hwpoison-hugetlbfs-read.patch

