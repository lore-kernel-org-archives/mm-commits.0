From: akpm@linux-foundation.org
Subject: + mm-drop-wait-parameter-from-write_one_page-fix.patch added to
 -mm tree
Date: Tue, 30 May 2017 12:38:20 -0700
Message-ID: <592dca2c.mkU6J0dGwnvgo4lQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47380 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbdE3TiV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 15:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.kleikamp@oracle.com, hch@lst.de, jack@suse.cz, jlayton@redhat.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: JFS: do not ignore return code from write_one_page()
has been added to the -mm tree.  Its filename is
     mm-drop-wait-parameter-from-write_one_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-wait-parameter-from-write_one_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-wait-parameter-from-write_one_page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: JFS: do not ignore return code from write_one_page()

There are a couple places where jfs calls write_one_page() where clean
recovery is not possible.  In these cases, the file system should be
marked dirty.  To do this, it is now necessary to store the superblock in
the metapage structure.

Link: http://lkml.kernel.org/r/db45ab67-55c7-08ff-6776-f76b3bf5cbf5@oracle.com
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_metapage.c |    7 +++++--
 fs/jfs/jfs_metapage.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/jfs/jfs_metapage.c~mm-drop-wait-parameter-from-write_one_page-fix fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~mm-drop-wait-parameter-from-write_one_page-fix
+++ a/fs/jfs/jfs_metapage.c
@@ -664,6 +664,7 @@ struct metapage *__get_metapage(struct i
 		INCREMENT(mpStat.pagealloc);
 		mp = alloc_metapage(GFP_NOFS);
 		mp->page = page;
+		mp->sb = inode->i_sb;
 		mp->flag = 0;
 		mp->xflag = COMMIT_PAGE;
 		mp->count = 1;
@@ -711,7 +712,8 @@ void force_metapage(struct metapage *mp)
 	get_page(page);
 	lock_page(page);
 	set_page_dirty(page);
-	write_one_page(page);
+	if (write_one_page(page))
+		jfs_error(mp->sb, "write_one_page() failed\n");
 	clear_bit(META_forcewrite, &mp->flag);
 	put_page(page);
 }
@@ -756,7 +758,8 @@ void release_metapage(struct metapage *
 		set_page_dirty(page);
 		if (test_bit(META_sync, &mp->flag)) {
 			clear_bit(META_sync, &mp->flag);
-			write_one_page(page);
+			if (write_one_page(page))
+				jfs_error(mp->sb, "write_one_page() failed\n");
 			lock_page(page); /* write_one_page unlocks the page */
 		}
 	} else if (mp->lsn)	/* discard_metapage doesn't remove it */
diff -puN fs/jfs/jfs_metapage.h~mm-drop-wait-parameter-from-write_one_page-fix fs/jfs/jfs_metapage.h
--- a/fs/jfs/jfs_metapage.h~mm-drop-wait-parameter-from-write_one_page-fix
+++ a/fs/jfs/jfs_metapage.h
@@ -38,6 +38,7 @@ struct metapage {
 
 	/* implementation */
 	struct page *page;
+	struct super_block *sb;
 	unsigned int logical_size;
 
 	/* Journal management */
_

Patches currently in -mm which might be from dave.kleikamp@oracle.com are

mm-drop-wait-parameter-from-write_one_page-fix.patch

