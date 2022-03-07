Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A26C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 00:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbiCGBAo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbiCGBAo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 20:00:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C654265C7
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 16:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E423B80F88
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 00:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFD9C340EC;
        Mon,  7 Mar 2022 00:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646614788;
        bh=0Fj+7a7VYCkMfLbgq9/YsgFk5+EYKi0xZTQMHkADpNs=;
        h=Date:To:From:Subject:From;
        b=03OfQIZCI1VBn19AOdx9LucQAJwhb5UbnNeePexS+6VuYh2P18cvlbDwu8ZsA56H2
         H8FkMJKxuKe24MmAxBDdmkj7aPlA5sMwFU3mwCCg8Dhdl2b90t3q2XHbf0Y7q3YWFX
         lW9IXxkB8OTBFYfoQrZ7AshgYVOWXzUy9/Ezq7wQ=
Date:   Sun, 06 Mar 2022 16:59:47 -0800
To:     mm-commits@vger.kernel.org, zkabelac@redhat.com,
        mpatocka@redhat.com, miklos@szeredi.hu, lczerner@redhat.com,
        hch@lst.de, djwong@kernel.org, bp@suse.de, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-do-not-allocate-pages-on-read.patch added to -mm tree
Message-Id: <20220307005948.0DFD9C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: do not allocate pages on read
has been added to the -mm tree.  Its filename is
     tmpfs-do-not-allocate-pages-on-read.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tmpfs-do-not-allocate-pages-on-read.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-do-not-allocate-pages-on-read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: do not allocate pages on read

Mikulas asked in
https://lore.kernel.org/linux-mm/alpine.LRH.2.02.2007210510230.6959@file01.intranet.prod.int.rdu2.redhat.com/
Do we still need a0ee5ec520ed ("tmpfs: allocate on read when stacked")?

Lukas noticed this unusual behavior of loop device backed by tmpfs in
https://lore.kernel.org/linux-mm/20211126075100.gd64odg2bcptiqeb@work/

Normally, shmem_file_read_iter() copies the ZERO_PAGE when reading holes;
but if it looks like it might be a read for "a stacking filesystem", it
allocates actual pages to the page cache, and even marks them as dirty. 
And reads from the loop device do satisfy the test that is used.

This oddity was added for an old version of unionfs, to help to limit its
usage to the limited size of the tmpfs mount involved; but about the same
time as the tmpfs mod went in (2.6.25), unionfs was reworked to proceed
differently; and the mod kept just in case others needed it.

Do we still need it?  I cannot answer with more certainty than "Probably
not".  It's nasty enough that we really should try to delete it; but if a
regression is reported somewhere, then we might have to revert later.

It's not quite as simple as just removing the test (as Mikulas did):
xfstests generic/013 hung because splice from tmpfs failed on page not
up-to-date and page mapping unset.  That can be fixed just by marking the
ZERO_PAGE as Uptodate, which of course it is: do so in pagecache_init() -
it might be useful to others than tmpfs.

My intention, though, was to stop using the ZERO_PAGE here altogether:
surely iov_iter_zero() is better for this case?  Sadly not: it relies on
clear_user(), and the x86 clear_user() is slower than its copy_user():
https://lore.kernel.org/lkml/2f5ca5e4-e250-a41c-11fb-a7f4ebc7e1c9@google.com/

But while we are still using the ZERO_PAGE, let's stop dirtying its struct
page cacheline with unnecessary get_page() and put_page().

Link: https://lkml.kernel.org/r/90bc5e69-9984-b5fa-a685-be55f2b64b@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Zdenek Kabelac <zkabelac@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ++++++
 mm/shmem.c   |   20 ++++++--------------
 2 files changed, 12 insertions(+), 14 deletions(-)

--- a/mm/filemap.c~tmpfs-do-not-allocate-pages-on-read
+++ a/mm/filemap.c
@@ -1054,6 +1054,12 @@ void __init pagecache_init(void)
 		init_waitqueue_head(&folio_wait_table[i]);
 
 	page_writeback_init();
+
+	/*
+	 * tmpfs uses the ZERO_PAGE for reading holes: it is up-to-date,
+	 * and splice's page_cache_pipe_buf_confirm() needs to see that.
+	 */
+	SetPageUptodate(ZERO_PAGE(0));
 }
 
 /*
--- a/mm/shmem.c~tmpfs-do-not-allocate-pages-on-read
+++ a/mm/shmem.c
@@ -2499,19 +2499,10 @@ static ssize_t shmem_file_read_iter(stru
 	struct address_space *mapping = inode->i_mapping;
 	pgoff_t index;
 	unsigned long offset;
-	enum sgp_type sgp = SGP_READ;
 	int error = 0;
 	ssize_t retval = 0;
 	loff_t *ppos = &iocb->ki_pos;
 
-	/*
-	 * Might this read be for a stacking filesystem?  Then when reading
-	 * holes of a sparse file, we actually need to allocate those pages,
-	 * and even mark them dirty, so it cannot exceed the max_blocks limit.
-	 */
-	if (!iter_is_iovec(to))
-		sgp = SGP_CACHE;
-
 	index = *ppos >> PAGE_SHIFT;
 	offset = *ppos & ~PAGE_MASK;
 
@@ -2520,6 +2511,7 @@ static ssize_t shmem_file_read_iter(stru
 		pgoff_t end_index;
 		unsigned long nr, ret;
 		loff_t i_size = i_size_read(inode);
+		bool got_page;
 
 		end_index = i_size >> PAGE_SHIFT;
 		if (index > end_index)
@@ -2530,15 +2522,13 @@ static ssize_t shmem_file_read_iter(stru
 				break;
 		}
 
-		error = shmem_getpage(inode, index, &page, sgp);
+		error = shmem_getpage(inode, index, &page, SGP_READ);
 		if (error) {
 			if (error == -EINVAL)
 				error = 0;
 			break;
 		}
 		if (page) {
-			if (sgp == SGP_CACHE)
-				set_page_dirty(page);
 			unlock_page(page);
 
 			if (PageHWPoison(page)) {
@@ -2578,9 +2568,10 @@ static ssize_t shmem_file_read_iter(stru
 			 */
 			if (!offset)
 				mark_page_accessed(page);
+			got_page = true;
 		} else {
 			page = ZERO_PAGE(0);
-			get_page(page);
+			got_page = false;
 		}
 
 		/*
@@ -2593,7 +2584,8 @@ static ssize_t shmem_file_read_iter(stru
 		index += offset >> PAGE_SHIFT;
 		offset &= ~PAGE_MASK;
 
-		put_page(page);
+		if (got_page)
+			put_page(page);
 		if (!iov_iter_count(to))
 			break;
 		if (ret < nr) {
_

Patches currently in -mm which might be from hughd@google.com are

mm-fs-delete-pf_swapwrite.patch
mm-__isolate_lru_page_prepare-in-isolate_migratepages_block.patch
tmpfs-support-for-file-creation-time-fix.patch
shmem-mapping_set_exiting-to-help-mapped-resilience.patch
tmpfs-do-not-allocate-pages-on-read.patch
mm-_install_special_mapping-apply-vm_locked_clear_mask.patch
mempolicy-mbind_range-set_policy-after-vma_merge.patch
mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch
mm-delete-__clearpagewaiters.patch
mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch
mm-warn-on-deleting-redirtied-only-if-accounted.patch
mm-unmap_mapping_range_tree-with-i_mmap_rwsem-shared.patch

