Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869CAC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  7 Nov 2022 20:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiKGUxr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Nov 2022 15:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiKGUxq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2022 15:53:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14328B01
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 12:53:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 965E0612E7
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 20:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA75AC433C1;
        Mon,  7 Nov 2022 20:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667854424;
        bh=Igu+TgBTrIp4QqJj2xvO+HsNafbLuj7p44jHLulUSqI=;
        h=Date:To:From:Subject:From;
        b=UYNx+UF3TBkSl4wXvi2LCWLrUh9OYgRvfWSYRs3sEXFZDJLHDFNeAslZ3ZVdMe8Mh
         uTrrWiIXAJ8+kazgRC9amXHyqrnUf+UUsHeQrZSOfkYYuaXyyOzr7JMEWqa6Dqn6yJ
         GfwdYS2MPB+MefJbtfzcA8lG16Edl1QwK1N9EFIU=
Date:   Mon, 07 Nov 2022 12:53:43 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        tongtiangen@huawei.com, shy828301@gmail.com, osalvador@suse.de,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-recover-from-poisoned-file-backed-memory.patch added to mm-unstable branch
Message-Id: <20221107205343.EA75AC433C1@smtp.kernel.org>
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
Date: Sun, 6 Nov 2022 18:53:59 -0800

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
5. Signal both thread to inspect their buffer contents and make sure no
   data corruption.

Link: https://lkml.kernel.org/r/20221107025359.2911028-3-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tong Tiangen <tongtiangen@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   74 +++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 29 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-recover-from-poisoned-file-backed-memory
+++ a/mm/khugepaged.c
@@ -1769,7 +1769,7 @@ static int collapse_file(struct mm_struc
 			 struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
-	struct page *hpage;
+	struct page *hpage, *page, *tmp;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -1814,7 +1814,7 @@ static int collapse_file(struct mm_struc
 
 	xas_set(&xas, start);
 	for (index = start; index < end; index++) {
-		struct page *page = xas_next(&xas);
+		page = xas_next(&xas);
 
 		VM_BUG_ON(index != xas.xa_index);
 		if (is_shmem) {
@@ -1996,10 +1996,7 @@ out_unlock:
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
@@ -2010,21 +2007,10 @@ out_unlock:
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
@@ -2037,20 +2023,34 @@ xa_unlocked:
 	try_to_unmap_flush();
 
 	if (result == SCAN_SUCCEED) {
-		struct page *page, *tmp;
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
+			if (copy_highpage_mc(hpage + (page->index % HPAGE_PMD_NR), page)) {
+				result = SCAN_COPY_MC;
+				break;
+			}
+			index++;
+		}
+		while (result == SCAN_SUCCEED && index < end) {
+			clear_highpage(hpage + (page->index % HPAGE_PMD_NR));
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
@@ -2058,12 +2058,23 @@ xa_unlocked:
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
 
 		SetPageUptodate(hpage);
 		page_ref_add(hpage, HPAGE_PMD_NR - 1);
@@ -2079,8 +2090,6 @@ xa_unlocked:
 		unlock_page(hpage);
 		hpage = NULL;
 	} else {
-		struct page *page;
-
 		/* Something went wrong: roll back page cache changes */
 		xas_lock_irq(&xas);
 		if (nr_none) {
@@ -2114,6 +2123,13 @@ xa_unlocked:
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

