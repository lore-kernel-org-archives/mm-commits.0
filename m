From: akpm@linux-foundation.org
Subject: - use-pgoff_t-instead-of-unsigned-long.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:18 -0800
Message-ID: <200802082015.m18KFxdW010662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752196AbYBHUpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:45:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Use pgoff_t instead of unsigned long
has been removed from the -mm tree.  Its filename was
     use-pgoff_t-instead-of-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use pgoff_t instead of unsigned long
From: Jan Kara <jack@suse.cz>

Convert variables containing page indexes to pgoff_t.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c     |    2 +-
 mm/filemap_xip.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~use-pgoff_t-instead-of-unsigned-long mm/filemap.c
--- a/mm/filemap.c~use-pgoff_t-instead-of-unsigned-long
+++ a/mm/filemap.c
@@ -1332,7 +1332,7 @@ int filemap_fault(struct vm_area_struct 
 	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
 	struct page *page;
-	unsigned long size;
+	pgoff_t size;
 	int did_readaround = 0;
 	int ret = 0;
 
diff -puN mm/filemap_xip.c~use-pgoff_t-instead-of-unsigned-long mm/filemap_xip.c
--- a/mm/filemap_xip.c~use-pgoff_t-instead-of-unsigned-long
+++ a/mm/filemap_xip.c
@@ -56,7 +56,8 @@ do_xip_mapping_read(struct address_space
 		    read_actor_t actor)
 {
 	struct inode *inode = mapping->host;
-	unsigned long index, end_index, offset;
+	pgoff_t index, end_index;
+	unsigned long offset;
 	loff_t isize;
 
 	BUG_ON(!mapping->a_ops->get_xip_page);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
