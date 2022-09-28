Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8957C32771
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 17:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbiI1ROd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 13:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234649AbiI1ROD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 13:14:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7CAF193C
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 10:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 078E9B81E78
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 17:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565B9C433B5;
        Wed, 28 Sep 2022 17:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664385199;
        bh=Rd9AurXu/OlcyCBEy/KnsUX+nEhIe19cfXmKnjpGVBg=;
        h=Date:To:From:Subject:From;
        b=HCHt07fQ4qxkeFy9TW1W9ohHkel2RQUwVSyJeSloLl9BzhJbKJlR8ifZW/SfkhtxF
         5lrW9FOezalG0pQPBj0UOfwZHnboZZfpBuoaRG4nQ0cJCu9cxVG/fFmQqQXajlrmrR
         vuIad4t6Q5lUENwG4UXUoozlEZgr3dXGJL9UCqZ0=
Date:   Wed, 28 Sep 2022 10:13:11 -0700
To:     mm-commits@vger.kernel.org, xiang@kernel.org, willy@infradead.org,
        surenb@google.com, josef@toxicpanda.com,
        hsiangkao@linux.alibaba.com, hannes@cmpxchg.org, dsterba@suse.com,
        clm@fb.com, chao@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-add-psi-accounting-around-read_folio-and-readahead-calls.patch removed from -mm tree
Message-Id: <20220928171319.565B9C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add PSI accounting around ->read_folio and ->readahead calls
has been removed from the -mm tree.  Its filename was
     mm-add-psi-accounting-around-read_folio-and-readahead-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: add PSI accounting around ->read_folio and ->readahead calls
Date: Thu, 15 Sep 2022 10:41:56 +0100

Patch series "improve pagecache PSI annotations", v2.

Currently the VM tries to abuse the block layer submission path for the
page cache PSI annotations.  This series instead annotates the
->read_folio and ->readahead calls in the core VM code, and then only
deals with the odd direct add_to_page_cache_lru calls manually.


This patch (of 5):

PSI tries to account for the cost of bringing back in pages discarded by
the MM LRU management.  Currently the prime place for that is hooked into
the bio submission path, which is a rather bad place:

 - it does not actually account I/O for non-block file systems, of which
   we have many
 - it adds overhead and a layering violation to the block layer

Add the accounting into the two places in the core MM code that read pages
into an address space by calling into ->read_folio and ->readahead so that
the entire file system operations are covered, to broaden the coverage and
allow removing the accounting in the block layer going forward.

As psi_memstall_enter can deal with nested calls this will not lead to
double accounting even while the bio annotations are still present.

Link: https://lkml.kernel.org/r/20220915094200.139713-1-hch@lst.de
Link: https://lkml.kernel.org/r/20220915094200.139713-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 ++
 mm/filemap.c            |    7 +++++++
 mm/readahead.c          |   22 ++++++++++++++++++----
 3 files changed, 27 insertions(+), 4 deletions(-)

--- a/include/linux/pagemap.h~mm-add-psi-accounting-around-read_folio-and-readahead-calls
+++ a/include/linux/pagemap.h
@@ -1169,6 +1169,8 @@ struct readahead_control {
 	pgoff_t _index;
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
+	bool _workingset;
+	unsigned long _pflags;
 };
 
 #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
--- a/mm/filemap.c~mm-add-psi-accounting-around-read_folio-and-readahead-calls
+++ a/mm/filemap.c
@@ -2390,6 +2390,8 @@ retry:
 static int filemap_read_folio(struct file *file, filler_t filler,
 		struct folio *folio)
 {
+	bool workingset = folio_test_workingset(folio);
+	unsigned long pflags;
 	int error;
 
 	/*
@@ -2398,8 +2400,13 @@ static int filemap_read_folio(struct fil
 	 * fails.
 	 */
 	folio_clear_error(folio);
+
 	/* Start the actual read. The read will unlock the page. */
+	if (unlikely(workingset))
+		psi_memstall_enter(&pflags);
 	error = filler(file, folio);
+	if (unlikely(workingset))
+		psi_memstall_leave(&pflags);
 	if (error)
 		return error;
 
--- a/mm/readahead.c~mm-add-psi-accounting-around-read_folio-and-readahead-calls
+++ a/mm/readahead.c
@@ -122,6 +122,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
+#include <linux/psi.h>
 #include <linux/syscalls.h>
 #include <linux/file.h>
 #include <linux/mm_inline.h>
@@ -152,6 +153,8 @@ static void read_pages(struct readahead_
 	if (!readahead_count(rac))
 		return;
 
+	if (unlikely(rac->_workingset))
+		psi_memstall_enter(&rac->_pflags);
 	blk_start_plug(&plug);
 
 	if (aops->readahead) {
@@ -179,6 +182,9 @@ static void read_pages(struct readahead_
 	}
 
 	blk_finish_plug(&plug);
+	if (unlikely(rac->_workingset))
+		psi_memstall_leave(&rac->_pflags);
+	rac->_workingset = false;
 
 	BUG_ON(readahead_count(rac));
 }
@@ -252,6 +258,7 @@ void page_cache_ra_unbounded(struct read
 		}
 		if (i == nr_to_read - lookahead_size)
 			folio_set_readahead(folio);
+		ractl->_workingset |= folio_test_workingset(folio);
 		ractl->_nr_pages++;
 	}
 
@@ -480,11 +487,14 @@ static inline int ra_alloc_folio(struct
 	if (index == mark)
 		folio_set_readahead(folio);
 	err = filemap_add_folio(ractl->mapping, folio, index, gfp);
-	if (err)
+	if (err) {
 		folio_put(folio);
-	else
-		ractl->_nr_pages += 1UL << order;
-	return err;
+		return err;
+	}
+
+	ractl->_nr_pages += 1UL << order;
+	ractl->_workingset |= folio_test_workingset(folio);
+	return 0;
 }
 
 void page_cache_ra_order(struct readahead_control *ractl,
@@ -826,6 +836,10 @@ void readahead_expand(struct readahead_c
 			put_page(page);
 			return;
 		}
+		if (unlikely(PageWorkingset(page)) && !ractl->_workingset) {
+			ractl->_workingset = true;
+			psi_memstall_enter(&ractl->_pflags);
+		}
 		ractl->_nr_pages++;
 		if (ra) {
 			ra->size++;
_

Patches currently in -mm which might be from hch@lst.de are

sched-psi-export-psi_memstall_enterleave.patch
btrfs-add-manual-psi-accounting-for-compressed-reads.patch
erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch
block-remove-psi-accounting-from-the-bio-layer.patch

