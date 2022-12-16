Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE562C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 17:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbiLPRSU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 12:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiLPRSM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 12:18:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF882EF75
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 09:18:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60EB5B81DDD
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 17:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01ED9C433D2;
        Fri, 16 Dec 2022 17:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671211082;
        bh=OQdqazIta8U6UrBU5C2YfNnEMSnekON1b6nlXvdpGvQ=;
        h=Date:To:From:Subject:From;
        b=PDO48oXZjdJQf8lY0sMtvXBKdd/matuivQDr5eQbXVwY8XnAOguqxep3JVD4Pqs87
         jSDHrcZjZ+2J1NClDJms7TOuLsVu0B6QFjRar9eGiQ/6NZ+GEuNah3VeglcMXTbbOd
         KF2Pb6D4c8w+t4nmsQo8g7sFfrEDkiac+9hd6cEk=
Date:   Fri, 16 Dec 2022 09:18:01 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jhubbard@nvidia.com,
        jannh@google.com, david@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch added to mm-unstable branch
Message-Id: <20221216171802.01ED9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: make follow_hugetlb_page() safe to pmd unshare
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: make follow_hugetlb_page() safe to pmd unshare
Date: Fri, 16 Dec 2022 10:52:23 -0500

Since follow_hugetlb_page() walks the pgtable, it needs the vma lock to
make sure the pgtable page will not be freed concurrently.

Link: https://lkml.kernel.org/r/20221216155223.2043727-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare
+++ a/mm/hugetlb.c
@@ -6433,6 +6433,7 @@ long follow_hugetlb_page(struct mm_struc
 			break;
 		}
 
+		hugetlb_vma_lock_read(vma);
 		/*
 		 * Some archs (sparc64, sh*) have multiple pte_ts to
 		 * each hugepage.  We have to make sure we get the
@@ -6457,6 +6458,7 @@ long follow_hugetlb_page(struct mm_struc
 		    !hugetlbfs_pagecache_present(h, vma, vaddr)) {
 			if (pte)
 				spin_unlock(ptl);
+			hugetlb_vma_unlock_read(vma);
 			remainder = 0;
 			break;
 		}
@@ -6478,6 +6480,8 @@ long follow_hugetlb_page(struct mm_struc
 
 			if (pte)
 				spin_unlock(ptl);
+			hugetlb_vma_unlock_read(vma);
+
 			if (flags & FOLL_WRITE)
 				fault_flags |= FAULT_FLAG_WRITE;
 			else if (unshare)
@@ -6540,6 +6544,7 @@ long follow_hugetlb_page(struct mm_struc
 			remainder -= pages_per_huge_page(h);
 			i += pages_per_huge_page(h);
 			spin_unlock(ptl);
+			hugetlb_vma_unlock_read(vma);
 			continue;
 		}
 
@@ -6569,6 +6574,7 @@ long follow_hugetlb_page(struct mm_struc
 			if (WARN_ON_ONCE(!try_grab_folio(pages[i], refs,
 							 flags))) {
 				spin_unlock(ptl);
+				hugetlb_vma_unlock_read(vma);
 				remainder = 0;
 				err = -ENOMEM;
 				break;
@@ -6580,6 +6586,7 @@ long follow_hugetlb_page(struct mm_struc
 		i += refs;
 
 		spin_unlock(ptl);
+		hugetlb_vma_unlock_read(vma);
 	}
 	*nr_pages = remainder;
 	/*
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-uffd-fix-pte-marker-when-fork-without-fork-event.patch
mm-fix-a-few-rare-cases-of-using-swapin-error-pte-marker.patch
mm-uffd-always-wr-protect-pte-in-ptepmd_mkuffd_wp.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch

