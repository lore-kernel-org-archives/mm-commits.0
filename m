Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F095FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiLPXtk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiLPXtf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:49:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FDC4F641
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:49:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4766AB81E2C
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0278DC433F0;
        Fri, 16 Dec 2022 23:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671234571;
        bh=k5Q50zajZr9GnSACI0NRKTZzVrbZmALbUkufCs4GxeQ=;
        h=Date:To:From:Subject:From;
        b=09uLJJIG6vjaJuvGvhVzpCvaoZbE/J97nzzHkWTXG/vyFnJCMH1SUGqkDwTeQiHRt
         Yck2iT/+FBO+eiA5sUTWe86gYBRpptPJCwivVt5v5smIJurSr46bg5DcXyY5hviQeX
         qw93h9f6rfTIFfbgIqj5Z1oK5YoAVefaBPy0sN34=
Date:   Fri, 16 Dec 2022 15:49:30 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        tony.luck@intel.com, tongtiangen@huawei.com, shy828301@gmail.com,
        osalvador@suse.de, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-recover-from-poisoned-file-backed-memory.patch added to mm-unstable branch
Message-Id: <20221216234931.0278DC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: recover from poisoned file-backed memory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-recover-from-poisoned-file-backed-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-recover-from-poisoned-file-backed-memory.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm/khugepaged: recover from poisoned file-backed memory
Date: Mon, 5 Dec 2022 15:40:59 -0800

Make collapse_file roll back when copying pages failed. More concretely:
- extract copying operations into a separate loop
- postpone the updates for nr_none until both scanning and copying
  succeeded
- postpone joining small xarray entries until both scanning and copying
  succeeded
- postpone the update operations to NR_XXX_THPS until both scanning and
  copying succeeded
- for non-SHMEM file, roll back filemap_nr_thps_inc if scan succeeded but
  copying failed

Tested manually:
0. Enable khugepaged on system under test. Mount tmpfs at /mnt/ramdisk.
1. Start a two-thread application. Each thread allocates a chunk of
   non-huge memory buffer from /mnt/ramdisk.
2. Pick 4 random buffer address (2 in each thread) and inject
   uncorrectable memory errors at physical addresses.
3. Signal both threads to make their memory buffer collapsible, i.e.
   calling madvise(MADV_HUGEPAGE).
4. Wait and then check kernel log: khugepaged is able to recover from
   poisoned pages by skipping them.
5. Signal both threads to inspect their buffer contents and make sure no
   data corruption.

