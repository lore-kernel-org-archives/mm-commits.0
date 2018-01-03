From: akpm@linux-foundation.org
Subject: + proc-fixup-comment.patch added to -mm tree
Date: Wed, 03 Jan 2018 15:36:32 -0800
Message-ID: <5a4d6900.v4vdQB7iOR27xkAP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60746 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbeACXge (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jan 2018 18:36:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/internal.h: fix up comment
has been added to the -mm tree.  Its filename is
     proc-fixup-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-fixup-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-fixup-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/proc/internal.h: fix up comment

Document what ->pde_unload_lock actually does.

Link: http://lkml.kernel.org/r/20180103185120.GB31849@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/internal.h~proc-fixup-comment fs/proc/internal.h
--- a/fs/proc/internal.h~proc-fixup-comment
+++ a/fs/proc/internal.h
@@ -38,7 +38,8 @@ struct proc_dir_entry {
 	atomic_t in_use;
 	atomic_t count;		/* use count */
 	struct list_head pde_openers;	/* who did ->open, but not ->release */
-	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
+	/* protects ->pde_openers and all struct pde_opener instances */
+	spinlock_t pde_unload_lock;
 	struct completion *pde_unload_completion;
 	const struct inode_operations *proc_iops;
 	const struct file_operations *proc_fops;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-use-%u-for-pid-printing-and-slightly-less-stack.patch
proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
proc-fix-proc-map_files-lookup.patch
proc-simpler-proc-vmcore-cleanup.patch
proc-less-memory-for-proc-map_files-readdir.patch
proc-delete-children_seq_release.patch
proc-rearrange-struct-proc_dir_entry.patch
proc-fixup-comment.patch
uuid-cleanup-uapi-linux-uuidh.patch
seq_file-delete-small-value-optimization.patch
cpumask-make-cpumask_size-return-unsigned-int.patch

