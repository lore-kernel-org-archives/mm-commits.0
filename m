From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fuse-convert-from-readpages-to-readahead-fix.patch
 added to -mm tree
Date: Tue, 14 Apr 2020 21:33:23 -0700
Message-ID: <20200415043323.SKhanRv4y%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388430AbgDOEdZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 00:33:25 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: fuse-convert-from-readpages-to-readahead-fix
has been added to the -mm tree.  Its filename is
     fuse-convert-from-readpages-to-readahead-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fuse-convert-from-readpages-to-readahead-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fuse-convert-from-readpages-to-readahead-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: fuse-convert-from-readpages-to-readahead-fix

build fix

Link: http://lkml.kernel.org/r/20200415025938.GB5820@bombadil.infradead.org

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c~fuse-convert-from-readpages-to-readahead-fix
+++ a/fs/fuse/file.c
@@ -924,7 +924,8 @@ static void fuse_readahead(struct readah
 	if (is_bad_inode(inode))
 		return;
 
-	max_pages = min(fc->max_pages, fc->max_read / PAGE_SIZE);
+	max_pages = min_t(unsigned int, fc->max_pages,
+			fc->max_read / PAGE_SIZE);
 
 	for (;;) {
 		struct fuse_io_args *ia;
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
