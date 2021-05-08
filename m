Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEF1C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43125613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhEHWuX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhEHWuU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 727A8613EA;
        Sat,  8 May 2021 22:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514158;
        bh=qTT6V6nt1Nvdsh5yLozF/DVh11zfThba5ORJ809UeOs=;
        h=Date:From:To:Subject:From;
        b=hZbkLCh6OBjaDcLN3xUqjG2ZI5f3yojs3w1ZKbi+NfBwgQuQjMxBpEZC3Z0YYynO6
         lGcqMUw3tpRaj/SnYHSrUfLuAE87+bzANlivp2dOI5Xot1ri3jgnv4brXCc5EtNmyb
         FrH5+xki2xyCODqWWMbBVHs/OVAJ0iyH4E2IKICM=
Date:   Sat, 08 May 2021 15:49:18 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, aquini@redhat.com, david@redhat.com,
        jglisse@redhat.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com
Subject:  [merged]
 revert-mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch removed
 from -mm tree
Message-ID: <20210508224918.KHQu8-aWw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: migrate: skip shared exec THP for NUMA balancing"
has been removed from the -mm tree.  Its filename was
     revert-mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: Revert "mm: migrate: skip shared exec THP for NUMA balancing"

This reverts commit c77c5cbafe549eb330e8909861a3e16cbda2c848.

Since commit c77c5cbafe54 ("mm: migrate: skip shared exec THP for NUMA
balancing"), the NUMA balancing would skip shared exec transhuge page. 
But this enhancement is not suitable for transhuge page.  Because it's
required that page_mapcount() must be 1 due to no migration pte dance is
done here.  On the other hand, the shared exec transhuge page will leave
the migrate_misplaced_page() with pte entry untouched and page locked. 
Thus pagefault for NUMA will be triggered again and deadlock occurs when
we start waiting for the page lock held by ourselves.

Yang Shi said:

 "Thanks for catching this. By relooking the code I think the other
  important reason for removing this is
  migrate_misplaced_transhuge_page() actually can't see shared exec
  file THP at all since page_lock_anon_vma_read() is called before
  and if page is not anonymous page it will just restore the PMD
  without migrating anything.
  The pages for private mapped file vma may be anonymous pages due to
  COW but they can't be THP so it won't trigger THP numa fault at all. I
  think this is why no bug was reported. I overlooked this in the first
  place."

Link: https://lkml.kernel.org/r/20210325131524.48181-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/mm/migrate.c~revert-mm-migrate-skip-shared-exec-thp-for-numa-balancing
+++ a/mm/migrate.c
@@ -2084,17 +2084,6 @@ bool pmd_trans_migrating(pmd_t pmd)
 	return PageLocked(page);
 }
 
-static inline bool is_shared_exec_page(struct vm_area_struct *vma,
-				       struct page *page)
-{
-	if (page_mapcount(page) != 1 &&
-	    (page_is_file_lru(page) || vma_is_shmem(vma)) &&
-	    (vma->vm_flags & VM_EXEC))
-		return true;
-
-	return false;
-}
-
 /*
  * Attempt to migrate a misplaced page to the specified destination
  * node. Caller is expected to have an elevated reference count on
@@ -2112,7 +2101,8 @@ int migrate_misplaced_page(struct page *
 	 * Don't migrate file pages that are mapped in multiple processes
 	 * with execute permissions as they are probably shared libraries.
 	 */
-	if (is_shared_exec_page(vma, page))
+	if (page_mapcount(page) != 1 && page_is_file_lru(page) &&
+	    (vma->vm_flags & VM_EXEC))
 		goto out;
 
 	/*
@@ -2167,9 +2157,6 @@ int migrate_misplaced_transhuge_page(str
 	int page_lru = page_is_file_lru(page);
 	unsigned long start = address & HPAGE_PMD_MASK;
 
-	if (is_shared_exec_page(vma, page))
-		goto out;
-
 	new_page = alloc_pages_node(node,
 		(GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
 		HPAGE_PMD_ORDER);
@@ -2281,7 +2268,6 @@ out_fail:
 
 out_unlock:
 	unlock_page(page);
-out:
 	put_page(page);
 	return 0;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


