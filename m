From: akpm@linux-foundation.org
Subject: [folded] ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments-fix.patch removed from -mm tree
Date: Thu, 07 Jun 2012 14:17:26 -0700
Message-ID: <20120607211727.59C87A02F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:36745 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab2FGVRa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2012 17:17:30 -0400
Received: by lbbgp10 with SMTP id gp10so71501lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Jun 2012 14:17:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: shm: shm_fallocate use -ENOTSUPP
has been removed from the -mm tree.  Its filename was
     ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments-fix.patch

This patch was dropped because it was folded into ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from hughd@google.com are

origin.patch
shmem-replace_page-must-flush_dcache-and-others.patch
ipc-shm-restore-madv_remove-functionality-on-shared-memory-segments.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
linux-next.patch
tmpfs-implement-numa-node-interleaving.patch
tmpfs-implement-numa-node-interleaving-fix.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
prio_tree-debugging-patch.patch

