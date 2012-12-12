From: akpm@linux-foundation.org
Subject: [merged] mm-redefine-address_spaceassoc_mapping.patch removed from -mm tree
Date: Wed, 12 Dec 2012 12:00:23 -0800
Message-ID: <20121212200024.96764200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45804 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab2LLUGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:06:31 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so65809eei.3
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:06:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, andi@firstfloor.org, konrad.wilk@oracle.com, mel@csn.ul.ie, minchan@kernel.org, mst@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: redefine address_space.assoc_mapping
has been removed from the -mm tree.  Its filename was
     mm-redefine-address_spaceassoc_mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: redefine address_space.assoc_mapping

Overhaul struct address_space.assoc_mapping renaming it to
address_space.private_data and its type is redefined to void*.  By this
approach we consistently name the .private_* elements from struct
address_space as well as allow extended usage for address_space
association with other data structures through ->private_data.

Also, all users of old ->assoc_mapping element are converted to reflect
its new name and type change (->private_data).

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c        |   12 ++++++------
 fs/gfs2/glock.c    |    2 +-
 fs/inode.c         |    2 +-
 fs/nilfs2/page.c   |    2 +-
 include/linux/fs.h |    2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/buffer.c~mm-redefine-address_spaceassoc_mapping fs/buffer.c
--- a/fs/buffer.c~mm-redefine-address_spaceassoc_mapping
+++ a/fs/buffer.c
@@ -555,7 +555,7 @@ void emergency_thaw_all(void)
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
-	struct address_space *buffer_mapping = mapping->assoc_mapping;
+	struct address_space *buffer_mapping = mapping->private_data;
 
 	if (buffer_mapping == NULL || list_empty(&mapping->private_list))
 		return 0;
@@ -588,10 +588,10 @@ void mark_buffer_dirty_inode(struct buff
 	struct address_space *buffer_mapping = bh->b_page->mapping;
 
 	mark_buffer_dirty(bh);
-	if (!mapping->assoc_mapping) {
-		mapping->assoc_mapping = buffer_mapping;
+	if (!mapping->private_data) {
+		mapping->private_data = buffer_mapping;
 	} else {
-		BUG_ON(mapping->assoc_mapping != buffer_mapping);
+		BUG_ON(mapping->private_data != buffer_mapping);
 	}
 	if (!bh->b_assoc_map) {
 		spin_lock(&buffer_mapping->private_lock);
@@ -788,7 +788,7 @@ void invalidate_inode_buffers(struct ino
 	if (inode_has_buffers(inode)) {
 		struct address_space *mapping = &inode->i_data;
 		struct list_head *list = &mapping->private_list;
-		struct address_space *buffer_mapping = mapping->assoc_mapping;
+		struct address_space *buffer_mapping = mapping->private_data;
 
 		spin_lock(&buffer_mapping->private_lock);
 		while (!list_empty(list))
@@ -811,7 +811,7 @@ int remove_inode_buffers(struct inode *i
 	if (inode_has_buffers(inode)) {
 		struct address_space *mapping = &inode->i_data;
 		struct list_head *list = &mapping->private_list;
-		struct address_space *buffer_mapping = mapping->assoc_mapping;
+		struct address_space *buffer_mapping = mapping->private_data;
 
 		spin_lock(&buffer_mapping->private_lock);
 		while (!list_empty(list)) {
diff -puN fs/gfs2/glock.c~mm-redefine-address_spaceassoc_mapping fs/gfs2/glock.c
--- a/fs/gfs2/glock.c~mm-redefine-address_spaceassoc_mapping
+++ a/fs/gfs2/glock.c
@@ -768,7 +768,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp,
 		mapping->host = s->s_bdev->bd_inode;
 		mapping->flags = 0;
 		mapping_set_gfp_mask(mapping, GFP_NOFS);
-		mapping->assoc_mapping = NULL;
+		mapping->private_data = NULL;
 		mapping->backing_dev_info = s->s_bdi;
 		mapping->writeback_index = 0;
 	}
diff -puN fs/inode.c~mm-redefine-address_spaceassoc_mapping fs/inode.c
--- a/fs/inode.c~mm-redefine-address_spaceassoc_mapping
+++ a/fs/inode.c
@@ -165,7 +165,7 @@ int inode_init_always(struct super_block
 	mapping->host = inode;
 	mapping->flags = 0;
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
-	mapping->assoc_mapping = NULL;
+	mapping->private_data = NULL;
 	mapping->backing_dev_info = &default_backing_dev_info;
 	mapping->writeback_index = 0;
 
diff -puN fs/nilfs2/page.c~mm-redefine-address_spaceassoc_mapping fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~mm-redefine-address_spaceassoc_mapping
+++ a/fs/nilfs2/page.c
@@ -431,7 +431,7 @@ void nilfs_mapping_init(struct address_s
 	mapping->host = inode;
 	mapping->flags = 0;
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
-	mapping->assoc_mapping = NULL;
+	mapping->private_data = NULL;
 	mapping->backing_dev_info = bdi;
 	mapping->a_ops = &empty_aops;
 }
diff -puN include/linux/fs.h~mm-redefine-address_spaceassoc_mapping include/linux/fs.h
--- a/include/linux/fs.h~mm-redefine-address_spaceassoc_mapping
+++ a/include/linux/fs.h
@@ -418,7 +418,7 @@ struct address_space {
 	struct backing_dev_info *backing_dev_info; /* device readahead, etc */
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
-	struct address_space	*assoc_mapping;	/* ditto */
+	void			*private_data;	/* ditto */
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
_

Patches currently in -mm which might be from aquini@redhat.com are

origin.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

