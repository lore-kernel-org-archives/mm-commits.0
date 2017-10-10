From: akpm@linux-foundation.org
Subject: + f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch
 added to -mm tree
Date: Tue, 10 Oct 2017 14:00:53 -0700
Message-ID: <59dd3505.+ucpXGkWcuV9VhYe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60648 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933410AbdJJVBD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 17:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, daniel.m.jordan@oracle.com, jaegeuk@kernel.org, yuchao0@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: f2fs: use find_get_pages_tag() for looking up single page
has been added to the -mm tree.  Its filename is
     f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: f2fs: use find_get_pages_tag() for looking up single page

__get_first_dirty_index() wants to lookup only the first dirty page after
given index.  There's no point in using pagevec_lookup_tag() for that. 
Just use find_get_pages_tag() directly.

Link: http://lkml.kernel.org/r/20171009151359.31984-8-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/file.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/f2fs/file.c~f2fs-use-find_get_pages_tag-for-looking-up-single-page fs/f2fs/file.c
--- a/fs/f2fs/file.c~f2fs-use-find_get_pages_tag-for-looking-up-single-page
+++ a/fs/f2fs/file.c
@@ -313,18 +313,19 @@ int f2fs_sync_file(struct file *file, lo
 static pgoff_t __get_first_dirty_index(struct address_space *mapping,
 						pgoff_t pgofs, int whence)
 {
-	struct pagevec pvec;
+	struct page *page;
 	int nr_pages;
 
 	if (whence != SEEK_DATA)
 		return 0;
 
 	/* find first dirty page index */
-	pagevec_init(&pvec, 0);
-	nr_pages = pagevec_lookup_tag(&pvec, mapping, &pgofs,
-					PAGECACHE_TAG_DIRTY, 1);
-	pgofs = nr_pages ? pvec.pages[0]->index : ULONG_MAX;
-	pagevec_release(&pvec);
+	nr_pages = find_get_pages_tag(mapping, &pgofs, PAGECACHE_TAG_DIRTY,
+				      1, &page);
+	if (!nr_pages)
+		return ULONG_MAX;
+	pgofs = page->index;
+	put_page(page);
 	return pgofs;
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are

mm-readahead-increase-maximum-readahead-window.patch
mm-implement-find_get_pages_range_tag.patch
btrfs-use-pagevec_lookup_range_tag.patch
ceph-use-pagevec_lookup_range_tag.patch
ext4-use-pagevec_lookup_range_tag.patch
f2fs-use-pagevec_lookup_range_tag.patch
f2fs-simplify-page-iteration-loops.patch
f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch
gfs2-use-pagevec_lookup_range_tag.patch
nilfs2-use-pagevec_lookup_range_tag.patch
mm-use-pagevec_lookup_range_tag-in-__filemap_fdatawait_range.patch
mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch
mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
ceph-use-pagevec_lookup_range_nr_tag.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag.patch
afs-use-find_get_pages_range_tag.patch
cifs-use-find_get_pages_range_tag.patch

