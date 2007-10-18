From: akpm@linux-foundation.org
Subject: - fs-afs-possible-cleanups.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:41 -0700
Message-ID: <200710180654.l9I6sf6o030542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932351AbXJRHmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:42:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fs/afs/: possible cleanups
has been removed from the -mm tree.  Its filename was
     fs-afs-possible-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/afs/: possible cleanups
From: Adrian Bunk <bunk@stusta.de>

This patch contains the following possible cleanups:
- make the following needlessly global functions static:
  - rxrpc.c: afs_send_pages()
  - vlocation.c: afs_vlocation_queue_for_updates()
  - write.c: afs_writepages_region()
- make the following needlessly global variables static:
  - mntpt.c: afs_mntpt_expiry_timeout
  - proc.c: afs_vlocation_states[]
  - server.c: afs_server_timeout
  - vlocation.c: afs_vlocation_timeout
  - vlocation.c: afs_vlocation_update_timeout
- #if 0 the following unused function:
  - cell.c: afs_get_cell_maybe()
- #if 0 the following unused variables:
  - callback.c: afs_vnode_update_timeout
  - cmservice.c: struct afs_cm_workqueue

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/callback.c  |    2 ++
 fs/afs/cell.c      |    2 ++
 fs/afs/cmservice.c |    2 ++
 fs/afs/internal.h  |    1 -
 fs/afs/mntpt.c     |    2 +-
 fs/afs/proc.c      |    2 +-
 fs/afs/rxrpc.c     |    3 ++-
 fs/afs/server.c    |    2 +-
 fs/afs/vlocation.c |    6 +++---
 fs/afs/write.c     |    6 +++---
 10 files changed, 17 insertions(+), 11 deletions(-)

diff -puN fs/afs/callback.c~fs-afs-possible-cleanups fs/afs/callback.c
--- a/fs/afs/callback.c~fs-afs-possible-cleanups
+++ a/fs/afs/callback.c
@@ -20,7 +20,9 @@
 #include <linux/sched.h>
 #include "internal.h"
 
+#if 0
 unsigned afs_vnode_update_timeout = 10;