Link: https://lkml.kernel.org/r/20221205234059.42971-3-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <tongtiangen@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   78 ++++++++++++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 30 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-recover-from-poisoned-file-backed-memory
+++ a/mm/khugepaged.c
@@ -1839,6 +1839,9 @@ static int collapse_file(struct mm_struc
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *hpage;
+	struct page *page;
+	struct page *tmp;
+	struct folio *folio;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -1883,8 +1886,7 @@ static int collapse_file(struct mm_struc
 
 	xas_set(&xas, start);
 	for (index = start; index < end; index++) {
-		struct page *page = xas_next(&xas);
-		struct folio *folio;
+		page = xas_next(&xas);
 
 		VM_BUG_ON(index != xas.xa_index);
 		if (is_shmem) {
@@ -2066,10 +2068,7 @@ out_unlock:
 	}
 	nr = thp_nr_pages(hpage);
 
-	if (is_shmem)
-		__mod_lruvec_page_state(hpage, NR_SHMEM_THPS, nr);
-	else {
-		__mod_lruvec_page_state(hpage, NR_FILE_THPS, nr);
+	if (!is_shmem) {
 		filemap_nr_thps_inc(mapping);
 		/*
 		 * Paired with smp_mb() in do_dentry_open() to ensure
@@ -2080,21 +2079,10 @@ out_unlock:
 		smp_mb();
 		if (inode_is_open_for_write(mapping->host)) {
 			result = SCAN_FAIL;
-			__mod_lruvec_page_state(hpage, NR_FILE_THPS, -nr);
 			filemap_nr_thps_dec(mapping);
 			goto xa_locked;
 		}
 	}
-
-	if (nr_none) {
-		__mod_lruvec_page_state(hpage, NR_FILE_PAGES, nr_none);
-		/* nr_none is always 0 for non-shmem. */
-		__mod_lruvec_page_state(hpage, NR_SHMEM, nr_none);
-	}
-
-	/* Join all the small entries into a single multi-index entry */
-	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
-	xas_store(&xas, hpage);
 xa_locked:
 	xas_unlock_irq(&xas);
 xa_unlocked:
@@ -2107,21 +2095,35 @@ xa_unlocked:
 	try_to_unmap_flush();
 
 	if (result == SCAN_SUCCEED) {
-		struct page *page, *tmp;
-		struct folio *folio;
-
 		/*
 		 * Replacing old pages with new one has succeeded, now we
-		 * need to copy the content and free the old pages.
+		 * attempt to copy the contents.
 		 */
 		index = start;
-		list_for_each_entry_safe(page, tmp, &pagelist, lru) {
+		list_for_each_entry(page, &pagelist, lru) {
 			while (index < page->index) {
 				clear_highpage(hpage + (index % HPAGE_PMD_NR));
 				index++;
 			}
-			copy_highpage(hpage + (page->index % HPAGE_PMD_NR),
-				      page);
+			if (copy_mc_page(hpage + (page->index % HPAGE_PMD_NR),
+					 page) > 0) {
+				result = SCAN_COPY_MC;
+				break;
+			}
+			index++;
+		}
+		while (result == SCAN_SUCCEED && index < end) {
+			clear_highpage(hpage + (index % HPAGE_PMD_NR));
+			index++;
+		}
+	}
+
+	if (result == SCAN_SUCCEED) {
+		/*
+		 * Copying old pages to huge one has succeeded, now we
+		 * need to free the old pages.
+		 */
+		list_for_each_entry_safe(page, tmp, &pagelist, lru) {
 			list_del(&page->lru);
 			page->mapping = NULL;
 			page_ref_unfreeze(page, 1);
@@ -2129,12 +2131,23 @@ xa_unlocked:
 			ClearPageUnevictable(page);
 			unlock_page(page);
 			put_page(page);
-			index++;
 		}
-		while (index < end) {
-			clear_highpage(hpage + (index % HPAGE_PMD_NR));
-			index++;
+
+		xas_lock_irq(&xas);
+		if (is_shmem)
+			__mod_lruvec_page_state(hpage, NR_SHMEM_THPS, nr);
+		else
+			__mod_lruvec_page_state(hpage, NR_FILE_THPS, nr);
+
+		if (nr_none) {
+			__mod_lruvec_page_state(hpage, NR_FILE_PAGES, nr_none);
+			/* nr_none is always 0 for non-shmem. */
+			__mod_lruvec_page_state(hpage, NR_SHMEM, nr_none);
 		}
+		/* Join all the small entries into a single multi-index entry. */
+		xas_set_order(&xas, start, HPAGE_PMD_ORDER);
+		xas_store(&xas, hpage);
+		xas_unlock_irq(&xas);
 
 		folio = page_folio(hpage);
 		folio_mark_uptodate(folio);
@@ -2152,8 +2165,6 @@ xa_unlocked:
 		unlock_page(hpage);
 		hpage = NULL;
 	} else {
-		struct page *page;
-
 		/* Something went wrong: roll back page cache changes */
 		xas_lock_irq(&xas);
 		if (nr_none) {
@@ -2187,6 +2198,13 @@ xa_unlocked:
 			xas_lock_irq(&xas);
 		}
 		VM_BUG_ON(nr_none);
+		/*
+		 * Undo the updates of filemap_nr_thps_inc for non-SHMEM file only.
+		 * This undo is not needed unless failure is due to SCAN_COPY_MC.
+		 */
+		if (!is_shmem && result == SCAN_COPY_MC)
+			filemap_nr_thps_dec(mapping);
+
 		xas_unlock_irq(&xas);
 
 		hpage->mapping = NULL;
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-khugepaged-recover-from-poisoned-anonymous-memory.patch
mm-khugepaged-recover-from-poisoned-file-backed-memory.patch

