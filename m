Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B97C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 22:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29AE42312F
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 22:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbhALWYH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 17:24:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394562AbhALWYG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 17:24:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 048162312A;
        Tue, 12 Jan 2021 22:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610490205;
        bh=ly0jU8tQ6gD/4asdvpGJRFdO1gfEDIV+SkIL+PuyAS4=;
        h=Date:From:To:Subject:From;
        b=BOKwSmOOhA2yf0h4Ve0q3VNNqxmGgmwrX0TUQIrwEZjpntnXpjDXp4Pz/zFl3xEEd
         FmmteQdfldeHbyN/TglitYTkxaxT+0/kNSu1zZvUf27trOKdETp/00uoI/E3T4QawP
         6yOYsHTjHu/uOGHwFz2+oXzgrxIuf8oBa+VbNP/s=
Date:   Tue, 12 Jan 2021 14:23:23 -0800
From:   akpm@linux-foundation.org
To:     ak@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        shy828301@gmail.com, songmuchun@bytedance.com
Subject:  [to-be-updated]
 mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch removed
 from -mm tree
Message-ID: <20210112222323.uspAhhA8g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: do not migrate HugeTLB page whose refcount is one
has been removed from the -mm tree.  Its filename was
     mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: migrate: do not migrate HugeTLB page whose refcount is one

All pages isolated for the migration have an elevated reference count
and therefore seeing a reference count equal to 1 means that the last
user of the page has dropped the reference and the page has became
unused and there doesn't make much sense to migrate it anymore.  This
has been done for regular pages and this patch does the same for
hugetlb pages.  Although the likelyhood of the race is rather small for
hugetlb pages it makes sense the two code paths in sync.

[mhocko@suse.com: new changelog]
Link: https://lkml.kernel.org/r/20210110124017.86750-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
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
mm-hugetlb-add-return-eagain-for-dissolve_free_huge_page.patch