+#endif  /*  0  */
 
 #define afs_breakring_space(server) \
 	CIRC_SPACE((server)->cb_break_head, (server)->cb_break_tail,	\
diff -puN fs/afs/cell.c~fs-afs-possible-cleanups fs/afs/cell.c
--- a/fs/afs/cell.c~fs-afs-possible-cleanups
+++ a/fs/afs/cell.c
@@ -265,6 +265,7 @@ struct afs_cell *afs_cell_lookup(const c
 	return cell;
 }
 
+#if 0
 /*
  * try and get a cell record
  */
@@ -280,6 +281,7 @@ struct afs_cell *afs_get_cell_maybe(stru
 	write_unlock(&afs_cells_lock);
 	return cell;
 }
+#endif  /*  0  */
 
 /*
  * destroy a cell record
diff -puN fs/afs/cmservice.c~fs-afs-possible-cleanups fs/afs/cmservice.c
--- a/fs/afs/cmservice.c~fs-afs-possible-cleanups
+++ a/fs/afs/cmservice.c
@@ -16,7 +16,9 @@
 #include "internal.h"
 #include "afs_cm.h"
 
+#if 0
 struct workqueue_struct *afs_cm_workqueue;
+#endif  /*  0  */
 
 static int afs_deliver_cb_init_call_back_state(struct afs_call *,
 					       struct sk_buff *, bool);
diff -puN fs/afs/internal.h~fs-afs-possible-cleanups fs/afs/internal.h
--- a/fs/afs/internal.h~fs-afs-possible-cleanups
+++ a/fs/afs/internal.h
@@ -570,7 +570,6 @@ extern int afs_abort_to_error(u32);
  */
 extern const struct inode_operations afs_mntpt_inode_operations;
 extern const struct file_operations afs_mntpt_file_operations;
-extern unsigned long afs_mntpt_expiry_timeout;
 
 extern int afs_mntpt_check_symlink(struct afs_vnode *, struct key *);
 extern void afs_mntpt_kill_timer(void);
diff -puN fs/afs/mntpt.c~fs-afs-possible-cleanups fs/afs/mntpt.c
--- a/fs/afs/mntpt.c~fs-afs-possible-cleanups
+++ a/fs/afs/mntpt.c
@@ -42,7 +42,7 @@ const struct inode_operations afs_mntpt_
 static LIST_HEAD(afs_vfsmounts);
 static DECLARE_DELAYED_WORK(afs_mntpt_expiry_timer, afs_mntpt_expiry_timed_out);
 
-unsigned long afs_mntpt_expiry_timeout = 10 * 60;
+static unsigned long afs_mntpt_expiry_timeout = 10 * 60;
 
 /*
  * check a symbolic link to see whether it actually encodes a mountpoint
diff -puN fs/afs/proc.c~fs-afs-possible-cleanups fs/afs/proc.c
--- a/fs/afs/proc.c~fs-afs-possible-cleanups
+++ a/fs/afs/proc.c
@@ -513,7 +513,7 @@ static void afs_proc_cell_volumes_stop(s
 	up_read(&cell->vl_sem);
 }
 
-const char afs_vlocation_states[][4] = {
+static const char afs_vlocation_states[][4] = {
 	[AFS_VL_NEW]			= "New",
 	[AFS_VL_CREATING]		= "Crt",
 	[AFS_VL_VALID]			= "Val",
diff -puN fs/afs/rxrpc.c~fs-afs-possible-cleanups fs/afs/rxrpc.c
--- a/fs/afs/rxrpc.c~fs-afs-possible-cleanups
+++ a/fs/afs/rxrpc.c
@@ -239,7 +239,8 @@ void afs_flat_call_destructor(struct afs
 /*
  * attach the data from a bunch of pages on an inode to a call
  */
-int afs_send_pages(struct afs_call *call, struct msghdr *msg, struct kvec *iov)
+static int afs_send_pages(struct afs_call *call, struct msghdr *msg,
+			  struct kvec *iov)
 {
 	struct page *pages[8];
 	unsigned count, n, loop, offset, to;
diff -puN fs/afs/server.c~fs-afs-possible-cleanups fs/afs/server.c
--- a/fs/afs/server.c~fs-afs-possible-cleanups
+++ a/fs/afs/server.c
@@ -13,7 +13,7 @@
 #include <linux/slab.h>
 #include "internal.h"
 
-unsigned afs_server_timeout = 10;	/* server timeout in seconds */
+static unsigned afs_server_timeout = 10;	/* server timeout in seconds */
 
 static void afs_reap_server(struct work_struct *);
 
diff -puN fs/afs/vlocation.c~fs-afs-possible-cleanups fs/afs/vlocation.c
--- a/fs/afs/vlocation.c~fs-afs-possible-cleanups
+++ a/fs/afs/vlocation.c
@@ -15,8 +15,8 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-unsigned afs_vlocation_timeout = 10;	/* volume location timeout in seconds */
-unsigned afs_vlocation_update_timeout = 10 * 60;
+static unsigned afs_vlocation_timeout = 10;	/* volume location timeout in seconds */
+static unsigned afs_vlocation_update_timeout = 10 * 60;
 
 static void afs_vlocation_reaper(struct work_struct *);
 static void afs_vlocation_updater(struct work_struct *);
@@ -335,7 +335,7 @@ static int afs_vlocation_fill_in_record(
 /*
  * queue a vlocation record for updates
  */
-void afs_vlocation_queue_for_updates(struct afs_vlocation *vl)
+static void afs_vlocation_queue_for_updates(struct afs_vlocation *vl)
 {
 	struct afs_vlocation *xvl;
 
diff -puN fs/afs/write.c~fs-afs-possible-cleanups fs/afs/write.c
--- a/fs/afs/write.c~fs-afs-possible-cleanups
+++ a/fs/afs/write.c
@@ -510,9 +510,9 @@ int afs_writepage(struct page *page, str
 /*
  * write a region of pages back to the server
  */
-int afs_writepages_region(struct address_space *mapping,
-			  struct writeback_control *wbc,
-			  pgoff_t index, pgoff_t end, pgoff_t *_next)
+static int afs_writepages_region(struct address_space *mapping,
+				 struct writeback_control *wbc,
+				 pgoff_t index, pgoff_t end, pgoff_t *_next)
 {
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	struct afs_writeback *wb;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
parisc-extern-inline-static-inline.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
unexport-pm_power_off_prepare.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
