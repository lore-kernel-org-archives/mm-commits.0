Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01CEC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 947BF64E45
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 17:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhBHRXo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 12:23:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhBHRWt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 12:22:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABAC964EAA;
        Mon,  8 Feb 2021 17:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612804844;
        bh=tQRBggn+8Rxm1Rb6a97uEn+BHror1lWVdUjhhxIanCQ=;
        h=Date:From:To:Subject:From;
        b=G03ZodPs7gHoxNMc4tWjP8GHMUKCseoWFcP9EJcFXCgfTPOY5aM+dA4a9U+dLJbKM
         QMw77o5BxeYCwNLplV9CKexEwwJtjd/71zFBLpwZVsxowiRdjk6xVSil763Gw+kqGc
         9E7gSR74o0aINiVJ3uve9GvbShMECz00fRVzmwbs=
Date:   Mon, 08 Feb 2021 09:20:43 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, shy828301@gmail.com,
        songmuchun@bytedance.com
Subject:  [merged]
 mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch removed
 from -mm tree
Message-ID: <20210208172043.UeoR1Dpy3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: do not migrate HugeTLB page whose refcount is one
has been removed from the -mm tree.  Its filename was
     mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

