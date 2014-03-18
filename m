From: akpm@linux-foundation.org
Subject: + fs-inodec-inode_lru_isolate-use-atomic-count_vm_events.patch
 added to -mm tree
Date: Tue, 18 Mar 2014 14:22:20 -0700
Message-ID: <5328b90c.Uk7wCp1pQtQ2nvKh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaCRVWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Mar 2014 17:22:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, cl@linux-foundation.org, akpm@linux-foundation.org

Subject: + fs-inodec-inode_lru_isolate-use-atomic-count_vm_events.patch added to -mm tree
To: akpm@linux-foundation.org,cl@linux-foundation.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 18 Mar 2014 14:22:20 -0700


The patch titled
     Subject: fs/inode.c:inode_lru_isolate(): use atomic count_vm_events()
has been added to the -mm tree.  Its filename is
     fs-inodec-inode_lru_isolate-use-atomic-count_vm_events.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-inodec-inode_lru_isolate-use-atomic-count_vm_events.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-inodec-inode_lru_isolate-use-atomic-count_vm_events.patch

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
Subject: fs/inode.c:inode_lru_isolate(): use atomic count_vm_events()

"percpu: add preemption checks to __this_cpu ops" added preempt check to
used in __count_vm_events() __this_cpu ops, causing the following kswapd
warning:

 BUG: using __this_cpu_add() in preemptible [00000000] code: kswapd0/56
 caller is __this_cpu_preempt_check+0x2b/0x2d
 Call Trace:
 [<ffffffff813b8d4d>] dump_stack+0x4e/0x7a
 [<ffffffff8121366f>] check_preemption_disabled+0xce/0xdd
 [<ffffffff812136bb>] __this_cpu_preempt_check+0x2b/0x2d
 [<ffffffff810f622e>] inode_lru_isolate+0xed/0x197
 [<ffffffff810be43c>] list_lru_walk_node+0x7b/0x14c
 [<ffffffff810f6141>] ? iput+0x131/0x131
 [<ffffffff810f681f>] prune_icache_sb+0x35/0x4c

Switch from __count_vm_events() to the preempt-safe count_vm_events().

Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/inode.c~fs-inodec-inode_lru_isolate-use-atomic-count_vm_events fs/inode.c
--- a/fs/inode.c~fs-inodec-inode_lru_isolate-use-atomic-count_vm_events
+++ a/fs/inode.c
@@ -722,9 +722,9 @@ inode_lru_isolate(struct list_head *item
 			unsigned long reap;
 			reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
 			if (current_is_kswapd())
-				__count_vm_events(KSWAPD_INODESTEAL, reap);
+				count_vm_events(KSWAPD_INODESTEAL, reap);
 			else
-				__count_vm_events(PGINODESTEAL, reap);
+				count_vm_events(PGINODESTEAL, reap);
 			if (current->reclaim_state)
 				current->reclaim_state->reclaimed_slab += reap;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix-6-fix.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
fs-inodec-inode_lru_isolate-use-atomic-count_vm_events.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
befs-logging-clean-up-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

