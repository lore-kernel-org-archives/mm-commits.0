Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F617C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345790AbiCYBbV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357322AbiCYBbS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72762983A
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7428B6192F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B21C340ED;
        Fri, 25 Mar 2022 01:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171783;
        bh=qsKFKGu59mXrcjVRiwpm0q9hRGBtfRt3rQ4nCjVg3lM=;
        h=Date:To:From:Subject:From;
        b=kMVqInSK8Zpce98VHtMRuFaCJIyvcAY+CxTz6Bq6VniUS4UNTpgudiSpQBH/x32A9
         KsrEzm2tGMjj9ZPw9XwtoTq5EqfTtqNBz7DCiXmjTDtbClQw9v09ZwwEigu0KlqOVl
         STix5Sygd4gpRJmsA1T1kb09xgIaZBWmR6CK8334=
Date:   Thu, 24 Mar 2022 18:29:43 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        philipp.reisner@linbit.com, paolo.valente@linaro.org,
        miklos@szeredi.hu, lars.ellenberg@linbit.com,
        konishi.ryusuke@gmail.com, jlayton@kernel.org, jaegeuk@kernel.org,
        jack@suse.cz, idryomov@gmail.com, fengguang.wu@intel.com,
        djwong@kernel.org, chao@kernel.org, axboe@kernel.dk,
        Anna.Schumaker@Netapp.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-document-and-polish-read-ahead-code.patch removed from -mm tree
Message-Id: <20220325012943.C2B21C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document and polish read-ahead code
has been removed from the -mm tree.  Its filename was
     mm-document-and-polish-read-ahead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm: document and polish read-ahead code

Add some "big-picture" documentation for read-ahead and polish the code to
make it fit this documentation.

The meaning of ->async_size is clarified to match its name.  i.e.  Any
request to ->readahead() has a sync part and an async part.  The caller
will wait for the sync pages to complete, but will not wait for the async
pages.  The first async page is still marked PG_readahead

Note that the current function names page_cache_sync_ra() and
page_cache_async_ra() are misleading.  All ra request are partly sync and
partly async, so either part can be empty.  A page_cache_sync_ra() request
will usually set ->async_size non-zero, implying it is not all
synchronous.

When a non-zero req_count is passed to page_cache_async_ra(), the
implication is that some prefix of the request is synchronous, though the
calculation made there is incorrect - I haven't tried to fix it.

Link: https://lkml.kernel.org/r/164549983734.9187.11586890887006601405.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |   19 ++++-
 Documentation/filesystems/vfs.rst |   16 ++--
 include/linux/fs.h                |    9 +-
 mm/readahead.c                    |   99 ++++++++++++++++++++++++++++
 4 files changed, 133 insertions(+), 10 deletions(-)

--- a/Documentation/core-api/mm-api.rst~mm-document-and-polish-read-ahead-code
+++ a/Documentation/core-api/mm-api.rst
@@ -58,15 +58,30 @@ Virtually Contiguous Mappings
 File Mapping and Page Cache
 ===========================
 
-.. kernel-doc:: mm/readahead.c
-   :export:
+Filemap
+-------
 
 .. kernel-doc:: mm/filemap.c
    :export:
 
+Readahead
+---------
+
+.. kernel-doc:: mm/readahead.c
+   :doc: Readahead Overview
+
+.. kernel-doc:: mm/readahead.c
+   :export:
+
+Writeback
+---------
+
 .. kernel-doc:: mm/page-writeback.c
    :export:
 
+Truncate
+--------
+
 .. kernel-doc:: mm/truncate.c
    :export:
 
--- a/Documentation/filesystems/vfs.rst~mm-document-and-polish-read-ahead-code
+++ a/Documentation/filesystems/vfs.rst
@@ -806,12 +806,16 @@ cache in your filesystem.  The following
 	object.  The pages are consecutive in the page cache and are
 	locked.  The implementation should decrement the page refcount
 	after starting I/O on each page.  Usually the page will be
-	unlocked by the I/O completion handler.  If the filesystem decides
-	to stop attempting I/O before reaching the end of the readahead
-	window, it can simply return.  The caller will decrement the page
-	refcount and unlock the remaining pages for you.  Set PageUptodate
-	if the I/O completes successfully.  Setting PageError on any page
-	will be ignored; simply unlock the page if an I/O error occurs.
+	unlocked by the I/O completion handler.  The set of pages are
+	divided into some sync pages followed by some async pages,
+	rac->ra->async_size gives the number of async pages.  The
+	filesystem should attempt to read all sync pages but may decide
+	to stop once it reaches the async pages.  If it does decide to
+	stop attempting I/O, it can simply return.  The caller will
+	remove the remaining pages from the address space, unlock them
+	and decrement the page refcount.  Set PageUptodate if the I/O
+	completes successfully.  Setting PageError on any page will be
+	ignored; simply unlock the page if an I/O error occurs.
 
 ``readpages``
 	called by the VM to read pages associated with the address_space
