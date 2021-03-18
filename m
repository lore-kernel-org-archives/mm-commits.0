Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791D6C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D9DA64EEE
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCRAxM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 20:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229921AbhCRAwj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 20:52:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FF0764F5E;
        Thu, 18 Mar 2021 00:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616028759;
        bh=5Ro9+Ng5vAA3qI5J3gRjekl6X6y1d6xBeYXP4Dnf1pw=;
        h=Date:From:To:Subject:From;
        b=O2aaAA7aAtDd+uPnjqoQEoZKTEhO81/1vKBeI/HlCSQmj/Mq7G2LfQTwbKb9OQuAb
         r6U/s33vsMKnNDl5qeQ2TcGFYsBqXcXyP39ZBxMteHZjsox2YfrA7s69s9aXqqJne/
         GbomMIyPPl++vyKmdOFe5X1+R/Va8U6a742ziHls=
Date:   Wed, 17 Mar 2021 17:52:36 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, anshuman.khandual@arm.com,
        bodeddub@amazon.com, bp@alien8.de, bsingharora@gmail.com,
        chenhuang5@huawei.com, corbet@lwn.net, dave.hansen@linux.intel.com,
        david@redhat.com, hpa@zytor.com, joao.m.martins@oracle.com,
        jroedel@suse.de, linmiaohe@huawei.com, luto@kernel.org,
        mchehab+huawei@kernel.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        oneukum@suse.com, osalvador@suse.de, paulmck@kernel.org,
        pawan.kumar.gupta@linux.intel.com, peterz@infradead.org,
        rdunlap@infradead.org, rientjes@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        tglx@linutronix.de, viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [to-be-updated]
 mm-hugetlb-set-the-pagehwpoison-to-the-raw-error-page.patch removed from
 -mm tree
Message-ID: <20210318005236.GmZRTpqPe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: set the PageHWPoison to the raw error page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-set-the-pagehwpoison-to-the-raw-error-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: set the PageHWPoison to the raw error page

Because we reuse the first tail vmemmap page frame and remap it with
read-only, we cannot set the PageHWPosion on some tail pages.  So we can
use the head[4].private (There are at least 128 struct page structures
associated with the optimized HugeTLB page, so using head[4].private is
safe) to record the real error page index and set the raw error page
PageHWPoison later.

We cannot have more poisoned tail pages. So a single slot is
sufficient. Why?

memory_failure()
    if (PageHuge(page))
        memory_failure_hugetlb()
            head = compound_head(page)
            if (TestSetPageHWPoison(head))
                return

Because we do not clear the HWPoison of the head page, we cannot poison
another tail page.

Note: some pages might miss their poisoning (even without this patch).

Link: https://lkml.kernel.org/r/20210315092015.35396-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Tested-by: Chen Huang <chenhuang5@huawei.com>
Tested-by: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 +
 mm/hugetlb.c            |   81 +++++++++++++++++++++++++++++++++-----
 2 files changed, 75 insertions(+), 9 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-set-the-pagehwpoison-to-the-raw-error-page
+++ a/include/linux/hugetlb.h
@@ -42,6 +42,9 @@ enum {
 	SUBPAGE_INDEX_CGROUP_RSVD,	/* reuse page->private */
 	__MAX_CGROUP_SUBPAGE_INDEX = SUBPAGE_INDEX_CGROUP_RSVD,
 #endif
+#ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
+	SUBPAGE_INDEX_HWPOISON,		/* reuse page->private */
+#endif
 	__NR_USED_SUBPAGE,
 };
 
--- a/mm/hugetlb.c~mm-hugetlb-set-the-pagehwpoison-to-the-raw-error-page
+++ a/mm/hugetlb.c
@@ -1329,6 +1329,74 @@ static inline void destroy_compound_giga
 						unsigned int order) { }
 #endif
 
+#ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
+static inline void hwpoison_subpage_deliver(struct hstate *h, struct page *head)
+{
+	struct page *page;
+
+	if (!PageHWPoison(head) || !free_vmemmap_pages_per_hpage(h))
+		return;
+
+	page = head + page_private(head + SUBPAGE_INDEX_HWPOISON);
+
+	/*
+	 * Move PageHWPoison flag from head page to the raw error page,
+	 * which makes any subpages rather than the error page reusable.
+	 */
+	if (page != head) {
+		SetPageHWPoison(page);
+		ClearPageHWPoison(head);
+	}
+}
+
+static inline void hwpoison_subpage_set(struct hstate *h, struct page *head,
+					struct page *page)
+{
+	if (!PageHWPoison(head))
+		return;
+
+	if (free_vmemmap_pages_per_hpage(h)) {
+		set_page_private(head + SUBPAGE_INDEX_HWPOISON, page - head);
+	} else if (page != head) {
+		/*
+		 * Move PageHWPoison flag from head page to the raw error page,
+		 * which makes any subpages rather than the error page reusable.
+		 */
+		SetPageHWPoison(page);
+		ClearPageHWPoison(head);
+	}
+}
+
+static inline void hwpoison_subpage_clear(struct hstate *h, struct page *head)
+{
+	if (!PageHWPoison(head) || !free_vmemmap_pages_per_hpage(h))
+		return;
+
+	set_page_private(head + SUBPAGE_INDEX_HWPOISON, 0);
+}
+#else
+static inline void hwpoison_subpage_deliver(struct hstate *h, struct page *head)
+{
+}
+
+static inline void hwpoison_subpage_set(struct hstate *h, struct page *head,
+					struct page *page)
+{
+	if (PageHWPoison(head) && page != head) {
+		/*
+		 * Move PageHWPoison flag from head page to the raw error page,
+		 * which makes any subpages rather than the error page reusable.
+		 */
+		SetPageHWPoison(page);
+		ClearPageHWPoison(head);
+	}
+}
+
+static inline void hwpoison_subpage_clear(struct hstate *h, struct page *head)
+{
+}
+#endif
+
 static int update_and_free_page_surplus(struct hstate *h, struct page *page,
 					bool acct_surplus)
 	__releases(&hugetlb_lock) __acquires(&hugetlb_lock)
@@ -1833,22 +1901,17 @@ retry:
 			goto retry;
 		}
 
-		/*
-		 * Move PageHWPoison flag from head page to the raw error page,
-		 * which makes any subpages rather than the error page reusable.
-		 */
-		if (PageHWPoison(head) && page != head) {
-			SetPageHWPoison(page);
-			ClearPageHWPoison(head);
-		}
+		hwpoison_subpage_set(h, head, page);
 		list_del(&head->lru);
 		ClearHPageFreed(page);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
 		h->max_huge_pages--;
 		rc = update_and_free_page_surplus(h, head, false);
-		if (rc)
+		if (rc) {
 			h->max_huge_pages++;
+			hwpoison_subpage_clear(h, head);
+		}
 	}
 out:
 	spin_unlock(&hugetlb_lock);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-kernel-stack-account.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch

