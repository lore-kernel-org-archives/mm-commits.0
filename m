From: akpm@linux-foundation.org
Subject: + list_lru-dynamically-adjust-node-arrays.patch added to -mm tree
Date: Thu, 06 Jun 2013 14:12:11 -0700
Message-ID: <51b0fb2b.94au1uYmidh/fZXy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3FFVMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 17:12:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, gleb@redhat.com, dchinner@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, glommer@openvz.org

Subject: + list_lru-dynamically-adjust-node-arrays.patch added to -mm tree
To: glommer@openvz.org,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,dchinner@redhat.com,gleb@redhat.com,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 14:12:11 -0700


The patch titled
     Subject: list_lru: dynamically adjust node arrays
has been added to the -mm tree.  Its filename is
     list_lru-dynamically-adjust-node-arrays.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: list_lru: dynamically adjust node arrays

We currently use a compile-time constant to size the node array for the
list_lru structure.  Due to this, we don't need to allocate any memory at
initialization time.  But as a consequence, the structures that contain
embedded list_lru lists can become way too big (the superblock for
instance contains two of them).

This patch aims at ameliorating this situation by dynamically allocating
the node arrays with the firmware provided nr_node_ids.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c               |   11 +++++++++--
 fs/xfs/xfs_buf.c         |    6 +++++-
 fs/xfs/xfs_qm.c          |   10 ++++++++--
 include/linux/list_lru.h |   13 ++-----------
 mm/list_lru.c            |   14 +++++++++++++-
 5 files changed, 37 insertions(+), 17 deletions(-)

diff -puN fs/super.c~list_lru-dynamically-adjust-node-arrays fs/super.c
--- a/fs/super.c~list_lru-dynamically-adjust-node-arrays
+++ a/fs/super.c
@@ -199,8 +199,12 @@ static struct super_block *alloc_super(s
 		INIT_HLIST_NODE(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
-		list_lru_init(&s->s_dentry_lru);
-		list_lru_init(&s->s_inode_lru);
+
+		if (list_lru_init(&s->s_dentry_lru))
+			goto err_out;
+		if (list_lru_init(&s->s_inode_lru))
+			goto err_out_dentry_lru;
+
 		INIT_LIST_HEAD(&s->s_mounts);
 		init_rwsem(&s->s_umount);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
@@ -240,6 +244,9 @@ static struct super_block *alloc_super(s
 	}
 out:
 	return s;
+
+err_out_dentry_lru:
+	list_lru_destroy(&s->s_dentry_lru);
 err_out:
 	security_sb_free(s);
 #ifdef CONFIG_SMP
diff -puN fs/xfs/xfs_buf.c~list_lru-dynamically-adjust-node-arrays fs/xfs/xfs_buf.c
--- a/fs/xfs/xfs_buf.c~list_lru-dynamically-adjust-node-arrays
+++ a/fs/xfs/xfs_buf.c
@@ -1591,6 +1591,7 @@ xfs_free_buftarg(
 	struct xfs_mount	*mp,
 	struct xfs_buftarg	*btp)
 {
+	list_lru_destroy(&btp->bt_lru);
 	unregister_shrinker(&btp->bt_shrinker);
 
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
@@ -1665,9 +1666,12 @@ xfs_alloc_buftarg(
 	if (!btp->bt_bdi)
 		goto error;
 
-	list_lru_init(&btp->bt_lru);
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error;
+
+	if (list_lru_init(&btp->bt_lru))
+		goto error;
+
 	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
 	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
 	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
diff -puN fs/xfs/xfs_qm.c~list_lru-dynamically-adjust-node-arrays fs/xfs/xfs_qm.c
--- a/fs/xfs/xfs_qm.c~list_lru-dynamically-adjust-node-arrays
+++ a/fs/xfs/xfs_qm.c
@@ -781,11 +781,18 @@ xfs_qm_init_quotainfo(
 
 	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), KM_SLEEP);
 
+	if ((error = list_lru_init(&qinf->qi_lru))) {
+		kmem_free(qinf);
+		mp->m_quotainfo = NULL;
+		return error;
+	}
+
 	/*
 	 * See if quotainodes are setup, and if not, allocate them,
 	 * and change the superblock accordingly.
 	 */
 	if ((error = xfs_qm_init_quotainos(mp))) {
+		list_lru_destroy(&qinf->qi_lru);
 		kmem_free(qinf);
 		mp->m_quotainfo = NULL;
 		return error;
@@ -795,8 +802,6 @@ xfs_qm_init_quotainfo(
 	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
 	mutex_init(&qinf->qi_tree_lock);
 
-	list_lru_init(&qinf->qi_lru);
-
 	/* mutex used to serialize quotaoffs */
 	mutex_init(&qinf->qi_quotaofflock);
 
@@ -884,6 +889,7 @@ xfs_qm_destroy_quotainfo(
 	qi = mp->m_quotainfo;
 	ASSERT(qi != NULL);
 
+	list_lru_destroy(&qi->qi_lru);
 	unregister_shrinker(&qi->qi_shrinker);
 
 	if (qi->qi_uquotaip) {
diff -puN include/linux/list_lru.h~list_lru-dynamically-adjust-node-arrays include/linux/list_lru.h
--- a/include/linux/list_lru.h~list_lru-dynamically-adjust-node-arrays
+++ a/include/linux/list_lru.h
@@ -27,20 +27,11 @@ struct list_lru_node {
 } ____cacheline_aligned_in_smp;
 
 struct list_lru {
-	/*
-	 * Because we use a fixed-size array, this struct can be very big if
-	 * MAX_NUMNODES is big. If this becomes a problem this is fixable by
-	 * turning this into a pointer and dynamically allocating this to
-	 * nr_node_ids. This quantity is firwmare-provided, and still would
-	 * provide room for all nodes at the cost of a pointer lookup and an
-	 * extra allocation. Because that allocation will most likely come from
-	 * a different slab cache than the main structure holding this
-	 * structure, we may very well fail.
-	 */
-	struct list_lru_node	node[MAX_NUMNODES];
+	struct list_lru_node	*node;
 	nodemask_t		active_nodes;
 };
 
+void list_lru_destroy(struct list_lru *lru);
 int list_lru_init(struct list_lru *lru);
 
 /**
diff -puN mm/list_lru.c~list_lru-dynamically-adjust-node-arrays mm/list_lru.c
--- a/mm/list_lru.c~list_lru-dynamically-adjust-node-arrays
+++ a/mm/list_lru.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/list_lru.h>
+#include <linux/slab.h>
 
 bool list_lru_add(struct list_lru *lru, struct list_head *item)
 {
@@ -162,9 +163,14 @@ unsigned long list_lru_dispose_all(struc
 int list_lru_init(struct list_lru *lru)
 {
 	int i;
+	size_t size = sizeof(*lru->node) * nr_node_ids;
+
+	lru->node = kzalloc(size, GFP_KERNEL);
+	if (!lru->node)
+		return -ENOMEM;
 
 	nodes_clear(lru->active_nodes);
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		spin_lock_init(&lru->node[i].lock);
 		INIT_LIST_HEAD(&lru->node[i].list);
 		lru->node[i].nr_items = 0;
@@ -172,3 +178,9 @@ int list_lru_init(struct list_lru *lru)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(list_lru_init);
+
+void list_lru_destroy(struct list_lru *lru)
+{
+	kfree(lru->node);
+}
+EXPORT_SYMBOL_GPL(list_lru_destroy);
_

Patches currently in -mm which might be from glommer@openvz.org are

fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch

