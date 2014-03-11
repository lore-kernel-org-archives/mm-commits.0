From: akpm@linux-foundation.org
Subject: [merged] revert-kallsyms-fix-absolute-addresses-for-kaslr.patch
 removed from -mm tree
Date: Tue, 11 Mar 2014 11:25:08 -0700
Message-ID: <531f5504.TEzSjrk/+Y2BYPhU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaCKSZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 14:25:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, mmarek@suse.cz, keescook@chromium.org, ahonig@google.com, akpm@linux-foundation.org

Subject: [merged] revert-kallsyms-fix-absolute-addresses-for-kaslr.patch removed from -mm tree
To: akpm@linux-foundation.org,ahonig@google.com,keescook@chromium.org,mmarek@suse.cz,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 11:25:08 -0700


The patch titled
     Subject: revert "kallsyms: fix absolute addresses for kASLR"
has been removed from the -mm tree.  Its filename was
     revert-kallsyms-fix-absolute-addresses-for-kaslr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "kallsyms: fix absolute addresses for kASLR"

Revert the recently applied 0f55159d091cb1e5 ("kallsyms: fix absolute
addresses for kASLR").  Kees said

: This got NAKed, please don't apply -- this patch works for x86 and
: ARM, but may cause problems for others:
: 
: https://lkml.org/lkml/2014/2/24/718

It appears that Kees will be fixing all this up for 3.15.

Cc: Andy Honig <ahonig@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/kallsyms.c~revert-kallsyms-fix-absolute-addresses-for-kaslr scripts/kallsyms.c
--- a/scripts/kallsyms.c~revert-kallsyms-fix-absolute-addresses-for-kaslr
+++ a/scripts/kallsyms.c
@@ -330,7 +330,8 @@ static void write_src(void)
 				printf("\tPTR\t_text + %#llx\n",
 					table[i].addr - _text);
 			else
-				printf("\tPTR\t%#llx\n", table[i].addr);
+				printf("\tPTR\t_text - %#llx\n",
+					_text - table[i].addr);
 		} else {
 			printf("\tPTR\t%#llx\n", table[i].addr);
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-propagate-error-to-user-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

