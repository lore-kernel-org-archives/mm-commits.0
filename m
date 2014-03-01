From: akpm@linux-foundation.org
Subject: +
 ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch added to -mm tree
Date: Fri, 28 Feb 2014 16:09:01 -0800
Message-ID: <5311251d./cuYnk12/K5nSyXi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaCAAJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 19:09:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wen.gang.wang@oracle.com, mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org

Subject: + ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,jlbec@evilplan.org,mfasheh@suse.com,wen.gang.wang@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 16:09:01 -0800


The patch titled
     Subject: ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch

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
Subject: ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes

WARNING: braces {} are not necessary for single statement blocks
#26: FILE: fs/ocfs2/locks.c:85:
+	if (ret) {
+		ocfs2_file_unlock(file);
+	}

total: 0 errors, 1 warnings, 9 lines checked

./patches/ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/locks.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ocfs2/locks.c~ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes fs/ocfs2/locks.c
--- a/fs/ocfs2/locks.c~ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes
+++ a/fs/ocfs2/locks.c
@@ -82,9 +82,8 @@ static int ocfs2_do_flock(struct file *f
 	}
 
 	ret = flock_lock_file_wait(file, fl);
-	if (ret) {
+	if (ret)
 		ocfs2_file_unlock(file);
-	}
 
 out:
 	mutex_unlock(&fp->fp_mutex);
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
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2-checkpatch-fixes.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
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
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

