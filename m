From: akpm@linux-foundation.org
Subject: +
 ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix-fix.patch
 added to -mm tree
Date: Mon, 27 Oct 2014 13:18:14 -0700
Message-ID: <544ea886.jctcw1rXONCGoH5O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaJ0USO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Oct 2014 16:18:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, wangww631@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix-fix
has been added to the -mm tree.  Its filename is
     ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix-fix.patch

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
Subject: ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix-fix

loff_t is not u64

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/aops.c~ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix-fix fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix-fix
+++ a/fs/ocfs2/aops.c
@@ -649,7 +649,7 @@ static ssize_t ocfs2_direct_IO_write(str
 	unsigned int ext_flags = 0;
 
 	{
-		loff_t o = offset;
+		u64 o = offset;
 
 		zero_len = do_div(o, 1 << osb->s_clustersize_bits);
 		cluster_align = !!zero_len;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
mm-cma-make-kmemleak-ignore-cma-regions-fix.patch
mm-cma-make-kmemleak-ignore-cma-regions-fix-fix.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix-fix.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

