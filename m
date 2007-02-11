From: akpm@linux-foundation.org
Subject: - export-invalidate_mapping_pages-to-modules.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:54 -0800
Message-ID: <200702112252.l1BMqsO2016062@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60314 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788AbXBKWxB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:53:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aia21@cam.ac.uk, aia21@cantab.net, mm-commits@vger.kernel.org


The patch titled
     Export invalidate_mapping_pages() to modules
has been removed from the -mm tree.  Its filename was
     export-invalidate_mapping_pages-to-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Export invalidate_mapping_pages() to modules
From: Anton Altaparmakov <aia21@cam.ac.uk>

It makes no sense to me to export invalidate_inode_pages() and not
invalidate_mapping_pages() and I actually need invalidate_mapping_pages()
because of its range specification ability...

akpm: also remove the export of invalidate_inode_pages() by making it an
inlined wrapper.

Signed-off-by: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    8 +++++++-
 mm/truncate.c      |    7 +------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff -puN include/linux/fs.h~export-invalidate_mapping_pages-to-modules include/linux/fs.h
--- a/include/linux/fs.h~export-invalidate_mapping_pages-to-modules
+++ a/include/linux/fs.h
@@ -1573,7 +1573,13 @@ extern int invalidate_partition(struct g
 extern int invalidate_inodes(struct super_block *);
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
-unsigned long invalidate_inode_pages(struct address_space *mapping);
+
+static inline unsigned long
+invalidate_inode_pages(struct address_space *mapping)
+{
+	return invalidate_mapping_pages(mapping, 0, ~0UL);
+}
+
 static inline void invalidate_remote_inode(struct inode *inode)
 {
 	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
diff -puN mm/truncate.c~export-invalidate_mapping_pages-to-modules mm/truncate.c
--- a/mm/truncate.c~export-invalidate_mapping_pages-to-modules
+++ a/mm/truncate.c
@@ -310,12 +310,7 @@ unlock:
 	}
 	return ret;
 }
-
-unsigned long invalidate_inode_pages(struct address_space *mapping)
-{
-	return invalidate_mapping_pages(mapping, 0, ~0UL);
-}
-EXPORT_SYMBOL(invalidate_inode_pages);
+EXPORT_SYMBOL(invalidate_mapping_pages);
 
 /*
  * This is like invalidate_complete_page(), except it ignores the page's
_

Patches currently in -mm which might be from aia21@cam.ac.uk are

origin.patch
