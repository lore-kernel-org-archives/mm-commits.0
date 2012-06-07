From: akpm@linux-foundation.org
Subject: + ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments-fix.patch added to -mm tree
Date: Thu, 07 Jun 2012 12:00:56 -0700
Message-ID: <20120607190056.F2055A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:52258 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab2FGTA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2012 15:00:59 -0400
Received: by eaao13 with SMTP id o13so60780eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Jun 2012 12:00:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, will.deacon@arm.com


The patch titled
     Subject: ipc: shm: shm_fallocate use -ENOTSUPP
has been added to the -mm tree.  Its filename is
     ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ipc: shm: shm_fallocate use -ENOTSUPP

When underlying filesystem (i.e.  hugetlbfs) does not support fallocate(),
let shm_fallocate() fail with -EOPNOTSUPP rather than -EINVAL: so that
madvise(,,MADV_REMOVE) gives the same error as it does wherever else
fallocate() is unsupported.  vmtruncate_range() gave -ENOSYS in this case,
but that was not quite right.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/shm.c~ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments-fix ipc/shm.c
--- a/ipc/shm.c~ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments-fix
+++ a/ipc/shm.c
@@ -399,7 +399,7 @@ static long shm_fallocate(struct file *f
 	struct shm_file_data *sfd = shm_file_data(file);
 
 	if (!sfd->file->f_op->fallocate)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	return sfd->file->f_op->fallocate(file, mode, offset, len);
 }
 
_
Subject: Subject: ipc: shm: shm_fallocate use -ENOTSUPP

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
shmem-replace_page-must-flush_dcache-and-others.patch
ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments.patch
ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
tmpfs-implement-numa-node-interleaving.patch
tmpfs-implement-numa-node-interleaving-fix.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
prio_tree-debugging-patch.patch

