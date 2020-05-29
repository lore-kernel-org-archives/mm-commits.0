From: akpm@linux-foundation.org
Subject: + mm-remove-misleading-comment.patch added to -mm tree
Date: Fri, 29 May 2020 11:24:01 -0700
Message-ID: <20200529182401.sQtBULwir%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgE2SYC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 May 2020 14:24:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/filemap.c: remove misleading comment
has been added to the -mm tree.  Its filename is
     mm-remove-misleading-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-misleading-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-misleading-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap.c: remove misleading comment

We no longer return 0 here and the comment doesn't tell us anything that
we don't already know (SIGBUS is a pretty good indicator that things
didn't work out).

Link: http://lkml.kernel.org/r/20200529123243.20640-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/filemap.c~mm-remove-misleading-comment
+++ a/mm/filemap.c
@@ -2566,7 +2566,6 @@ page_not_uptodate:
 	if (!error || error == AOP_TRUNCATED_PAGE)
 		goto retry_find;
 
-	/* Things didn't work out. Return zero to tell the mm layer so. */
 	shrink_readahead_size_eio(ra);
 	return VM_FAULT_SIGBUS;
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-move-readahead-prototypes-from-mmh.patch
mm-return-void-from-various-readahead-functions.patch
mm-ignore-return-value-of-readpages.patch
mm-move-readahead-nr_pages-check-into-read_pages.patch
mm-add-new-readahead_control-api.patch
mm-use-readahead_control-to-pass-arguments.patch
mm-rename-various-offset-parameters-to-index.patch
mm-rename-readahead-loop-variable-to-i.patch
mm-remove-page_offset-from-readahead-loop.patch
mm-put-readahead-pages-in-cache-earlier.patch
mm-add-readahead-address-space-operation.patch
mm-move-end_index-check-out-of-readahead-loop.patch
mm-add-page_cache_readahead_unbounded.patch
mm-document-why-we-dont-set-pagereadahead.patch
mm-use-memalloc_nofs_save-in-readahead-path.patch
fs-convert-mpage_readpages-to-mpage_readahead.patch
btrfs-convert-from-readpages-to-readahead.patch
erofs-convert-uncompressed-files-from-readpages-to-readahead.patch
erofs-convert-compressed-files-from-readpages-to-readahead.patch
ext4-convert-from-readpages-to-readahead.patch
ext4-pass-the-inode-to-ext4_mpage_readpages.patch
f2fs-convert-from-readpages-to-readahead.patch
f2fs-pass-the-inode-to-f2fs_mpage_readpages.patch
fuse-convert-from-readpages-to-readahead.patch
fuse-convert-from-readpages-to-readahead-fix.patch
iomap-convert-from-readpages-to-readahead.patch
mm-remove-misleading-comment.patch
mm-simplify-calling-a-compound-page-destructor.patch
ipc-convert-ipcs_idr-to-xarray.patch
ipc-convert-ipcs_idr-to-xarray-update.patch
