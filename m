Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0DCC433ED
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 830DE611C9
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbhDKWbz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 18:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235366AbhDKWbz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 18:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF329610CB;
        Sun, 11 Apr 2021 22:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618180298;
        bh=Js67mPjA59IUyD6vk03yOg8lU0THSas+jqWCVDI27hI=;
        h=Date:From:To:Subject:From;
        b=CjOAt9JlgSRKmTcdshq4RDBOt4F0PTrWhjZi1B723da9Z5qTgbMurKvk8i3JYR6nB
         qTJkn0dGDIk/oC6vlwBnZ93kqWaO4UXIT89NTmPL1rs0eiw7hYOF00FOsQA2J4iqh7
         3B6L08E9dcMMaJCmr3yInVF+JCW1OIjFbrG1cVDM=
Date:   Sun, 11 Apr 2021 15:31:37 -0700
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
 hugetlb-no-need-to-drop-hugetlb_lock-to-call-cma_release.patch added to -mm
 tree
Message-ID: <20210411223137.rb_le%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: no need to drop hugetlb_lock to call cma_release
has been added to the -mm tree.  Its filename is
     hugetlb-no-need-to-drop-hugetlb_lock-to-call-cma_release.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-no-need-to-drop-hugetlb_lock-to-call-cma_release.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-no-need-to-drop-hugetlb_lock-to-call-cma_release.patch

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
Subject: hugetlb: no need to drop hugetlb_lock to call cma_release

Now that cma_release is non-blocking and irq safe, there is no need to
drop hugetlb_lock before calling.

Link: https://lkml.kernel.org/r/20210409205254.242291-3-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: HORIGUCHI NAOYA <naoya.horiguchi@nec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/hugetlb.c~hugetlb-no-need-to-drop-hugetlb_lock-to-call-cma_release
+++ a/mm/hugetlb.c
@@ -1355,14 +1355,8 @@ static void update_and_free_page(struct
 	set_compound_page_dtor(page, NULL_COMPOUND_DTOR);
 	set_page_refcounted(page);
 	if (hstate_is_gigantic(h)) {
-		/*
-		 * Temporarily drop the hugetlb_lock, because
-		 * we might block in free_gigantic_page().
-		 */
-		spin_unlock(&hugetlb_lock);
 		destroy_compound_gigantic_page(page, huge_page_order(h));
 		free_gigantic_page(page, huge_page_order(h));
-		spin_lock(&hugetlb_lock);
 	} else {
 		__free_pages(page, huge_page_order(h));
 	}
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

