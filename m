From: akpm@linux-foundation.org
Subject: + nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch added to -mm tree
Date: Mon, 08 Dec 2008 14:47:42 -0800
Message-ID: <200812082247.mB8MlgPV017020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbYLHWs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 17:48:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, staubach@redhat.com


The patch titled
     nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#43: FILE: fs/nfs/dir.c:1797:
+	if (!time_in_range_open(jiffies, cache->jiffies, cache->jiffies + nfsi->attrtimeo))

WARNING: line over 80 characters
#62: FILE: fs/nfs/inode.c:715:
+	return !time_in_range_open(jiffies, nfsi->read_cache_jiffies, nfsi->read_cache_jiffies + nfsi->attrtimeo);

WARNING: line over 80 characters
#71: FILE: fs/nfs/inode.c:1178:
+		if (!time_in_range_open(now, nfsi->attrtimeo_timestamp, nfsi->attrtimeo_timestamp + nfsi->attrtimeo)) {

ERROR: space required after that ',' (ctx:VxV)
#92: FILE: include/linux/jiffies.h:128:
+#define time_in_range_open(a,b,c) \
                             ^

ERROR: space required after that ',' (ctx:VxV)
#93: FILE: include/linux/jiffies.h:129:
+	(time_after_eq(a,b) && \
 	                ^

ERROR: space required after that ',' (ctx:VxV)
#94: FILE: include/linux/jiffies.h:130:
+	 time_before(a,c))
 	              ^

total: 3 errors, 3 warnings, 70 lines checked

./patches/nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Peter Staubach <staubach@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/dir.c            |    3 ++-
 fs/nfs/inode.c          |    6 ++++--
 include/linux/jiffies.h |    5 ++---
 3 files changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/nfs/dir.c~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes fs/nfs/dir.c
--- a/fs/nfs/dir.c~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes
+++ a/fs/nfs/dir.c
@@ -1794,7 +1794,8 @@ static int nfs_access_get_cached(struct 
 	cache = nfs_access_search_rbtree(inode, cred);
 	if (cache == NULL)
 		goto out;
-	if (!time_in_range_open(jiffies, cache->jiffies, cache->jiffies + nfsi->attrtimeo))
+	if (!time_in_range_open(jiffies, cache->jiffies,
+				cache->jiffies + nfsi->attrtimeo))
 		goto out_stale;
 	res->jiffies = cache->jiffies;
 	res->cred = cache->cred;
diff -puN fs/nfs/inode.c~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes
+++ a/fs/nfs/inode.c
@@ -712,7 +712,8 @@ int nfs_attribute_timeout(struct inode *
 
 	if (nfs_have_delegation(inode, FMODE_READ))
 		return 0;
-	return !time_in_range_open(jiffies, nfsi->read_cache_jiffies, nfsi->read_cache_jiffies + nfsi->attrtimeo);
+	return !time_in_range_open(jiffies, nfsi->read_cache_jiffies,
+				nfsi->read_cache_jiffies + nfsi->attrtimeo);
 }
 
 /**
@@ -1175,7 +1176,8 @@ static int nfs_update_inode(struct inode
 		nfsi->attrtimeo_timestamp = now;
 		nfsi->attr_gencount = nfs_inc_attr_generation_counter();
 	} else {
-		if (!time_in_range_open(now, nfsi->attrtimeo_timestamp, nfsi->attrtimeo_timestamp + nfsi->attrtimeo)) {
+		if (!time_in_range_open(now, nfsi->attrtimeo_timestamp,
+				nfsi->attrtimeo_timestamp + nfsi->attrtimeo)) {
 			if ((nfsi->attrtimeo <<= 1) > NFS_MAXATTRTIMEO(inode))
 				nfsi->attrtimeo = NFS_MAXATTRTIMEO(inode);
 			nfsi->attrtimeo_timestamp = now;
diff -puN include/linux/jiffies.h~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes include/linux/jiffies.h
--- a/include/linux/jiffies.h~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes
+++ a/include/linux/jiffies.h
@@ -125,9 +125,8 @@ static inline u64 get_jiffies_64(void)
 /*
  * Calculate whether a is in the range of [b, c).
  */
-#define time_in_range_open(a,b,c) \
-	(time_after_eq(a,b) && \
-	 time_before(a,c))
+#define time_in_range_open(a, b, c) \
+	(time_after_eq(a, b) && time_before(a,c))
 
 /* Same as above, but does so with platform independent 64bit types.
  * These must be used when utilizing jiffies_64 (i.e. return value of
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-backing-devc-remove-recently-added-warn_on.patch
revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch
revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
backlight-catch-invalid-input.patch
pci-uninline-pci_ioremap_bar.patch
drivers-char-cycladesc-cy_pci_probe-fix-error-path.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods-fix.patch
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

