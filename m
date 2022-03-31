Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33D0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiCaETw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiCaESl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:18:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203FCBF966
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56D2760C60
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 02:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6693C34110;
        Thu, 31 Mar 2022 02:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648695383;
        bh=EjNoRuO5OuVNcz3Bou+eM1ijjE4XdPHy1XWBVWysHss=;
        h=Date:To:From:Subject:From;
        b=dBftaSJWg7s2dYtdtGKL5Bnr72f2FOaW24gQE7OT1Gy1Pjfp0E52/OEQa09UjCzPM
         zv4BZi2A8en+YsANrJfI7Ff5pLqkYz6byCplpxPfpMrC5GkRq0TOZL8WfIL4aX2MRR
         LDMOFIallB06FxRD8Kv/VjeKMH27RFCpR6lUB2vo=
Date:   Wed, 30 Mar 2022 19:56:23 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, hughd@google.com, hch@lst.de,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-update-documentation-for-swap_activate-and-swap_rw.patch added to -mm tree
Message-Id: <20220331025623.A6693C34110@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc: update documentation for swap_activate and swap_rw
has been added to the -mm tree.  Its filename is
     doc-update-documentation-for-swap_activate-and-swap_rw.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/doc-update-documentation-for-swap_activate-and-swap_rw.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/doc-update-documentation-for-swap_activate-and-swap_rw.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: doc: update documentation for swap_activate and swap_rw

This documentation for ->swap_activate() has been out-of-date for a long
time.  This patch updates it to match recent changes, and adds
documentation for the associated ->swap_rw()

Link: https://lkml.kernel.org/r/164859778126.29473.6778751233552859461.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/locking.rst |   18 ++++++++++++------
 Documentation/filesystems/vfs.rst     |   17 ++++++++++++-----
 2 files changed, 24 insertions(+), 11 deletions(-)

--- a/Documentation/filesystems/locking.rst~doc-update-documentation-for-swap_activate-and-swap_rw
+++ a/Documentation/filesystems/locking.rst
@@ -260,8 +260,9 @@ prototypes::
 	int (*launder_folio)(struct folio *);
 	bool (*is_partially_uptodate)(struct folio *, size_t from, size_t count);
 	int (*error_remove_page)(struct address_space *, struct page *);
-	int (*swap_activate)(struct file *);
+	int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
 	int (*swap_deactivate)(struct file *);
+	int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
 
 locking rules:
 	All except dirty_folio and freepage may block
@@ -290,6 +291,7 @@ is_partially_uptodate:	yes
 error_remove_page:	yes
 swap_activate:		no
 swap_deactivate:	no
+swap_rw:		yes, unlocks
 ======================	======================== =========	===============
 
 ->write_begin(), ->write_end() and ->readpage() may be called from
@@ -392,15 +394,19 @@ cleaned, or an error value if not. Note
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
@@ -751,8 +751,9 @@ cache in your filesystem.  The following
 					       size_t count);
 		void (*is_dirty_writeback) (struct page *, bool *, bool *);
 		int (*error_remove_page) (struct mapping *mapping, struct page *page);
-		int (*swap_activate)(struct file *);
+		int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
 		int (*swap_deactivate)(struct file *);
+		int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
 	};
 
 ``writepage``
@@ -963,15 +964,21 @@ cache in your filesystem.  The following
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

mm-create-new-mm-swaph-header-file.patch
mm-drop-swap_dirty_folio.patch
mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch
mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch
mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space.patch
mm-perform-async-writes-to-swp_fs_ops-swap-space-using-swap_rw.patch
doc-update-documentation-for-swap_activate-and-swap_rw.patch
mm-submit-multipage-reads-for-swp_fs_ops-swap-space.patch
mm-submit-multipage-write-for-swp_fs_ops-swap-space.patch
vfs-add-fmode_can_odirect-file-flag.patch
mm-discard-__gfp_atomic.patch

