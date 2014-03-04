From: akpm@linux-foundation.org
Subject: + mm-per-thread-vma-caching-fix-fix.patch added to -mm tree
Date: Tue, 04 Mar 2014 12:00:33 -0800
Message-ID: <531630e1.ZZ5E2RuJr6m+LwIT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbaCDUAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 15:00:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, torvalds@linux-foundation.org, riel@redhat.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: + mm-per-thread-vma-caching-fix-fix.patch added to -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,riel@redhat.com,torvalds@linux-foundation.org,walken@google.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 12:00:33 -0800


The patch titled
     Subject: mm-per-thread-vma-caching-fix-fix
has been added to the -mm tree.  Its filename is
     mm-per-thread-vma-caching-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-per-thread-vma-caching-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-per-thread-vma-caching-fix-fix.patch

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
Subject: mm-per-thread-vma-caching-fix-fix

document vmacache_valid() logic

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmacache.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/vmacache.c~mm-per-thread-vma-caching-fix-fix mm/vmacache.c
--- a/mm/vmacache.c~mm-per-thread-vma-caching-fix-fix
+++ a/mm/vmacache.c
@@ -40,6 +40,12 @@ static bool vmacache_valid(struct mm_str
 {
 	struct task_struct *curr = current;
 
+	/*
+	 * This task may be accessing a foreign mm via (for example)
+	 * get_user_pages()->find_vma().  The vmacache is task-local and this
+	 * task's vmacache pertains to a different mm (ie, its own).  There is
+	 * nothing we can do here.
+	 */
 	if (mm != curr->mm)
 		return false;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
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
mm-per-thread-vma-caching-fix.patch
mm-per-thread-vma-caching-fix-fix.patch
zram-use-zcomp-compressing-backends-fix.patch
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
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

