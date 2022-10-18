Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B612C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 22:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiJRWCR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiJRWCR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 18:02:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC4BBE525
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 15:02:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8437BB82155
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 22:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27428C433C1;
        Tue, 18 Oct 2022 22:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666130533;
        bh=C7bpPkaZr6+tRdM+BtyWHSW4fQpG1fuvtdf98hI+tfc=;
        h=Date:To:From:Subject:From;
        b=jKiwRgHWzgJ48JogbqSo97OcbQ595K4MPHYYP/TlGR5nw3vjbvbTDPaccR7W3GxSw
         oJ5ATDSqfKkEFOxjSX71kbKa3A6FnpVCFz+eH0qsgF12jJpcZlEjqnvb0ZqQlCVVQV
         9jbQgvePFG9qtVUHWPcSBqLCVKz3klyNGdRq23Rc=
Date:   Tue, 18 Oct 2022 15:02:12 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        axelrasmussen@google.com, jthoughton@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-dont-delete-error-page-from-pagecache.patch added to mm-unstable branch
Message-Id: <20221018220213.27428C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: don't delete error page from pagecache
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-dont-delete-error-page-from-pagecache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-dont-delete-error-page-from-pagecache.patch

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
From: James Houghton <jthoughton@google.com>
Subject: hugetlbfs: don't delete error page from pagecache
Date: Tue, 18 Oct 2022 20:01:25 +0000

This change is very similar to the change that was made for shmem [1], and
it solves the same problem but for HugeTLBFS instead.

Currently, when poison is found in a HugeTLB page, the page is removed
from the page cache.  That means that attempting to map or read that
hugepage in the future will result in a new hugepage being allocated
instead of notifying the user that the page was poisoned.  As [1] states,
this is effectively memory corruption.

The fix is to leave the page in the page cache.  If the user attempts to
use a poisoned HugeTLB page with a syscall, the syscall will fail with
EIO, the same error code that shmem uses.  For attempts to map the page,
the thread will get a BUS_MCEERR_AR SIGBUS.

[1]: commit a76054266661 ("mm: shmem: don't truncate page if memory failure happens")

Link: https://lkml.kernel.org/r/20221018200125.848471-1-jthoughton@google.com
Signed-off-by: James Houghton <jthoughton@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   13 ++++++-------
 mm/hugetlb.c         |    4 ++++
 mm/memory-failure.c  |    5 ++++-
 3 files changed, 14 insertions(+), 8 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-dont-delete-error-page-from-pagecache
+++ a/fs/hugetlbfs/inode.c
@@ -328,6 +328,12 @@ static ssize_t hugetlbfs_read_iter(struc
 		} else {
 			unlock_page(page);
 
+			if (PageHWPoison(page)) {
+				put_page(page);
+				retval = -EIO;
+				break;
+			}
+
 			/*
 			 * We have the page, copy it to user space buffer.
 			 */
@@ -1111,13 +1117,6 @@ static int hugetlbfs_migrate_folio(struc
 static int hugetlbfs_error_remove_page(struct address_space *mapping,
 				struct page *page)
 {
-	struct inode *inode = mapping->host;
-	pgoff_t index = page->index;
-
-	hugetlb_delete_from_page_cache(page_folio(page));
-	if (unlikely(hugetlb_unreserve_pages(inode, index, index + 1, 1)))
-		hugetlb_fix_reserve_counts(inode);
-
 	return 0;
 }
 
--- a/mm/hugetlb.c~hugetlbfs-dont-delete-error-page-from-pagecache
+++ a/mm/hugetlb.c
@@ -6101,6 +6101,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 
 	ptl = huge_pte_lock(h, dst_mm, dst_pte);
 
+	ret = -EIO;
+	if (PageHWPoison(page))
+		goto out_release_unlock;
+
 	/*
 	 * We allow to overwrite a pte marker: consider when both MISSING|WP
 	 * registered, we firstly wr-protect a none pte which has no page cache
--- a/mm/memory-failure.c~hugetlbfs-dont-delete-error-page-from-pagecache
+++ a/mm/memory-failure.c
@@ -1080,6 +1080,7 @@ static int me_huge_page(struct page_stat
 	int res;
 	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
+	bool extra_pins = false;
 
 	if (!PageHuge(hpage))
 		return MF_DELAYED;
@@ -1087,6 +1088,8 @@ static int me_huge_page(struct page_stat
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
+		/* The page is kept in page cache. */
+		extra_pins = true;
 		unlock_page(hpage);
 	} else {
 		unlock_page(hpage);
@@ -1104,7 +1107,7 @@ static int me_huge_page(struct page_stat
 		}
 	}
 
-	if (has_extra_refcount(ps, p, false))
+	if (has_extra_refcount(ps, p, extra_pins))
 		res = MF_FAILED;
 
 	return res;
_

Patches currently in -mm which might be from jthoughton@google.com are

hugetlbfs-dont-delete-error-page-from-pagecache.patch

