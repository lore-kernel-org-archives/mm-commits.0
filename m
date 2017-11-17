From: akpm@linux-foundation.org
Subject: [patch 58/94] fs, nilfs: convert nilfs_root.count from
 atomic_t to refcount_t
Date: Fri, 17 Nov 2017 15:29:39 -0800
Message-ID: <20171117232939.NijnotQbd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55876 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966938AbdKQX3l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:29:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwindsor@gmail.com, elena.reshetova@intel.com, ishkamiel@gmail.com, keescook@chromium.org, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Elena Reshetova <elena.reshetova@intel.com>
Subject: fs, nilfs: convert nilfs_root.count from atomic_t to refcount_t

atomic_t variables are currently used to implement reference counters with
the following properties:

 - counter is initialized to 1 using atomic_set()
 - a resource is freed upon counter reaching zero
 - once counter reaches zero, its further
   increments aren't allowed
 - counter schema uses basic atomic operations
   (set, inc, inc_not_zero, dec_and_test, etc.)

Such atomic variables should be converted to a newly provided refcount_t
type and API that prevents accidental counter overflows and underflows. 
This is important since overflows and underflows can lead to
use-after-free situation and be exploitable.

The variable nilfs_root.count is used as pure reference counter.  Convert
it to refcount_t and fix up the operations.

Link: http://lkml.kernel.org/r/1509367935-3086-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.c |    8 ++++----
 fs/nilfs2/the_nilfs.h |    5 +++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/nilfs2/the_nilfs.c~fs-nilfs-convert-nilfs_rootcount-from-atomic_t-to-refcount_t fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~fs-nilfs-convert-nilfs_rootcount-from-atomic_t-to-refcount_t
+++ a/fs/nilfs2/the_nilfs.c
@@ -737,7 +737,7 @@ struct nilfs_root *nilfs_lookup_root(str
 		} else if (cno > root->cno) {
 			n = n->rb_right;
 		} else {
-			atomic_inc(&root->count);
+			refcount_inc(&root->count);
 			spin_unlock(&nilfs->ns_cptree_lock);
 			return root;
 		}
@@ -776,7 +776,7 @@ nilfs_find_or_create_root(struct the_nil
 		} else if (cno > root->cno) {
 			p = &(*p)->rb_right;
 		} else {
-			atomic_inc(&root->count);
+			refcount_inc(&root->count);
 			spin_unlock(&nilfs->ns_cptree_lock);
 			kfree(new);
 			return root;
@@ -786,7 +786,7 @@ nilfs_find_or_create_root(struct the_nil
 	new->cno = cno;
 	new->ifile = NULL;
 	new->nilfs = nilfs;
-	atomic_set(&new->count, 1);
+	refcount_set(&new->count, 1);
 	atomic64_set(&new->inodes_count, 0);
 	atomic64_set(&new->blocks_count, 0);
 
@@ -806,7 +806,7 @@ nilfs_find_or_create_root(struct the_nil
 
 void nilfs_put_root(struct nilfs_root *root)
 {
-	if (atomic_dec_and_test(&root->count)) {
+	if (refcount_dec_and_test(&root->count)) {
 		struct the_nilfs *nilfs = root->nilfs;
 
 		nilfs_sysfs_delete_snapshot_group(root);
diff -puN fs/nilfs2/the_nilfs.h~fs-nilfs-convert-nilfs_rootcount-from-atomic_t-to-refcount_t fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~fs-nilfs-convert-nilfs_rootcount-from-atomic_t-to-refcount_t
+++ a/fs/nilfs2/the_nilfs.h
@@ -27,6 +27,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 
 struct nilfs_sc_info;
 struct nilfs_sysfs_dev_subgroups;
@@ -246,7 +247,7 @@ struct nilfs_root {
 	__u64 cno;
 	struct rb_node rb_node;
 
-	atomic_t count;
+	refcount_t count;
 	struct the_nilfs *nilfs;
 	struct inode *ifile;
 
@@ -299,7 +300,7 @@ void nilfs_swap_super_block(struct the_n
 
 static inline void nilfs_get_root(struct nilfs_root *root)
 {
-	atomic_inc(&root->count);
+	refcount_inc(&root->count);
 }
 
 static inline int nilfs_valid_fs(struct the_nilfs *nilfs)
_
