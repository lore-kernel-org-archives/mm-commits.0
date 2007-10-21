From: akpm@linux-foundation.org
Subject: - reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:22 -0700
Message-ID: <200710212347.l9LNlMin000658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbXJUXzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     fs/reiser4/plugin/: make 3 functions static
has been removed from the -mm tree.  Its filename was
     reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: fs/reiser4/plugin/: make 3 functions static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the following needlessly global functions static:
- file/cryptcompress.c: __put_page_cluster()
- file/cryptcompress.c: put_hint_cluster()
- item/ctail.c: ctail_read_disk_cluster()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Edward Shishkin <edward@namesys.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/cluster.h            |    4 ----
 fs/reiser4/plugin/file/cryptcompress.c |    8 ++++----
 fs/reiser4/plugin/file/cryptcompress.h |    2 --
 fs/reiser4/plugin/item/ctail.c         |    5 +++--
 4 files changed, 7 insertions(+), 12 deletions(-)

diff -puN fs/reiser4/plugin/cluster.h~reiser4-cryptcompress-misc-fixups-make-3-functions-static fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-cryptcompress-misc-fixups-make-3-functions-static
+++ a/fs/reiser4/plugin/cluster.h
@@ -326,8 +326,6 @@ int reiser4_deflate_cluster(struct clust
 void truncate_complete_page_cluster(struct inode *inode, cloff_t start,
 					 int even_cows);
 void invalidate_hint_cluster(struct cluster_handle * clust);
-void put_hint_cluster(struct cluster_handle * clust, struct inode *inode,
-		      znode_lock_mode mode);
 int get_disk_cluster_locked(struct cluster_handle * clust, struct inode * inode,
 			    znode_lock_mode lock_mode);
 void reset_cluster_params(struct cluster_handle * clust);
@@ -335,8 +333,6 @@ int set_cluster_by_page(struct cluster_h
 			int count);
 int prepare_page_cluster(struct inode *inode, struct cluster_handle * clust,
 			 rw_op rw);
-void __put_page_cluster(int from, int to, struct page ** pages,
-			struct inode * inode);
 void put_page_cluster(struct cluster_handle * clust,
 		      struct inode  * inode, rw_op rw);
 void put_cluster_handle(struct cluster_handle * clust);
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-cryptcompress-misc-fixups-make-3-functions-static fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-cryptcompress-misc-fixups-make-3-functions-static
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -1378,8 +1378,8 @@ static void truncate_page_cluster_range(
 }
 
 /* Put @count pages starting from @from offset */
-void __put_page_cluster(int from, int count,
-			struct page ** pages, struct inode  * inode)
+static void __put_page_cluster(int from, int count,
+			       struct page ** pages, struct inode  * inode)
 {
 	int i;
 	assert("edward-1468", pages != NULL);
@@ -1975,8 +1975,8 @@ void invalidate_hint_cluster(struct clus
 	hint_clr_valid(clust->hint);
 }
 
-void put_hint_cluster(struct cluster_handle * clust, struct inode *inode,
-		      znode_lock_mode mode)
+static void put_hint_cluster(struct cluster_handle * clust,
+			     struct inode *inode, znode_lock_mode mode)
 {
 	assert("edward-1286", clust != NULL);
 	assert("edward-1287", clust->hint != NULL);
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-cryptcompress-misc-fixups-make-3-functions-static fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-cryptcompress-misc-fixups-make-3-functions-static
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -543,8 +543,6 @@ int equal_to_rdk(znode *, const reiser4_
 int goto_right_neighbor(coord_t *, lock_handle *);
 int cryptcompress_inode_ok(struct inode *inode);
 int coord_is_unprepped_ctail(const coord_t * coord);
-extern int ctail_read_disk_cluster (struct cluster_handle *, struct inode *,
-				    struct page *, znode_lock_mode mode);
 extern int do_readpage_ctail(struct inode *, struct cluster_handle *,
 			     struct page * page, znode_lock_mode mode);
 extern int ctail_insert_unprepped_cluster(struct cluster_handle * clust,
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-cryptcompress-misc-fixups-make-3-functions-static fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-cryptcompress-misc-fixups-make-3-functions-static
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -551,8 +551,9 @@ int read_ctail(struct file *file UNUSED_
  * Prepare transform stream with plain text for page
  * @page taking into account synchronization issues.
  */
-int ctail_read_disk_cluster(struct cluster_handle * clust, struct inode * inode,
-			    struct page * page, znode_lock_mode mode)
+static int ctail_read_disk_cluster(struct cluster_handle * clust,
+				   struct inode * inode, struct page * page,
+				   znode_lock_mode mode)
 {
 	int result;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-scsi-misc.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
reiser4.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
