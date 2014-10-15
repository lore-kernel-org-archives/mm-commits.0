From: akpm@linux-foundation.org
Subject: +
 ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch added to -mm tree
Date: Wed, 15 Oct 2014 16:55:53 -0700
Message-ID: <543f0989.0vAw0YZbGSt2G+Z5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaJOXzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 19:55:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, wangww631@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix
has been added to the -mm tree.  Its filename is
     ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch

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
Subject: ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix

don't emit a call to _moddi3 on i386

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix
+++ a/fs/ocfs2/aops.c
@@ -29,6 +29,7 @@
 #include <linux/mpage.h>
 #include <linux/quotaops.h>
 #include <linux/blkdev.h>
+#include <linux/math64.h>
 
 #include <cluster/masklog.h>
 
@@ -640,13 +641,20 @@ static ssize_t ocfs2_direct_IO_write(str
 	journal_t *journal = osb->journal->j_journal;
 	u32 p_cpos = 0;
 	u32 v_cpos = ocfs2_clusters_for_bytes(osb->sb, offset);
-	u32 zero_len = offset % (1 << osb->s_clustersize_bits);
-	int cluster_align = offset % (1 << osb->s_clustersize_bits) ? 0 : 1;
+	u32 zero_len;
+	int cluster_align;
+	loff_t final_size = offset + count;
 	int append_write = offset >= i_size_read(inode) ? 1 : 0;
 	unsigned int num_clusters = 0;
 	unsigned int ext_flags = 0;
 
-	loff_t final_size = offset + count;
+	{
+		loff_t o = offset;
+
+		zero_len = do_div(o, 1 << osb->s_clustersize_bits);
+		cluster_align = !!zero_len;
+	}
+
 	/*
 	 * when final_size > inode->i_size, inode->i_size will be
 	 * updated after direct write, so add the inode to orphan
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

