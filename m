Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41A4C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A469C221ED
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbhAQU45 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 15:56:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbhAQU44 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 15:56:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFEE6224B8;
        Sun, 17 Jan 2021 20:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610916976;
        bh=rqHUBTHobtMovrovMdDiBTyiDEkTj8WBAAeCy7KNwGs=;
        h=Date:From:To:Subject:From;
        b=p3xmoWjAo7NoXyMIeMpCUBoYfOqRuSEbMieCy5ysmZZOmae8J44GXFHoiHnx2Xuke
         aZwDZxAcDOQiDY4lHbfKKE/Y+S4X4g6RzZeqqSsvCC6HoWBUiCF8BP04o+gVgBik92
         eCFrkMUewfXfV34KYu8BCi4UXtKyIWINpfXcF3DA=
Date:   Sun, 17 Jan 2021 12:56:13 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, shy828301@gmail.com,
        songmuchun@bytedance.com
Subject:  +
 mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch added to
 -mm tree
Message-ID: <20210117205613.w50BEtEDr%akpm@linux-foundation.org>
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

All pages isolated for the migration have an elevated reference count and
therefore seeing a reference count equal to 1 means that the last user of
the page has dropped the reference and the page has became unused and
there doesn't make much sense to migrate it anymore.  This has been done
for regular pages and this patch does the same for hugetlb pages. 
Although the likelihood of the race is rather small for hugetlb pages it
makes sense the two code paths in sync.

Link: https://lkml.kernel.org/r/20210115124942.46403-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/migrate.c~mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one
+++ a/mm/migrate.c
@@ -1280,6 +1280,12 @@ static int unmap_and_move_huge_page(new_
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
mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch

