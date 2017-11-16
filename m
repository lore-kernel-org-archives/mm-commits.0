From: akpm@linux-foundation.org
Subject: [patch 068/131] afs: use find_get_pages_range_tag()
Date: Wed, 15 Nov 2017 17:35:23 -0800
Message-ID: <20171116013523.L3jPEPQf8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933032AbdKPBfY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:35:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dhowells@redhat.com, jack@suse.cz, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
