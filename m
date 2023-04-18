Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B61FC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbjDRXfP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbjDRXek (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B344BA5F7
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4305E62F22
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B7BC433EF;
        Tue, 18 Apr 2023 23:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860856;
        bh=T6JEvZn3DP4+MSBaLmWOu8ds9qMDA1uBd9U2XZ877IE=;
        h=Date:To:From:Subject:From;
        b=Yx0HdgqZiZoQ8MhQ+dXbv+BZ7EBTgzpTqHLhdZ4RnwaCH3HcIL2CkViuHIHEiohZ2
         3j/gcC/nShJrQp09CUdR5G735M6rFtI8ZxkBTAMsuQVpa+OpukiHxARGXUBMLgOrxK
         9/UUeEp2C0FNwdqjorh0010qKm8HVLe74MIqIccA=
Date:   Tue, 18 Apr 2023 16:34:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, peterx@redhat.com, kirill@shutemov.name,
        jiaqiyan@google.com, hughd@google.com, david@redhat.com,
        stevensd@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-skip-shmem-with-userfaultfd.patch removed from -mm tree
Message-Id: <20230418233416.97B7BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: skip shmem with userfaultfd
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-skip-shmem-with-userfaultfd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Stevens <stevensd@chromium.org>
Subject: mm/khugepaged: skip shmem with userfaultfd
Date: Tue, 4 Apr 2023 21:01:16 +0900

Make sure that collapse_file respects any userfaultfds registered with
MODE_MISSING.  If userspace has any such userfaultfds registered, then for
any page which it knows to be missing, it may expect a
UFFD_EVENT_PAGEFAULT.  This means collapse_file needs to be careful when
collapsing a shmem range would result in replacing an empty page with a
THP, to avoid breaking userfaultfd.

Synchronization when checking for userfaultfds in collapse_file is tricky
because the mmap locks can't be used to prevent races with the
registration of new userfaultfds.  Instead, we provide synchronization by
ensuring that userspace cannot observe the fact that pages are missing
before we check for userfaultfds.  Although this allows registration of a
userfaultfd to race with collapse_file, it ensures that userspace cannot
observe any pages transition from missing to present after such a race
occurs.  This makes such a race indistinguishable to the collapse
occurring immediately before the userfaultfd registration.

The first step to provide this synchronization is to stop filling gaps
during the loop iterating over the target range, since the page cache lock
can be dropped during that loop.  The second step is to fill the gaps with
XA_RETRY_ENTRY after the page cache lock is acquired the final time, to
avoid races with accesses to the page cache that only take the RCU read
lock.

The fact that we don't fill holes during the initial iteration means that
collapse_file now has to handle faults occurring during the collapse. 
This is done by re-validating the number of missing pages after acquiring
the page cache lock for the final time.

This fix is targeted at khugepaged, but the change also applies to
MADV_COLLAPSE.  MADV_COLLAPSE on a range with a userfaultfd will now
return EBUSY if there are any missing pages (instead of succeeding on
shmem and returning EINVAL on anonymous memory).  There is also now a
window during MADV_COLLAPSE where a fault on a missing page will cause the
syscall to fail with EAGAIN.

The fact that intermediate page cache state can no longer be observed
before the rollback of a failed collapse is also technically a
userspace-visible change (via at least SEEK_DATA and SEEK_END), but it is
exceedingly unlikely that anything relies on being able to observe that
transient state.

Link: https://lkml.kernel.org/r/20230404120117.2562166-4-stevensd@google.com
Signed-off-by: David Stevens <stevensd@chromium.org>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    3 
 mm/khugepaged.c                    |   99 +++++++++++++++++++++------
 2 files changed, 81 insertions(+), 21 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-skip-shmem-with-userfaultfd
+++ a/include/trace/events/huge_memory.h
@@ -38,7 +38,8 @@
 	EM( SCAN_TRUNCATED,		"truncated")			\
 	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
 	EM( SCAN_STORE_FAILED,		"store_failed")			\
-	EMe(SCAN_COPY_MC,		"copy_poisoned_page")
+	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
+	EMe(SCAN_PAGE_FILLED,		"page_filled")
 
 #undef EM
 #undef EMe
--- a/mm/khugepaged.c~mm-khugepaged-skip-shmem-with-userfaultfd
+++ a/mm/khugepaged.c
@@ -57,6 +57,7 @@ enum scan_result {
 	SCAN_PAGE_HAS_PRIVATE,
 	SCAN_STORE_FAILED,
 	SCAN_COPY_MC,
+	SCAN_PAGE_FILLED,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1860,8 +1861,8 @@ next:
  *  - allocate and lock a new huge page;
  *  - scan page cache replacing old pages with the new one
  *    + swap/gup in pages if necessary;
- *    + fill in gaps;
  *    + keep old pages around in case rollback is required;
+ *  - finalize updates to the page cache;
  *  - if replacing succeeds:
  *    + copy data over;
  *    + free old pages;
@@ -1939,7 +1940,7 @@ static int collapse_file(struct mm_struc
 						result = SCAN_TRUNCATED;
 						goto xa_locked;
 					}
-					xas_set(&xas, index);
+					xas_set(&xas, index + 1);
 				}
 				if (!shmem_charge(mapping->host, 1)) {
 					result = SCAN_FAIL;
@@ -2176,22 +2177,66 @@ xa_unlocked:
 		index++;
 	}
 
-	/*
-	 * Copying old pages to huge one has succeeded, now we
-	 * need to free the old pages.
-	 */
-	list_for_each_entry_safe(page, tmp, &pagelist, lru) {
-		list_del(&page->lru);
-		page->mapping = NULL;
-		page_ref_unfreeze(page, 1);
-		ClearPageActive(page);
-		ClearPageUnevictable(page);
-		unlock_page(page);
-		put_page(page);
+	if (nr_none) {
+		struct vm_area_struct *vma;
+		int nr_none_check = 0;
+
+		i_mmap_lock_read(mapping);
+		xas_lock_irq(&xas);
+
+		xas_set(&xas, start);
+		for (index = start; index < end; index++) {
+			if (!xas_next(&xas)) {
+				xas_store(&xas, XA_RETRY_ENTRY);
+				if (xas_error(&xas)) {
+					result = SCAN_STORE_FAILED;
+					goto immap_locked;
+				}
+				nr_none_check++;
+			}
+		}
+
+		if (nr_none != nr_none_check) {
+			result = SCAN_PAGE_FILLED;
+			goto immap_locked;
+		}
+
+		/*
+		 * If userspace observed a missing page in a VMA with a MODE_MISSING
+		 * userfaultfd, then it might expect a UFFD_EVENT_PAGEFAULT for that
+		 * page. If so, we need to roll back to avoid suppressing such an
+		 * event. Since wp/minor userfaultfds don't give userspace any
+		 * guarantees that the kernel doesn't fill a missing page with a zero
+		 * page, so they don't matter here.
+		 *
+		 * Any userfaultfds registered after this point will not be able to
+		 * observe any missing pages due to the previously inserted retry
+		 * entries.
+		 */
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, start, end) {
+			if (userfaultfd_missing(vma)) {
+				result = SCAN_EXCEED_NONE_PTE;
+				goto immap_locked;
+			}
+		}
+
+immap_locked:
+		i_mmap_unlock_read(mapping);
+		if (result != SCAN_SUCCEED) {
+			xas_set(&xas, start);
+			for (index = start; index < end; index++) {
+				if (xas_next(&xas) == XA_RETRY_ENTRY)
+					xas_store(&xas, NULL);
+			}
+
+			xas_unlock_irq(&xas);
+			goto rollback;
+		}
+	} else {
+		xas_lock_irq(&xas);
 	}
 
 	nr = thp_nr_pages(hpage);
-	xas_lock_irq(&xas);
 	if (is_shmem)
 		__mod_lruvec_page_state(hpage, NR_SHMEM_THPS, nr);
 	else
@@ -2221,6 +2266,20 @@ xa_unlocked:
 	result = retract_page_tables(mapping, start, mm, addr, hpage,
 				     cc);
 	unlock_page(hpage);
+
+	/*
+	 * The collapse has succeeded, so free the old pages.
+	 */
+	list_for_each_entry_safe(page, tmp, &pagelist, lru) {
+		list_del(&page->lru);
+		page->mapping = NULL;
+		page_ref_unfreeze(page, 1);
+		ClearPageActive(page);
+		ClearPageUnevictable(page);
+		unlock_page(page);
+		put_page(page);
+	}
+
 	goto out;
 
 rollback:
@@ -2232,15 +2291,13 @@ rollback:
 	}
 
 	xas_set(&xas, start);
-	xas_for_each(&xas, page, end - 1) {
+	end = index;
+	for (index = start; index < end; index++) {
+		xas_next(&xas);
 		page = list_first_entry_or_null(&pagelist,
 				struct page, lru);
 		if (!page || xas.xa_index < page->index) {
-			if (!nr_none)
-				break;
 			nr_none--;
-			/* Put holes back where they were */
-			xas_store(&xas, NULL);
 			continue;
 		}
 
@@ -2764,12 +2821,14 @@ static int madvise_collapse_errno(enum s
 	case SCAN_ALLOC_HUGE_PAGE_FAIL:
 		return -ENOMEM;
 	case SCAN_CGROUP_CHARGE_FAIL:
+	case SCAN_EXCEED_NONE_PTE:
 		return -EBUSY;
 	/* Resource temporary unavailable - trying again might succeed */
 	case SCAN_PAGE_COUNT:
 	case SCAN_PAGE_LOCK:
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
+	case SCAN_PAGE_FILLED:
 		return -EAGAIN;
 	/*
 	 * Other: Trying again likely not to succeed / error intrinsic to
_

Patches currently in -mm which might be from stevensd@chromium.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch
mm-khugepaged-maintain-page-cache-uptodate-flag.patch

