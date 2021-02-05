Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD6BC433E0
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AF4164FD4
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhBFDHH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:07:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:41360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231735AbhBFDBz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 22:01:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C22964FF5;
        Fri,  5 Feb 2021 22:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612565153;
        bh=QLAkLoUms/Kxs4dryFnARUVit3VqCscesPLW88wgUcQ=;
        h=Date:From:To:Subject:From;
        b=11p0PU8jInIcL0zSdUlajJ6Kre58pW4Orp+nz25OFrgDCj8OlVnEDbRf+6Y6N7URQ
         bZTkdjltJfgmTxKUSBxAHyL552mgv4DTdxzftRRHFnSajV9006Df+8u/m+xzDuSgdy
         h8pXrsX9Ps0MVrsYxsIbafH5gBdhUZiST7jEOGmM=
Date:   Fri, 05 Feb 2021 14:45:52 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, linmiaohe@huawei.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com
Subject:  +
 mm-memcontrol-replace-the-loop-with-a-list_for_each_entry.patch added to
 -mm tree
Message-ID: <20210205224552.i5kQFRqU8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: replace the loop with a list_for_each_entry()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-replace-the-loop-with-a-list_for_each_entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-replace-the-loop-with-a-list_for_each_entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-replace-the-loop-with-a-list_for_each_entry.patch

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
Subject: mm: memcontrol: replace the loop with a list_for_each_entry()

The rule of list walk has gone since:

 commit a9d5adeeb4b2 ("mm/memcontrol: allow to uncharge page without using page->lru field")

So remove the strange comment and replace the loop with a
list_for_each_entry().

There is only one caller of the uncharge_list().  So just fold it into
mem_cgroup_uncharge_list() and remove it.

Link: https://lkml.kernel.org/r/20210204163055.56080-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-replace-the-loop-with-a-list_for_each_entry
+++ a/mm/memcontrol.c
@@ -6862,31 +6862,6 @@ static void uncharge_page(struct page *p
 	css_put(&ug->memcg->css);
 }
 
-static void uncharge_list(struct list_head *page_list)
-{
-	struct uncharge_gather ug;
-	struct list_head *next;
-
-	uncharge_gather_clear(&ug);
-
-	/*
-	 * Note that the list can be a single page->lru; hence the
-	 * do-while loop instead of a simple list_for_each_entry().
-	 */
-	next = page_list->next;
-	do {
-		struct page *page;
-
-		page = list_entry(next, struct page, lru);
-		next = page->lru.next;
-
-		uncharge_page(page, &ug);
-	} while (next != page_list);
-
-	if (ug.memcg)
-		uncharge_batch(&ug);
-}
-
 /**
  * mem_cgroup_uncharge - uncharge a page
  * @page: page to uncharge
@@ -6918,11 +6893,17 @@ void mem_cgroup_uncharge(struct page *pa
  */
 void mem_cgroup_uncharge_list(struct list_head *page_list)
 {
+	struct uncharge_gather ug;
+	struct page *page;
+
 	if (mem_cgroup_disabled())
 		return;
 
-	if (!list_empty(page_list))
-		uncharge_list(page_list);
+	uncharge_gather_clear(&ug);
+	list_for_each_entry(page, page_list, lru)
+		uncharge_page(page, &ug);
+	if (ug.memcg)
+		uncharge_batch(&ug);
 }
 
 /**
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page.patch
mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page.patch
mm-hugetlb-fix-a-race-between-isolating-and-freeing-page.patch
mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active.patch
mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch
mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch
mm-memcontrol-replace-the-loop-with-a-list_for_each_entry.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag-fix.patch

