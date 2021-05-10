Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB2CC433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E5AB61040
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhEJEdQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhEJEdQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:33:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 013A261075;
        Mon, 10 May 2021 04:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620621132;
        bh=EYuVcK+W2KMLh73DcphkFCp90ufz7wI5Y47Sr9o/w0Y=;
        h=Date:From:To:Subject:From;
        b=CwPqzXfSiaOWa1oImCOIKHqQaz9H2fkOvRHxq9/93PqBHE2kx2lIW/JrdTYJ4Nyxk
         R27wExKMVmKAPYY6zU09nT2PO6mt0dCWezfz6kb6jdq/4zR+xnN59jOUmVofQOtH/g
         fb3YYJSxiVBX/APqiNR10C/iYuC1KcGfUTDJL3sY=
Date:   Sun, 09 May 2021 21:32:11 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  +
 =?US-ASCII?Q?mm-memcontrol-rename-lruvec=5Fholds=5Fpage=5Flru=5Flock-to-p?=
 =?US-ASCII?Q?age=5Fmatches=5Flruvec.patch?= added to -mm tree
Message-ID: <20210510043211.4aJ102Ibq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rename lruvec_holds_page_lru_lock to page_matches_lruvec
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec.patch

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
Subject: mm: memcontrol: rename lruvec_holds_page_lru_lock to page_matches_lruvec

lruvec_holds_page_lru_lock() doesn't check anything about locking and is
used to check whether the page belongs to the lruvec.  So rename it to
page_matches_lruvec().

Link: https://lkml.kernel.org/r/20210417043538.9793-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 ++++----
 mm/vmscan.c                |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec
+++ a/include/linux/memcontrol.h
@@ -1492,8 +1492,8 @@ static inline void unlock_page_lruvec_ir
 	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
 }
 
-static inline bool lruvec_holds_page_lru_lock(struct page *page,
-					      struct lruvec *lruvec)
+/* Test requires a stable page->memcg binding, see page_memcg() */
+static inline bool page_matches_lruvec(struct page *page, struct lruvec *lruvec)
 {
 	return lruvec_pgdat(lruvec) == page_pgdat(page) &&
 	       lruvec_memcg(lruvec) == page_memcg(page);
@@ -1504,7 +1504,7 @@ static inline struct lruvec *relock_page
 		struct lruvec *locked_lruvec)
 {
 	if (locked_lruvec) {
-		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
+		if (page_matches_lruvec(page, locked_lruvec))
 			return locked_lruvec;
 
 		unlock_page_lruvec_irq(locked_lruvec);
@@ -1518,7 +1518,7 @@ static inline struct lruvec *relock_page
 		struct lruvec *locked_lruvec, unsigned long *flags)
 {
 	if (locked_lruvec) {
-		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
+		if (page_matches_lruvec(page, locked_lruvec))
 			return locked_lruvec;
 
 		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
--- a/mm/vmscan.c~mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec
+++ a/mm/vmscan.c
@@ -2063,7 +2063,7 @@ static unsigned noinline_for_stack move_
 		 * All pages were isolated from the same lruvec (and isolation
 		 * inhibits memcg migration).
 		 */
-		VM_BUG_ON_PAGE(!lruvec_holds_page_lru_lock(page, lruvec), page);
+		VM_BUG_ON_PAGE(!page_matches_lruvec(page, lruvec), page);
 		add_page_to_lru_list(page, lruvec);
 		nr_pages = thp_nr_pages(page);
 		nr_moved += nr_pages;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-root_mem_cgroup-charging.patch
mm-memcontrol-fix-page-charging-in-page-replacement.patch
mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch
mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch
mm-memcontrol-simplify-lruvec_holds_page_lru_lock.patch
mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec.patch
mm-memcontrol-simplify-the-logic-of-objcg-pinning-memcg.patch
mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock.patch
mm-vmscan-remove-noinline_for_stack.patch
mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch
mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-defer-freeing-of-hugetlb-pages.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch

