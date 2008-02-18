From: akpm@linux-foundation.org
Subject: + fs-aioc-make-3-functions-static.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:11:43 -0800
Message-ID: <200802181012.m1IACfvC019589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35940 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756606AbYBRKSk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:18:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bcrl@kvack.org, pbadari@us.ibm.com, zach.brown@oracle.com


The patch titled
     fs/aio.c: make 3 functions static
has been added to the -mm tree.  Its filename is
     fs-aioc-make-3-functions-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/aio.c: make 3 functions static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global functions static:

- __put_ioctx()
- lookup_ioctx()
- io_submit_one()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c            |   67 ++++++++++++++++++++++++------------------
 include/linux/aio.h |   19 -----------
 2 files changed, 39 insertions(+), 47 deletions(-)

diff -puN fs/aio.c~fs-aioc-make-3-functions-static fs/aio.c
--- a/fs/aio.c~fs-aioc-make-3-functions-static
+++ a/fs/aio.c
@@ -191,6 +191,43 @@ static int aio_setup_ring(struct kioctx 
 	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK), km); \
 } while(0)
 
+
+/* __put_ioctx
+ *	Called when the last user of an aio context has gone away,
+ *	and the struct needs to be freed.
+ */
+static void __put_ioctx(struct kioctx *ctx)
+{
+	unsigned nr_events = ctx->max_reqs;
+
+	BUG_ON(ctx->reqs_active);
+
+	cancel_delayed_work(&ctx->wq);
+	cancel_work_sync(&ctx->wq.work);
+	aio_free_ring(ctx);
+	mmdrop(ctx->mm);
+	ctx->mm = NULL;
+	pr_debug("__put_ioctx: freeing %p\n", ctx);
+	kmem_cache_free(kioctx_cachep, ctx);
+
+	if (nr_events) {
+		spin_lock(&aio_nr_lock);
+		BUG_ON(aio_nr - nr_events > aio_nr);
+		aio_nr -= nr_events;
+		spin_unlock(&aio_nr_lock);
+	}
+}
+
+#define get_ioctx(kioctx) do {						\
+	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
+	atomic_inc(&(kioctx)->users);					\
+} while (0)
+#define put_ioctx(kioctx) do {						\
+	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
+	if (unlikely(atomic_dec_and_test(&(kioctx)->users))) 		\
+		__put_ioctx(kioctx);					\
+} while (0)
+
 /* ioctx_alloc
  *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
  */
@@ -361,32 +398,6 @@ void exit_aio(struct mm_struct *mm)
 	}
 }
 
-/* __put_ioctx
- *	Called when the last user of an aio context has gone away,
- *	and the struct needs to be freed.
- */
-void __put_ioctx(struct kioctx *ctx)
-{
-	unsigned nr_events = ctx->max_reqs;
-
-	BUG_ON(ctx->reqs_active);
-
-	cancel_delayed_work(&ctx->wq);
-	cancel_work_sync(&ctx->wq.work);
-	aio_free_ring(ctx);
-	mmdrop(ctx->mm);
-	ctx->mm = NULL;
-	pr_debug("__put_ioctx: freeing %p\n", ctx);
-	kmem_cache_free(kioctx_cachep, ctx);
-
-	if (nr_events) {
-		spin_lock(&aio_nr_lock);
-		BUG_ON(aio_nr - nr_events > aio_nr);
-		aio_nr -= nr_events;
-		spin_unlock(&aio_nr_lock);
-	}
-}
-
 /* aio_get_req
  *	Allocate a slot for an aio request.  Increments the users count
  * of the kioctx so that the kioctx stays around until all requests are
@@ -545,7 +556,7 @@ int aio_put_req(struct kiocb *req)
 /*	Lookup an ioctx id.  ioctx_list is lockless for reads.
  *	FIXME: this is O(n) and is only suitable for development.
  */
-struct kioctx *lookup_ioctx(unsigned long ctx_id)
+static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 {
 	struct kioctx *ioctx;
 	struct mm_struct *mm;
@@ -1533,7 +1544,7 @@ static int aio_wake_function(wait_queue_
 	return 1;
 }
 
-int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
+static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb)
 {
 	struct kiocb *req;
diff -puN include/linux/aio.h~fs-aioc-make-3-functions-static include/linux/aio.h
--- a/include/linux/aio.h~fs-aioc-make-3-functions-static
+++ a/include/linux/aio.h
@@ -209,27 +209,8 @@ extern ssize_t wait_on_sync_kiocb(struct
 extern int aio_put_req(struct kiocb *iocb);
 extern void kick_iocb(struct kiocb *iocb);
 extern int aio_complete(struct kiocb *iocb, long res, long res2);
-extern void __put_ioctx(struct kioctx *ctx);
 struct mm_struct;
 extern void exit_aio(struct mm_struct *mm);
-extern struct kioctx *lookup_ioctx(unsigned long ctx_id);
-extern int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 struct iocb *iocb);
-
-/* semi private, but used by the 32bit emulations: */
-struct kioctx *lookup_ioctx(unsigned long ctx_id);
-int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-		  struct iocb *iocb);
-
-#define get_ioctx(kioctx) do {						\
-	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
-	atomic_inc(&(kioctx)->users);					\
-} while (0)
-#define put_ioctx(kioctx) do {						\
-	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
-	if (unlikely(atomic_dec_and_test(&(kioctx)->users))) 		\
-		__put_ioctx(kioctx);					\
-} while (0)
 
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
 
_

Patches currently in -mm which might be from bunk@kernel.org are

git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops.patch
gfs2-ops_filec-should-include-ops_inodeh.patch
git-kbuild.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
make-ocfs2_downconvert_thread-static.patch
ocfs-make-dlm_do_assert_master-static.patch
if-0-pci_cleanup_aer_correct_error_status.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
make-lpfc_disable_node-static.patch
if-0-ses_match_host.patch
scsi_transport_iscsic-make-2-functions-static.patch
remove-ps2esdi.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ipwireless-remove-dead-code.patch
git-xtensa.patch
sparc-fix-build.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-printk_recursion_bug_msg-static.patch
make-udf_error-static.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-block_devc-remove-if-0ed-code.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
make-struct-def_blk_aops-static.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
