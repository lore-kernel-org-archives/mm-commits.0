From: akpm@linux-foundation.org
Subject: +
 ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits-fix.patch added to -mm tree
Date: Tue, 11 Aug 2015 14:07:03 -0700
Message-ID: <55ca63f7.3waihvERsAPIoieM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbbHKVHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Aug 2015 17:07:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, herton@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits-fix
has been added to the -mm tree.  Its filename is
     ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits-fix.patch

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
Subject: ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits-fix

use normal comment layout

Cc: "Herton R. Krzesinski" <herton@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits-fix ipc/sem.c
--- a/ipc/sem.c~ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits-fix
+++ a/ipc/sem.c
@@ -2075,10 +2075,12 @@ void exit_sem(struct task_struct *tsk)
 		un = list_entry_rcu(ulp->list_proc.next,
 				    struct sem_undo, list_proc);
 		if (&un->list_proc == &ulp->list_proc) {
-			/* we must wait for freeary() before freeing this ulp,
+			/*
+			 * We must wait for freeary() before freeing this ulp,
 			 * in case we raced with last sem_undo. There is a small
 			 * possibility where we exit while freeary() didn't
-			 * finish unlocking sem_undo_list */
+			 * finish unlocking sem_undo_list.
+			 */
 			spin_unlock_wait(&ulp->lock);
 			rcu_read_unlock();
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits-fix.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch
mm-mlock-add-new-mlock-system-call-checkpatch-fixes.patch
mm-introduce-vm_lockonfault-checkpatch-fixes.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zswap-dynamic-pool-creation-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

