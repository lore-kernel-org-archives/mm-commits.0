Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA7CC433ED
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC5A611CE
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbhDKWb6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 18:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235366AbhDKWb5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 18:31:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7D1F611C9;
        Sun, 11 Apr 2021 22:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618180300;
        bh=N8gBVFnK4QKR1XF1y53GdpA1PWXo6gS0d68tdm+m+pw=;
        h=Date:From:To:Subject:From;
        b=H9EGp16iCj46zLEEdYJta8M17/XNrcTDBr3GUVuI7JJihanlZUKWA5iZ7cT8hNBbO
         wyd8YdiRPHLtBsewx1L2A1/DKrSl5PS4ZtNKXvLF4heRVjpGSi/ZD8VyXBcTWVxdRN
         QkBhmLPERjMZM3VXcaxVZsVomufqkqwvnJhcO5Hk=
Date:   Sun, 11 Apr 2021 15:31:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        songmuchun@bytedance.com, song.bao.hua@hisilicon.com,
        shakeelb@google.com, rientjes@google.com, peterz@infradead.org,
        peterx@redhat.com, osalvador@suse.de, naoya.horiguchi@nec.com,
        mhocko@suse.com, longman@redhat.com, linmiaohe@huawei.com,
        iamjoonsoo.kim@lge.com, hdanton@sina.com, guro@fb.com,
        david@redhat.com, aneesh.kumar@linux.ibm.com,
        almasrymina@google.com, mike.kravetz@oracle.com
Subject:  +
 hugetlb-add-per-hstate-mutex-to-synchronize-user-adjustments.patch added to
 -mm tree
Message-ID: <20210411223139.uF2t1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add per-hstate mutex to synchronize user adjustments
has been added to the -mm tree.  Its filename is
     hugetlb-add-per-hstate-mutex-to-synchronize-user-adjustments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-per-hstate-mutex-to-synchronize-user-adjustments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-per-hstate-mutex-to-synchronize-user-adjustments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: add per-hstate mutex to synchronize user adjustments

The helper routine hstate_next_node_to_alloc accesses and modifies the
hstate variable next_nid_to_alloc.  The helper is used by the routines
alloc_pool_huge_page and adjust_pool_surplus.  adjust_pool_surplus is
called with hugetlb_lock held.  However, alloc_pool_huge_page can not be
called with the hugetlb lock held as it will call the page allocator.  Two
instances of alloc_pool_huge_page could be run in parallel or
alloc_pool_huge_page could run in parallel with adjust_pool_surplus which
may result in the variable next_nid_to_alloc becoming invalid for the
caller and pages being allocated on the wrong node.

Both alloc_pool_huge_page and adjust_pool_surplus are only called from the
routine set_max_huge_pages after boot.  set_max_huge_pages is only called
as the reusult of a user writing to the proc/sysfs nr_hugepages, or
nr_hugepages_mempolicy file to adjust the number of hugetlb pages.

It makes little sense to allow multiple adjustment to the number of
hugetlb pages in parallel.  Add a mutex to the hstate and use it to only
allow one hugetlb page adjustment at a time.  This will synchronize
modifications to the next_nid_to_alloc variable.

Link: https://lkml.kernel.org/r/20210409205254.242291-4-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: HORIGUCHI NAOYA <naoya.horiguchi@nec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 mm/hugetlb.c            |    8 ++++++++
 2 files changed, 9 insertions(+)

--- a/include/linux/hugetlb.h~hugetlb-add-per-hstate-mutex-to-synchronize-user-adjustments
+++ a/include/linux/hugetlb.h
@@ -559,6 +559,7 @@ HPAGEFLAG(Freed, freed)
 #define HSTATE_NAME_LEN 32
 /* Defines one hugetlb page size */
 struct hstate {
+	struct mutex resize_lock;
 	int next_nid_to_alloc;
 	int next_nid_to_free;
 	unsigned int order;
--- a/mm/hugetlb.c~hugetlb-add-per-hstate-mutex-to-synchronize-user-adjustments
+++ a/mm/hugetlb.c
@@ -2621,6 +2621,11 @@ static int set_max_huge_pages(struct hst
 	else
 		return -ENOMEM;
 
+	/*
+	 * resize_lock mutex prevents concurrent adjustments to number of
+	 * pages in hstate via the proc/sysfs interfaces.
+	 */
+	mutex_lock(&h->resize_lock);
 	spin_lock(&hugetlb_lock);
 
 	/*
@@ -2653,6 +2658,7 @@ static int set_max_huge_pages(struct hst
 	if (hstate_is_gigantic(h) && !IS_ENABLED(CONFIG_CONTIG_ALLOC)) {
 		if (count > persistent_huge_pages(h)) {
 			spin_unlock(&hugetlb_lock);
+			mutex_unlock(&h->resize_lock);
 			NODEMASK_FREE(node_alloc_noretry);
 			return -EINVAL;
 		}
@@ -2727,6 +2733,7 @@ static int set_max_huge_pages(struct hst
 out:
 	h->max_huge_pages = persistent_huge_pages(h);
 	spin_unlock(&hugetlb_lock);
+	mutex_unlock(&h->resize_lock);
 
 	NODEMASK_FREE(node_alloc_noretry);
 
@@ -3214,6 +3221,7 @@ void __init hugetlb_add_hstate(unsigned
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order == 0);
 	h = &hstates[hugetlb_max_hstate++];
+	mutex_init(&h->resize_lock);
 	h->order = order;
 	h->mask = ~(huge_page_size(h) - 1);
 	for (i = 0; i < MAX_NUMNODES; ++i)
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-cma-change-cma-mutex-to-irq-safe-spinlock.patch
hugetlb-no-need-to-drop-hugetlb_lock-to-call-cma_release.patch
hugetlb-add-per-hstate-mutex-to-synchronize-user-adjustments.patch
hugetlb-create-remove_hugetlb_page-to-separate-functionality.patch
hugetlb-call-update_and_free_page-without-hugetlb_lock.patch
hugetlb-change-free_pool_huge_page-to-remove_pool_huge_page.patch
hugetlb-make-free_huge_page-irq-safe.patch
hugetlb-add-lockdep_assert_held-calls-for-hugetlb_lock.patch

