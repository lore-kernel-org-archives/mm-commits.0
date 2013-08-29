From: akpm@linux-foundation.org
Subject: [obsolete]
 revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch removed from
 -mm tree
Date: Thu, 29 Aug 2013 11:31:41 -0700
Message-ID: <521f938d.6s9Y1ceKi63rXfXt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab3H2Sbn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 14:31:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peter@hurleysoftware.com, greg@kroah.com, eparis@redhat.com, akpm@linux-foundation.org

Subject: [obsolete] revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch removed from -mm tree
To: akpm@linux-foundation.org,eparis@redhat.com,greg@kroah.com,peter@hurleysoftware.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 11:31:41 -0700


The patch titled
     Subject: revert "SELinux: do not handle seclabel as a special flag"
has been removed from the -mm tree.  Its filename was
     revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "SELinux: do not handle seclabel as a special flag"

It breaks my FC6 test box.  /dev/pts is not mounted.  dmesg says

SELinux: mount invalid.  Same superblock, different security settings for (dev devpts, type devpts)

Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg KH <greg@kroah.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c            |    3 +++
 security/selinux/include/security.h |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN security/selinux/hooks.c~revert-selinux-do-not-handle-seclabel-as-a-special-flag security/selinux/hooks.c
--- a/security/selinux/hooks.c~revert-selinux-do-not-handle-seclabel-as-a-special-flag
+++ a/security/selinux/hooks.c
@@ -502,6 +502,9 @@ static int selinux_get_mnt_opts(const st
 			opts->num_mnt_opts++;
 		tmp >>= 1;
 	}
+	/* Check if the Label support flag is set */
+	if (sbsec->flags & SBLABEL_MNT)
+		opts->num_mnt_opts++;
 
 	opts->mnt_opts = kcalloc(opts->num_mnt_opts, sizeof(char *), GFP_ATOMIC);
 	if (!opts->mnt_opts) {
diff -puN security/selinux/include/security.h~revert-selinux-do-not-handle-seclabel-as-a-special-flag security/selinux/include/security.h
--- a/security/selinux/include/security.h~revert-selinux-do-not-handle-seclabel-as-a-special-flag
+++ a/security/selinux/include/security.h
@@ -43,7 +43,7 @@
 #endif
 
 /* Mask for just the mount related flags */
-#define SE_MNTMASK	0x1f
+#define SE_MNTMASK	0x0f
 /* Super block security struct flags for mount options */
 /* BE CAREFUL, these need to be the low order bits for selinux_get_mnt_opts */
 #define CONTEXT_MNT	0x01
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
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

