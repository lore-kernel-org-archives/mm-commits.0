From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-null-assignments-on-static.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:42:38 -0700
Message-ID: <5390c82e.qZXg6CU/Dd3f4hpu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaFETmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, fabf@skynet.be

Subject: [merged] ocfs2-remove-null-assignments-on-static.patch removed from -mm tree
To: fabf@skynet.be,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:38 -0700


The patch titled
     Subject: ocfs2: remove NULL assignments on static
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-null-assignments-on-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch

