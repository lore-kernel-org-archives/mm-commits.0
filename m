From: akpm@linux-foundation.org
Subject: + fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
 added to -mm tree
Date: Fri, 09 Aug 2013 15:33:31 -0700
Message-ID: <52056e3b.hquNpRnQl6JWLOVx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031371Ab3HIWdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Aug 2013 18:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kees@outflux.net, glommer@openvz.org, dchinner@redhat.com, akpm@linux-foundation.org

Subject: + fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch added to -mm tree
To: akpm@linux-foundation.org,dchinner@redhat.com,glommer@openvz.org,kees@outflux.net
From: akpm@linux-foundation.org
Date: Fri, 09 Aug 2013 15:33:31 -0700


The patch titled
     Subject: fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2
has been added to the -mm tree.  Its filename is
     fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2

fix shadowed local, spell "skipped" correctly

Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Kees Cook <kees@outflux.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/extents_status.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ext4/extents_status.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2 fs/ext4/extents_status.c
--- a/fs/ext4/extents_status.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2
+++ a/fs/ext4/extents_status.c
@@ -946,15 +946,15 @@ static int __ext4_es_shrink(struct ext4_
 {
 	struct ext4_inode_info *ei;
 	struct list_head *cur, *tmp;
-	LIST_HEAD(skiped);
-	int ret, nr_shrunk = 0;
+	LIST_HEAD(skipped);
+	int nr_shrunk = 0;
 	int retried = 0, skip_precached = 1, nr_skipped = 0;
 
 	spin_lock(&sbi->s_es_lru_lock);
 
 retry:
 	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
-		int ret;
+		int shrunk;
 
 		/*
 		 * If we have already reclaimed all extents from extent
@@ -974,7 +974,7 @@ retry:
 		    (skip_precached && ext4_test_inode_state(&ei->vfs_inode,
 						EXT4_STATE_EXT_PRECACHED))) {
 			nr_skipped++;
-			list_move_tail(cur, &skiped);
+			list_move_tail(cur, &skipped);
 			continue;
 		}
 
@@ -982,19 +982,19 @@ retry:
 			continue;
 
 		write_lock(&ei->i_es_lock);
-		ret = __es_try_to_reclaim_extents(ei, nr_to_scan);
+		shrunk = __es_try_to_reclaim_extents(ei, nr_to_scan);
 		if (ei->i_es_lru_nr == 0)
 			list_del_init(&ei->i_es_lru);
 		write_unlock(&ei->i_es_lock);
 
-		nr_shrunk += ret;
-		nr_to_scan -= ret;
+		nr_shrunk += shrunk;
+		nr_to_scan -= shrunk;
 		if (nr_to_scan == 0)
 			break;
 	}
 
 	/* Move the newer inodes into the tail of the LRU list. */
-	list_splice_tail(&skiped, &sbi->s_es_lru);
+	list_splice_tail(&skipped, &sbi->s_es_lru);
 
 	/*
 	 * If we skipped any inodes, and we weren't able to make any
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-support-embedded-device-command-line-partition-fix.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
memcg-trivial-cleanups.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

