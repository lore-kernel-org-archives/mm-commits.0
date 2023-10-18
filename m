Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90197CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbjJRVga (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbjJRVgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7F512E
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED707C433BB;
        Wed, 18 Oct 2023 21:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664910;
        bh=E05eKU6pTdLQoNEeU5yHlNlTLerBVanaibCkhndQjJE=;
        h=Date:To:From:Subject:From;
        b=netFTLRZ89DXkQzcfglA/hPZQVB0AD0vue49bJy5bn0UqMOQWU6o/dUIEEVm4Rd1A
         i5g1KU3grO5Ne/XBftE65JZLOkAIfYm+53jsSMXfKJWL4g1a3Jqw8PCCyzfjD5712n
         RElZWMJA/bIXDwAcawUAzSrgB71sooiCyww2tKaw=
Date:   Wed, 18 Oct 2023 14:35:09 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch removed from -mm tree
Message-Id: <20231018213509.ED707C433BB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make lock_folio_maybe_drop_mmap() VMA lock aware
has been removed from the -mm tree.  Its filename was
     mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make lock_folio_maybe_drop_mmap() VMA lock aware
Date: Fri, 6 Oct 2023 20:53:13 +0100

Patch series "Handle more faults under the VMA lock", v2.

At this point, we're handling the majority of file-backed page faults
under the VMA lock, using the ->map_pages entry point.  This patch set
attempts to expand that for the following siutations:

 - We have to do a read.  This could be because we've hit the point in
   the readahead window where we need to kick off the next readahead,
   or because the page is simply not present in cache.
 - We're handling a write fault.  Most applications don't do I/O by writes
   to shared mmaps for very good reasons, but some do, and it'd be nice
   to not make that slow unnecessarily.
 - We're doing a COW of a private mapping (both PTE already present
   and PTE not-present).  These are two different codepaths and I handle
   both of them in this patch set.

There is no support in this patch set for drivers to mark themselves as
being VMA lock friendly; they could implement the ->map_pages
vm_operation, but if they do, they would be the first.  This is probably
something we want to change at some point in the future, and I've marked
where to make that change in the code.

There is very little performance change in the benchmarks we've run;
mostly because the vast majority of page faults are handled through the
other paths.  I still think this patch series is useful for workloads that
may take these paths more often, and just for cleaning up the fault path
in general (it's now clearer why we have to retry in these cases).


This patch (of 6):

Drop the VMA lock instead of the mmap_lock if that's the one which
is held.

Link: https://lkml.kernel.org/r/20231006195318.4087158-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231006195318.4087158-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware
+++ a/mm/filemap.c
@@ -3090,7 +3090,7 @@ static int lock_folio_maybe_drop_mmap(st
 
 	/*
 	 * NOTE! This will make us return with VM_FAULT_RETRY, but with
-	 * the mmap_lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
+	 * the fault lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
 	 * is supposed to work. We have way too many special cases..
 	 */
 	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
@@ -3100,13 +3100,14 @@ static int lock_folio_maybe_drop_mmap(st
 	if (vmf->flags & FAULT_FLAG_KILLABLE) {
 		if (__folio_lock_killable(folio)) {
 			/*
-			 * We didn't have the right flags to drop the mmap_lock,
-			 * but all fault_handlers only check for fatal signals
-			 * if we return VM_FAULT_RETRY, so we need to drop the
-			 * mmap_lock here and return 0 if we don't have a fpin.
+			 * We didn't have the right flags to drop the
+			 * fault lock, but all fault_handlers only check
+			 * for fatal signals if we return VM_FAULT_RETRY,
+			 * so we need to drop the fault lock here and
+			 * return 0 if we don't have a fpin.
 			 */
 			if (*fpin == NULL)
-				mmap_read_unlock(vmf->vma->vm_mm);
+				release_fault_lock(vmf);
 			return 0;
 		}
 	} else
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch
mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers.patch
ext4-convert-to-folio_create_empty_buffers.patch
buffer-add-get_nth_bh.patch
gfs2-convert-inode-unstuffing-to-use-a-folio.patch
gfs2-convert-gfs2_getbuf-to-folios.patch
gfs2-convert-gfs2_getjdatabuf-to-use-a-folio.patch
gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_grab_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch
nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio.patch
nilfs2-remove-nilfs_page_get_nth_block.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers.patch
ntfs-convert-ntfs_read_block-to-use-a-folio.patch
ntfs-convert-ntfs_writepage-to-use-a-folio.patch
ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios.patch
ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio.patch
reiserfs-convert-writepage-to-use-a-folio.patch
ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio.patch
ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock.patch
ufs-convert-ufs_change_blocknr-to-use-folios.patch
ufs-remove-ufs_get_locked_page.patch
buffer-remove-folio_create_empty_buffers.patch

