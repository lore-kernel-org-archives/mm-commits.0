From: akpm@linux-foundation.org
Subject: + afs-use-find_get_pages_range_tag.patch added to -mm tree
Date: Tue, 10 Oct 2017 14:01:17 -0700
Message-ID: <59dd351d.F7GqcAqWqZQxHcrL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32836 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933425AbdJJVBT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 17:01:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, daniel.m.jordan@oracle.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: afs: use find_get_pages_range_tag()
has been added to the -mm tree.  Its filename is
     afs-use-find_get_pages_range_tag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/afs-use-find_get_pages_range_tag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/afs-use-find_get_pages_range_tag.patch

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
Subject: afs: use find_get_pages_range_tag()

Use find_get_pages_range_tag() in afs_writepages_region() as we are
interested only in pages from given range.  Remove unnecessary code after
this conversion.

Link: http://lkml.kernel.org/r/20171009151359.31984-16-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN fs/afs/write.c~afs-use-find_get_pages_range_tag fs/afs/write.c
--- a/fs/afs/write.c~afs-use-find_get_pages_range_tag
+++ a/fs/afs/write.c
@@ -497,20 +497,13 @@ static int afs_writepages_region(struct
 	_enter(",,%lx,%lx,", index, end);
 
 	do {
-		n = find_get_pages_tag(mapping, &index, PAGECACHE_TAG_DIRTY,
-				       1, &page);
+		n = find_get_pages_range_tag(mapping, &index, end,
+					PAGECACHE_TAG_DIRTY, 1, &page);
 		if (!n)
 			break;
 
 		_debug("wback %lx", page->index);
 
-		if (page->index > end) {
-			*_next = index;
-			put_page(page);
-			_leave(" = 0 [%lx]", *_next);
-			return 0;
-		}
-
 		/* at this point we hold neither mapping->tree_lock nor lock on
 		 * the page itself: the page may be truncated or invalidated
 		 * (changing page->mapping to NULL), or even swizzled back from
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

