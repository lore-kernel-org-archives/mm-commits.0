From: akpm@linux-foundation.org
Subject: + ocfs2-remove-null-assignments-on-static.patch added to -mm tree
Date: Wed, 09 Apr 2014 13:38:42 -0700
Message-ID: <5345afd2.ljfHNUIFmwpslpND%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbaDIUin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 16:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, fabf@skynet.be

Subject: + ocfs2-remove-null-assignments-on-static.patch added to -mm tree
To: fabf@skynet.be,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 13:38:42 -0700


The patch titled
     Subject: ocfs2: remove NULL assignments on static
has been added to the -mm tree.  Its filename is
     ocfs2-remove-null-assignments-on-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-null-assignments-on-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-null-assignments-on-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ocfs2: remove NULL assignments on static

Static values are automatically initialized to NULL.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c   |    2 +-
 fs/ocfs2/dlm/dlmdebug.c  |    2 +-
 fs/ocfs2/dlm/dlmlock.c   |    2 +-
 fs/ocfs2/dlm/dlmmaster.c |    6 +++---
 fs/ocfs2/stackglue.c     |    2 +-
 fs/ocfs2/super.c         |    4 ++--
 fs/ocfs2/uptodate.c      |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-remove-null-assignments-on-static fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-remove-null-assignments-on-static
+++ a/fs/ocfs2/cluster/tcp.c
@@ -108,7 +108,7 @@ static struct rb_root o2net_handler_tree
 static struct o2net_node o2net_nodes[O2NM_MAX_NODES];
 
 /* XXX someday we'll need better accounting */
-static struct socket *o2net_listen_sock = NULL;
+static struct socket *o2net_listen_sock;
 
 /*
  * listen work is only queued by the listening socket callbacks on the
diff -puN fs/ocfs2/dlm/dlmdebug.c~ocfs2-remove-null-assignments-on-static fs/ocfs2/dlm/dlmdebug.c
--- a/fs/ocfs2/dlm/dlmdebug.c~ocfs2-remove-null-assignments-on-static
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -338,7 +338,7 @@ void dlm_print_one_mle(struct dlm_master
 
 #ifdef CONFIG_DEBUG_FS
 
-static struct dentry *dlm_debugfs_root = NULL;
+static struct dentry *dlm_debugfs_root;
 
 #define DLM_DEBUGFS_DIR				"o2dlm"
 #define DLM_DEBUGFS_DLM_STATE			"dlm_state"
diff -puN fs/ocfs2/dlm/dlmlock.c~ocfs2-remove-null-assignments-on-static fs/ocfs2/dlm/dlmlock.c
--- a/fs/ocfs2/dlm/dlmlock.c~ocfs2-remove-null-assignments-on-static
+++ a/fs/ocfs2/dlm/dlmlock.c
@@ -52,7 +52,7 @@
 #define MLOG_MASK_PREFIX ML_DLM
 #include "cluster/masklog.h"
 
-static struct kmem_cache *dlm_lock_cache = NULL;
+static struct kmem_cache *dlm_lock_cache;
 
 static DEFINE_SPINLOCK(dlm_cookie_lock);
 static u64 dlm_next_cookie = 1;
diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-remove-null-assignments-on-static fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-remove-null-assignments-on-static
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -82,9 +82,9 @@ static inline int dlm_mle_equal(struct d
 	return 1;
 }
 
-static struct kmem_cache *dlm_lockres_cache = NULL;
-static struct kmem_cache *dlm_lockname_cache = NULL;
-static struct kmem_cache *dlm_mle_cache = NULL;
+static struct kmem_cache *dlm_lockres_cache;
+static struct kmem_cache *dlm_lockname_cache;
+static struct kmem_cache *dlm_mle_cache;
 
 static void dlm_mle_release(struct kref *kref);
 static void dlm_init_mle(struct dlm_master_list_entry *mle,
diff -puN fs/ocfs2/stackglue.c~ocfs2-remove-null-assignments-on-static fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-remove-null-assignments-on-static
+++ a/fs/ocfs2/stackglue.c
@@ -709,7 +709,7 @@ static struct ctl_table ocfs2_root_table
 	{ }
 };
 
-static struct ctl_table_header *ocfs2_table_header = NULL;
+static struct ctl_table_header *ocfs2_table_header;
 
 
 /*
diff -puN fs/ocfs2/super.c~ocfs2-remove-null-assignments-on-static fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-remove-null-assignments-on-static
+++ a/fs/ocfs2/super.c
@@ -75,7 +75,7 @@
 
 #include "buffer_head_io.h"
 
-static struct kmem_cache *ocfs2_inode_cachep = NULL;
+static struct kmem_cache *ocfs2_inode_cachep;
 struct kmem_cache *ocfs2_dquot_cachep;
 struct kmem_cache *ocfs2_qf_chunk_cachep;
 
@@ -85,7 +85,7 @@ struct kmem_cache *ocfs2_qf_chunk_cachep
  * workqueue and schedule on our own. */
 struct workqueue_struct *ocfs2_wq = NULL;
 
-static struct dentry *ocfs2_debugfs_root = NULL;
+static struct dentry *ocfs2_debugfs_root;
 
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
diff -puN fs/ocfs2/uptodate.c~ocfs2-remove-null-assignments-on-static fs/ocfs2/uptodate.c
--- a/fs/ocfs2/uptodate.c~ocfs2-remove-null-assignments-on-static
+++ a/fs/ocfs2/uptodate.c
@@ -67,7 +67,7 @@ struct ocfs2_meta_cache_item {
 	sector_t	c_block;
 };
 
-static struct kmem_cache *ocfs2_uptodate_cachep = NULL;
+static struct kmem_cache *ocfs2_uptodate_cachep;
 
 u64 ocfs2_metadata_cache_owner(struct ocfs2_caching_info *ci)
 {
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

