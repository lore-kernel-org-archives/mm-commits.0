From: akpm@linux-foundation.org
Subject: - fs-dlm-astc-fix-warning.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:18:48 -0800
Message-ID: <200812291918.mBTJIm0K031105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbYL2TTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:19:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, swhiteho@redhat.com, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fs/dlm/ast.c: fix warning
has been removed from the -mm tree.  Its filename was
     fs-dlm-astc-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/dlm/ast.c: fix warning
From: Andrew Morton <akpm@linux-foundation.org>

fs/dlm/ast.c: In function 'dlm_astd':
fs/dlm/ast.c:64: warning: 'bastmode' may be used uninitialized in this function

Cleans code up.

Might be wrong.

This is an O(n*n) search :(

Cc: David Teigland <teigland@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/ast.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff -puN fs/dlm/ast.c~fs-dlm-astc-fix-warning fs/dlm/ast.c
--- a/fs/dlm/ast.c~fs-dlm-astc-fix-warning
+++ a/fs/dlm/ast.c
@@ -61,30 +61,23 @@ static void process_asts(void)
 	struct dlm_lkb *lkb;
 	void (*cast) (void *astparam);
 	void (*bast) (void *astparam, int mode);
-	int type = 0, found, bastmode;
+	int type = 0, bastmode;
 
-	for (;;) {
-		found = 0;
-		spin_lock(&ast_queue_lock);
-		list_for_each_entry(lkb, &ast_queue, lkb_astqueue) {
-			r = lkb->lkb_resource;
-			ls = r->res_ls;
-
-			if (dlm_locking_stopped(ls))
-				continue;
-
-			list_del(&lkb->lkb_astqueue);
-			type = lkb->lkb_ast_type;
-			lkb->lkb_ast_type = 0;
-			bastmode = lkb->lkb_bastmode;
-			found = 1;
-			break;
-		}
-		spin_unlock(&ast_queue_lock);
-
-		if (!found)
-			break;
+repeat:
+	spin_lock(&ast_queue_lock);
+	list_for_each_entry(lkb, &ast_queue, lkb_astqueue) {
+		r = lkb->lkb_resource;
+		ls = r->res_ls;
+
+		if (dlm_locking_stopped(ls))
+			continue;
+
+		list_del(&lkb->lkb_astqueue);
+		type = lkb->lkb_ast_type;
+		lkb->lkb_ast_type = 0;
+		bastmode = lkb->lkb_bastmode;
 
+		spin_unlock(&ast_queue_lock);
 		cast = lkb->lkb_astfn;
 		bast = lkb->lkb_bastfn;
 
@@ -99,7 +92,9 @@ static void process_asts(void)
 		dlm_put_lkb(lkb);
 
 		cond_resched();
+		goto repeat;
 	}
+	spin_unlock(&ast_queue_lock);
 }
 
 static inline int no_asts(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes.patch
smp_call_function_single-be-slightly-less-stupid.patch
binfmtsh-include-listh-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
dma_alloc_from_coherent-fix-fallback-to-generic-memory.patch
dma_alloc_coherent-clean-it-up.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