--- a/include/linux/fs.h~mm-document-and-polish-read-ahead-code
+++ a/include/linux/fs.h
@@ -930,10 +930,15 @@ struct fown_struct {
  * struct file_ra_state - Track a file's readahead state.
  * @start: Where the most recent readahead started.
  * @size: Number of pages read in the most recent readahead.
- * @async_size: Start next readahead when this many pages are left.
- * @ra_pages: Maximum size of a readahead request.
+ * @async_size: Numer of pages that were/are not needed immediately
+ *      and so were/are genuinely "ahead".  Start next readahead when
+ *      the first of these pages is accessed.
+ * @ra_pages: Maximum size of a readahead request, copied from the bdi.
  * @mmap_miss: How many mmap accesses missed in the page cache.
  * @prev_pos: The last byte in the most recent read request.
+ *
+ * When this structure is passed to ->readahead(), the "most recent"
+ * readahead means the current readahead.
  */
 struct file_ra_state {
 	pgoff_t start;
--- a/mm/readahead.c~mm-document-and-polish-read-ahead-code
+++ a/mm/readahead.c
@@ -8,6 +8,105 @@
  *		Initial version.
  */
 
+/**
+ * DOC: Readahead Overview
+ *
+ * Readahead is used to read content into the page cache before it is
+ * explicitly requested by the application.  Readahead only ever
+ * attempts to read pages that are not yet in the page cache.  If a
+ * page is present but not up-to-date, readahead will not try to read
+ * it. In that case a simple ->readpage() will be requested.
+ *
+ * Readahead is triggered when an application read request (whether a
+ * systemcall or a page fault) finds that the requested page is not in
+ * the page cache, or that it is in the page cache and has the
+ * %PG_readahead flag set.  This flag indicates that the page was loaded
+ * as part of a previous read-ahead request and now that it has been
+ * accessed, it is time for the next read-ahead.
+ *
+ * Each readahead request is partly synchronous read, and partly async
+ * read-ahead.  This is reflected in the struct file_ra_state which
+ * contains ->size being to total number of pages, and ->async_size
+ * which is the number of pages in the async section.  The first page in
+ * this async section will have %PG_readahead set as a trigger for a
+ * subsequent read ahead.  Once a series of sequential reads has been
+ * established, there should be no need for a synchronous component and
+ * all read ahead request will be fully asynchronous.
+ *
+ * When either of the triggers causes a readahead, three numbers need to
+ * be determined: the start of the region, the size of the region, and
+ * the size of the async tail.
+ *
+ * The start of the region is simply the first page address at or after
+ * the accessed address, which is not currently populated in the page
+ * cache.  This is found with a simple search in the page cache.
+ *
+ * The size of the async tail is determined by subtracting the size that
+ * was explicitly requested from the determined request size, unless
+ * this would be less than zero - then zero is used.  NOTE THIS
+ * CALCULATION IS WRONG WHEN THE START OF THE REGION IS NOT THE ACCESSED
+ * PAGE.
+ *
+ * The size of the region is normally determined from the size of the
+ * previous readahead which loaded the preceding pages.  This may be
+ * discovered from the struct file_ra_state for simple sequential reads,
+ * or from examining the state of the page cache when multiple
+ * sequential reads are interleaved.  Specifically: where the readahead
+ * was triggered by the %PG_readahead flag, the size of the previous
+ * readahead is assumed to be the number of pages from the triggering
+ * page to the start of the new readahead.  In these cases, the size of
+ * the previous readahead is scaled, often doubled, for the new
+ * readahead, though see get_next_ra_size() for details.
+ *
+ * If the size of the previous read cannot be determined, the number of
+ * preceding pages in the page cache is used to estimate the size of
+ * a previous read.  This estimate could easily be misled by random
+ * reads being coincidentally adjacent, so it is ignored unless it is
+ * larger than the current request, and it is not scaled up, unless it
+ * is at the start of file.
+ *
+ * In general read ahead is accelerated at the start of the file, as
+ * reads from there are often sequential.  There are other minor
+ * adjustments to the read ahead size in various special cases and these
+ * are best discovered by reading the code.
+ *
+ * The above calculation determines the readahead, to which any requested
+ * read size may be added.
+ *
+ * Readahead requests are sent to the filesystem using the ->readahead()
+ * address space operation, for which mpage_readahead() is a canonical
+ * implementation.  ->readahead() should normally initiate reads on all
+ * pages, but may fail to read any or all pages without causing an IO
+ * error.  The page cache reading code will issue a ->readpage() request
+ * for any page which ->readahead() does not provided, and only an error
+ * from this will be final.
+ *
+ * ->readahead() will generally call readahead_page() repeatedly to get
+ * each page from those prepared for read ahead.  It may fail to read a
+ * page by:
+ *
+ * * not calling readahead_page() sufficiently many times, effectively
+ *   ignoring some pages, as might be appropriate if the path to
+ *   storage is congested.
+ *
+ * * failing to actually submit a read request for a given page,
+ *   possibly due to insufficient resources, or
+ *
+ * * getting an error during subsequent processing of a request.
+ *
+ * In the last two cases, the page should be unlocked to indicate that
+ * the read attempt has failed.  In the first case the page will be
+ * unlocked by the caller.
+ *
+ * Those pages not in the final ``async_size`` of the request should be
+ * considered to be important and ->readahead() should not fail them due
+ * to congestion or temporary resource unavailability, but should wait
+ * for necessary resources (e.g.  memory or indexing information) to
+ * become available.  Pages in the final ``async_size`` may be
+ * considered less urgent and failure to read them is more acceptable.
+ * They will eventually be read individually using ->readpage().
+ */
+
 #include <linux/kernel.h>
 #include <linux/dax.h>
 #include <linux/gfp.h>
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

