From: akpm@linux-foundation.org
Subject: [merged] tmpfs-enable-nosec-optimization.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:31 -0700
Message-ID: <20120531191531.6242EA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:58593 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab2EaTPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:32 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so75347bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andi@firstfloor.org, hch@infradead.org, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: enable NOSEC optimization
has been removed from the -mm tree.  Its filename was
     tmpfs-enable-nosec-optimization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: enable NOSEC optimization

Let tmpfs into the NOSEC optimization (avoiding file_remove_suid()
overhead on most common writes): set MS_NOSEC on its superblocks.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/shmem.c~tmpfs-enable-nosec-optimization mm/shmem.c
--- a/mm/shmem.c~tmpfs-enable-nosec-optimization
+++ a/mm/shmem.c
@@ -2373,6 +2373,7 @@ int shmem_fill_super(struct super_block 
 		}
 	}
 	sb->s_export_op = &shmem_export_ops;
+	sb->s_flags |= MS_NOSEC;
 #else
 	sb->s_flags |= MS_NOUSER;
 #endif
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

