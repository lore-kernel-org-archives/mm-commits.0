Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93051C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbiEJEV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236076AbiEJEUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AEF2AD760
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45252B81B00
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E799BC385C2;
        Tue, 10 May 2022 04:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156116;
        bh=FHJsXhjHlUhoZZ1r6VC2OCifiZ+Jw3xZhvn6GoYbuqc=;
        h=Date:To:From:Subject:From;
        b=e2pVizn4xLyJkQAKfgXYB+2h7MSGdiseyQhJ01Ww/Ft7Tge7qRNEFLU+TWPbpYOfu
         GrYmZSFGtkMr00FL/ZjYhH/E6MXdzFmtD73AmpD7eErZe1uNqd5yEtYLbE9CE2LCjN
         IiS4cRxCbkZT0EdaYt7DjL48sj+Qf6b2vpmM3/f8=
Date:   Mon, 09 May 2022 21:15:15 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] doc-update-documentation-for-swap_activate-and-swap_rw.patch removed from -mm tree
Message-Id: <20220510041515.E799BC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: doc: update documentation for swap_activate and swap_rw
has been removed from the -mm tree.  Its filename was
     doc-update-documentation-for-swap_activate-and-swap_rw.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: doc: update documentation for swap_activate and swap_rw

This documentation for ->swap_activate() has been out-of-date for a long
time.  This patch updates it to match recent changes, and adds
documentation for the associated ->swap_rw()

Link: https://lkml.kernel.org/r/164859778126.29473.6778751233552859461.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: David Howells <dhowells@redhat.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/locking.rst |   18 ++++++++++++------
 Documentation/filesystems/vfs.rst     |   17 ++++++++++++-----
 2 files changed, 24 insertions(+), 11 deletions(-)

--- a/Documentation/filesystems/locking.rst~doc-update-documentation-for-swap_activate-and-swap_rw
+++ a/Documentation/filesystems/locking.rst
@@ -258,8 +258,9 @@ prototypes::
 	int (*launder_folio)(struct folio *);
 	bool (*is_partially_uptodate)(struct folio *, size_t from, size_t count);
 	int (*error_remove_page)(struct address_space *, struct page *);
-	int (*swap_activate)(struct file *);
+	int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
 	int (*swap_deactivate)(struct file *);
+	int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
 
 locking rules:
 	All except dirty_folio and freepage may block
@@ -287,6 +288,7 @@ is_partially_uptodate:	yes
 error_remove_page:	yes
 swap_activate:		no
 swap_deactivate:	no
+swap_rw:		yes, unlocks
 ======================	======================== =========	===============
 
 ->write_begin(), ->write_end() and ->readpage() may be called from
@@ -386,15 +388,19 @@ cleaned, or an error value if not. Note
 getting mapped back in and redirtied, it needs to be kept locked
 across the entire operation.
 
-->swap_activate will be called with a non-zero argument on
-files backing (non block device backed) swapfiles. A return value
-of zero indicates success, in which case this file can be used for
-backing swapspace. The swapspace operations will be proxied to the
-address space operations.
+->swap_activate() will be called to prepare the given file for swap.  It
+should perform any validation and preparation necessary to ensure that
+writes can be performed with minimal memory allocation.  It should call
+add_swap_extent(), or the helper iomap_swapfile_activate(), and return
+the number of extents added.  If IO should be submitted through
+->swap_rw(), it should set SWP_FS_OPS, otherwise IO will be submitted
+directly to the block device ``sis->bdev``.
 
 ->swap_deactivate() will be called in the sys_swapoff()
 path after ->swap_activate() returned success.
 
+->swap_rw will be called for swap IO if SWP_FS_OPS was set by ->swap_activate().
+
 file_lock_operations
 ====================
 
--- a/Documentation/filesystems/vfs.rst~doc-update-documentation-for-swap_activate-and-swap_rw
+++ a/Documentation/filesystems/vfs.rst
@@ -749,8 +749,9 @@ cache in your filesystem.  The following
 					       size_t count);
 		void (*is_dirty_writeback) (struct page *, bool *, bool *);
 		int (*error_remove_page) (struct mapping *mapping, struct page *page);
-		int (*swap_activate)(struct file *);
+		int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
 		int (*swap_deactivate)(struct file *);
+		int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
 	};
 
 ``writepage``
@@ -952,15 +953,21 @@ cache in your filesystem.  The following
 	unless you have them locked or reference counts increased.
 
 ``swap_activate``
-	Called when swapon is used on a file to allocate space if
-	necessary and pin the block lookup information in memory.  A
-	return value of zero indicates success, in which case this file
-	can be used to back swapspace.
+
+	Called to prepare the given file for swap.  It should perform
+	any validation and preparation necessary to ensure that writes
+	can be performed with minimal memory allocation.  It should call
+	add_swap_extent(), or the helper iomap_swapfile_activate(), and
+	return the number of extents added.  If IO should be submitted
+	through ->swap_rw(), it should set SWP_FS_OPS, otherwise IO will
+	be submitted directly to the block device ``sis->bdev``.
 
 ``swap_deactivate``
 	Called during swapoff on files where swap_activate was
 	successful.
 
+``swap_rw``
+	Called to read or write swap pages when SWP_FS_OPS is set.
 
 The File Object
 ===============
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

