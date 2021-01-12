Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19504C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 04:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D76F6225AB
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 04:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387964AbhALE7P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jan 2021 23:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387971AbhALE7P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 Jan 2021 23:59:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A49822510;
        Tue, 12 Jan 2021 04:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610427514;
        bh=e0JwxK+pOnlC/eyZltqL3PzcfsOmyayLRZQgK0Cb8TY=;
        h=Date:From:To:Subject:From;
        b=BjwRJa5DYfXES1qqxemgfqxAiYOqs/s6Om2Cdgxlb088p5V9usKQE4NwD3QAW3Ivs
         kWo2n7J/Yy8lx+vTDFK7fhrwq9i6VlYf2VDc65avUDv8iIrhju3EsjvPqg2/qaW/4x
         XcdNSjNIM5ihWKPzTuxo+EHjRwPoWiLkbMOv3W0k=
Date:   Mon, 11 Jan 2021 20:58:33 -0800
From:   akpm@linux-foundation.org
To:     ak@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        shy828301@gmail.com, songmuchun@bytedance.com
Subject:  +
 mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch added to
 -mm tree
Message-ID: <20210112045833.dVsmy3xC9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: do not migrate HugeTLB page whose refcount is one
has been added to the -mm tree.  Its filename is
     mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch

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
Subject: mm: migrate: do not migrate HugeTLB page whose refcount is one

If the refcount is one when it is migrated, it means that the page
was freed from under us. So we are done and do not need to migrate.

This optimization is consistent with the regular pages, just like
unmap_and_move() does.

Link: https://lkml.kernel.org/r/20210110124017.86750-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/migrate.c~mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one
+++ a/mm/migrate.c
@@ -1284,6 +1284,12 @@ static int unmap_and_move_huge_page(new_
 		return -ENOSYS;
 	}
 
+	if (page_count(hpage) == 1) {
+		/* page was freed from under us. So we are done. */
+		putback_active_hugepage(hpage);
+		return MIGRATEPAGE_SUCCESS;
+	}
+
 	new_hpage = get_new_page(hpage, private);
 	if (!new_hpage)
 		return -ENOMEM;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page.patch
mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page.patch
mm-hugetlb-fix-a-race-between-isolating-and-freeing-page.patch
mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch
mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch
mm-hugetlb-add-return-eagain-for-dissolve_free_huge_page.patch

