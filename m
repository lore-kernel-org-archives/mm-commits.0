Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8D4C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 20:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77F6664F3F
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 20:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhCOUtB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 16:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231906AbhCOUs1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 16:48:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 823C264F0C;
        Mon, 15 Mar 2021 20:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615841306;
        bh=arjHLdIOwx/yQAoWimfvcsGbTBwMv7Jj7Y5VNUD6Sr4=;
        h=Date:From:To:Subject:From;
        b=Y+eyqM+XzpI9QexiOJjqPIsxRt20niZMDnKICpnqWFovQW5kdh0WF3dR+umrc6Mtz
         blhLHHhnm+9TKFMBp6XD7+aqExqRca/ZdPtUAP3tEEvgoDnWJIk+GxcjOePbcH8SzJ
         28jSNDglaIE1LlAXDlXUCJjGaDJ+7xOZFhbMOHZI=
Date:   Mon, 15 Mar 2021 13:48:25 -0700
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
Subject:  +
 mm-hugetlb-set-the-pagehwpoison-to-the-raw-error-page.patch added to -mm
 tree
Message-ID: <20210315204825.3uJo4oHGD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: set the PageHWPoison to the raw error page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-set-the-pagehwpoison-to-the-raw-error-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-set-the-pagehwpoison-to-the-raw-error-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-set-the-pagehwpoison-to-the-raw-error-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch
mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-set-the-pagehwpoison-to-the-raw-error-page.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch

