From: akpm@linux-foundation.org
Subject: + shm-fix-shmctlshm_info-lockup-with-config_shmem.patch added to -mm tree
Date: Tue, 27 Jan 2009 14:54:30 -0800
Message-ID: <200901272254.n0RMsU8V022801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbZA0Wyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 17:54:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tonyb@cybernetics.com, hugh@veritas.com, jkosina@suse.cz, olsajiri@gmail.com, stable@kernel.org


The patch titled
     shm: fix shmctl(SHM_INFO) lockup with !CONFIG_SHMEM
has been added to the -mm tree.  Its filename is
     shm-fix-shmctlshm_info-lockup-with-config_shmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
dmar-fix-endless-unknown-dmar-structure-type-loop.patch
shm-fix-shmctlshm_info-lockup-with-config_shmem.patch

