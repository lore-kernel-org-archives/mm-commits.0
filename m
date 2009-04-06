From: akpm@linux-foundation.org
Subject: [merged] make-shm_get_stat-more-robust.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:04 -0700
Message-ID: <200904061936.n36Ja4AN012290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbZDFUMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:12:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyb@cybernetics.com, jkosina@suse.cz, olsajiri@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc: make shm_get_stat() more robust
has been removed from the -mm tree.  Its filename was
     make-shm_get_stat-more-robust.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: make shm_get_stat() more robust
From: Tony Battersby <tonyb@cybernetics.com>

shm_get_stat() assumes idr_find(&shm_ids(ns).ipcs_idr) returns "struct
shmid_kernel *"; all other callers assume that it returns "struct
kern_ipc_perm *".  This works because "struct kern_ipc_perm" is currently
the first member of "struct shmid_kernel", but it would be better to use
container_of() to prevent future breakage.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN ipc/shm.c~make-shm_get_stat-more-robust ipc/shm.c
--- a/ipc/shm.c~make-shm_get_stat-more-robust
+++ a/ipc/shm.c
@@ -555,12 +555,14 @@ static void shm_get_stat(struct ipc_name
 	in_use = shm_ids(ns).in_use;
 
 	for (total = 0, next_id = 0; total < in_use; next_id++) {
+		struct kern_ipc_perm *ipc;
 		struct shmid_kernel *shp;
 		struct inode *inode;
 
-		shp = idr_find(&shm_ids(ns).ipcs_idr, next_id);
-		if (shp == NULL)
+		ipc = idr_find(&shm_ids(ns).ipcs_idr, next_id);
+		if (ipc == NULL)
 			continue;
+		shp = container_of(ipc, struct shmid_kernel, shm_perm);
 
 		inode = shp->shm_file->f_path.dentry->d_inode;
 
_

Patches currently in -mm which might be from tonyb@cybernetics.com are

origin.patch
vfs-improve-comment-describing-fget_light.patch

