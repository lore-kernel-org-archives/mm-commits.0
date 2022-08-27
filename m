Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E60C0502A
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 03:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243634AbiH0D3L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 23:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244615AbiH0D2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 23:28:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF78A8958
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 20:28:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A18AB83388
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 03:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12635C433C1;
        Sat, 27 Aug 2022 03:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661570930;
        bh=k8k4nIleAaIOqMCI08mEctg/gedjRhdN0LskXFfdo7o=;
        h=Date:To:From:Subject:From;
        b=fYNhiaYSgZASFdt8Z1tyqL/sHrQ8NHWFsuLNA3aNXYuGf6dRPEhDa2dFR1l5sVQvI
         kIwXvi6DXjPY1Kn6ObMQqJW+p//ocNM7yirZ8BD5DntrpJOwhBE8INnXdWh9ghdnwk
         Mrh6rl1h67biHk/4rxk/cZL6oNW1l62cu+ECU7s0=
Date:   Fri, 26 Aug 2022 20:28:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, konishi.ryusuke@gmail.com,
        josef@toxicpanda.com, dsterb@suse.com, dsterba@suse.com,
        clm@fb.com, vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ramfs-convert-ramfs_nommu_get_unmapped_area-to-use-filemap_get_folios_contig.patch added to mm-unstable branch
Message-Id: <20220827032850.12635C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ramfs: convert ramfs_nommu_get_unmapped_area() to use filemap_get_folios_contig()
has been added to the -mm mm-unstable branch.  Its filename is
     ramfs-convert-ramfs_nommu_get_unmapped_area-to-use-filemap_get_folios_contig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ramfs-convert-ramfs_nommu_get_unmapped_area-to-use-filemap_get_folios_contig.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: ramfs: convert ramfs_nommu_get_unmapped_area() to use filemap_get_folios_contig()
Date: Tue, 23 Aug 2022 17:40:22 -0700

Convert to use folios throughout.  This is in preparation for the removal
for find_get_pages_contig().  Now also supports large folios.

The initial version of this function set the page_address to be returned
after finishing all the checks.  Since folio_batches have a maximum of 15
folios, the function had to be modified to support getting and checking up
to lpages, 15 pages at a time while still returning the initial page
address.  Now the function sets ret as soon as the first batch arrives,
and updates it only if a check fails.

The physical adjacency check utilizes the page frame numbers.  The page
frame number of each folio must be nr_pages away from the first folio.

Link: https://lkml.kernel.org/r/20220824004023.77310-7-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: David Sterba <dsterb@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |   54 ++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

--- a/fs/ramfs/file-nommu.c~ramfs-convert-ramfs_nommu_get_unmapped_area-to-use-filemap_get_folios_contig
+++ a/fs/ramfs/file-nommu.c
@@ -203,9 +203,9 @@ static unsigned long ramfs_nommu_get_unm
 					    unsigned long addr, unsigned long len,
 					    unsigned long pgoff, unsigned long flags)
 {
-	unsigned long maxpages, lpages, nr, loop, ret;
+	unsigned long maxpages, lpages, nr_folios, loop, ret, nr_pages, pfn;
 	struct inode *inode = file_inode(file);
-	struct page **pages = NULL, **ptr, *page;
+	struct folio_batch fbatch;
 	loff_t isize;
 
 	/* the mapping mustn't extend beyond the EOF */
@@ -221,31 +221,39 @@ static unsigned long ramfs_nommu_get_unm
 		goto out;
 
 	/* gang-find the pages */
-	pages = kcalloc(lpages, sizeof(struct page *), GFP_KERNEL);
-	if (!pages)
-		goto out_free;
-
-	nr = find_get_pages_contig(inode->i_mapping, pgoff, lpages, pages);
-	if (nr != lpages)
-		goto out_free_pages; /* leave if some pages were missing */
-
+	folio_batch_init(&fbatch);
+	nr_pages = 0;
+repeat:
+	nr_folios = filemap_get_folios_contig(inode->i_mapping, &pgoff,
+			ULONG_MAX, &fbatch);
+	if (!nr_folios) {
+		ret = -ENOSYS;
+		return ret;
+	}
+
+	if (ret == -ENOSYS) {
+		ret = (unsigned long) folio_address(fbatch.folios[0]);
+		pfn = folio_pfn(fbatch.folios[0]);
+	}
 	/* check the pages for physical adjacency */
-	ptr = pages;
-	page = *ptr++;
-	page++;
-	for (loop = lpages; loop > 1; loop--)
-		if (*ptr++ != page++)
-			goto out_free_pages;
-
+	for (loop = 0; loop < nr_folios; loop++) {
+		if (pfn + nr_pages != folio_pfn(fbatch.folios[loop])) {
+			ret = -ENOSYS;
+			goto out_free; /* leave if not physical adjacent */
+		}
+		nr_pages += folio_nr_pages(fbatch.folios[loop]);
+		if (nr_pages >= lpages)
+			goto out_free; /* successfully found desired pages*/
+	}
+
+	if (nr_pages < lpages) {
+		folio_batch_release(&fbatch);
+		goto repeat; /* loop if pages are missing */
+	}
 	/* okay - all conditions fulfilled */
-	ret = (unsigned long) page_address(pages[0]);
 
-out_free_pages:
-	ptr = pages;
-	for (loop = nr; loop > 0; loop--)
-		put_page(*ptr++);
 out_free:
-	kfree(pages);
+	folio_batch_release(&fbatch);
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

filemap-add-filemap_get_folios_contig.patch
btrfs-convert-__process_pages_contig-to-use-filemap_get_folios_contig.patch
btrfs-convert-end_compressed_writeback-to-use-filemap_get_folios.patch
btrfs-convert-process_page_range-to-use-filemap_get_folios_contig.patch
nilfs2-convert-nilfs_find_uncommited_extent-to-use-filemap_get_folios_contig.patch
ramfs-convert-ramfs_nommu_get_unmapped_area-to-use-filemap_get_folios_contig.patch
filemap-remove-find_get_pages_contig.patch

