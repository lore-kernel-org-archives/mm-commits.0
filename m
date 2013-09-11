From: akpm@linux-foundation.org
Subject: [folded-merged] ipc-drop-ipcctl_pre_down-fix.patch removed from
 -mm tree
Date: Wed, 11 Sep 2013 14:07:14 -0700
Message-ID: <5230db82.PBlroYYfWxei9y1T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab3IKVHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] ipc-drop-ipcctl_pre_down-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:07:14 -0700


The patch titled
     Subject: ipc-drop-ipcctl_pre_down-fix
has been removed from the -mm tree.  Its filename was
     ipc-drop-ipcctl_pre_down-fix.patch

This patch was dropped because it was folded into ipc-drop-ipcctl_pre_down.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-drop-ipcctl_pre_down-fix

fix function name in kerneldoc, cleanups

Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN ipc/util.c~ipc-drop-ipcctl_pre_down-fix ipc/util.c
--- a/ipc/util.c~ipc-drop-ipcctl_pre_down-fix
+++ a/ipc/util.c
@@ -733,7 +733,7 @@ int ipc_update_perm(struct ipc64_perm *i
 }
 
 /**
- * ipcctl_pre_down - retrieve an ipc and check permissions for some IPC_XXX cmd
+ * ipcctl_pre_down_nolock - retrieve an ipc and check permissions for some IPC_XXX cmd
  * @ns:  the ipc namespace
  * @ids:  the table of ids where to look for the ipc
  * @id:   the id of the ipc to retrieve
@@ -751,8 +751,8 @@ int ipc_update_perm(struct ipc64_perm *i
  * Call holding the both the rw_mutex and the rcu read lock.
  */
 struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
-					     struct ipc_ids *ids, int id, int cmd,
-					     struct ipc64_perm *perm, int extra_perm)
+					struct ipc_ids *ids, int id, int cmd,
+					struct ipc64_perm *perm, int extra_perm)
 {
 	kuid_t euid;
 	int err = -EPERM;
@@ -766,7 +766,8 @@ struct kern_ipc_perm *ipcctl_pre_down_no
 
 	audit_ipc_obj(ipcp);
 	if (cmd == IPC_SET)
-		audit_ipc_set_perm(extra_perm, perm->uid, perm->gid, perm->mode);
+		audit_ipc_set_perm(extra_perm, perm->uid,
+				   perm->gid, perm->mode);
 
 	euid = current_euid();
 	if (uid_eq(euid, ipcp->cuid) || uid_eq(euid, ipcp->uid)  ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
block-support-embedded-device-command-line-partition.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too.patch
swap-make-swap-discard-async.patch
swap-make-cluster-allocation-per-cpu.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-hotplug-verify-hotplug-memory-range.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-vmscan-fix-do_try_to_free_pages-livelock.patch
mm-page-writebackc-add-strictlimit-feature.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
lib-crc32-update-the-comments-of-crc32_bele_generic.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
partitions-efi-use-lba-aware-partition-records.patch
partitions-efi-check-pmbr-records-starting-lba.patch
partitions-efi-detect-hybrid-mbrs.patch
partitions-efi-some-style-cleanups.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch
ipc-drop-ipcctl_pre_down.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

