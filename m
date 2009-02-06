From: akpm@linux-foundation.org
Subject: [merged] shm-fix-shmctlshm_info-lockup-with-config_shmem.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:37:45 -0800
Message-ID: <200902061937.n16JbjnZ011263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754005AbZBFTiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyb@cybernetics.com, hugh@veritas.com, jkosina@suse.cz, olsajiri@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     shm: fix shmctl(SHM_INFO) lockup with !CONFIG_SHMEM
has been removed from the -mm tree.  Its filename was
     shm-fix-shmctlshm_info-lockup-with-config_shmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shm: fix shmctl(SHM_INFO) lockup with !CONFIG_SHMEM
From: Tony Battersby <tonyb@cybernetics.com>

shm_get_stat() assumes that the inode is a "struct shmem_inode_info",
which is incorrect for !CONFIG_SHMEM (see
fs/ramfs/inode.c::ramfs_get_inode() vs.  mm/shmem.c::shmem_get_inode()). 
This bad assumption can cause shmctl(SHM_INFO) to lockup when
shm_get_stat() tries to spin_lock(&info->lock).  Users of !CONFIG_SHMEM
may encounter this lockup simply by invoking the 'ipcs' command.

Reported by Jiri Olsa back in February 2008:
http://lkml.org/lkml/2008/2/29/74

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Reported-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: <stable@kernel.org>		[2.6.everything]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN ipc/shm.c~shm-fix-shmctlshm_info-lockup-with-config_shmem ipc/shm.c
--- a/ipc/shm.c~shm-fix-shmctlshm_info-lockup-with-config_shmem
+++ a/ipc/shm.c
@@ -565,11 +565,15 @@ static void shm_get_stat(struct ipc_name
 			struct hstate *h = hstate_file(shp->shm_file);
 			*rss += pages_per_huge_page(h) * mapping->nrpages;
 		} else {
+#ifdef CONFIG_SHMEM
 			struct shmem_inode_info *info = SHMEM_I(inode);
 			spin_lock(&info->lock);
 			*rss += inode->i_mapping->nrpages;
 			*swp += info->swapped;
 			spin_unlock(&info->lock);
+#else
+			*rss += inode->i_mapping->nrpages;
+#endif
 		}
 
 		total++;
_

Patches currently in -mm which might be from tonyb@cybernetics.com are

origin.patch
linux-next.patch
dmar-fix-endless-unknown-dmar-structure-type-loop.patch
make-shm_get_stat-more-robust.patch

