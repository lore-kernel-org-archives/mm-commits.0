From: akpm@linux-foundation.org
Subject: + make-shm_get_stat-more-robust.patch added to -mm tree
Date: Tue, 27 Jan 2009 15:00:29 -0800
Message-ID: <200901272300.n0RN0TuC030028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbZA0XAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 18:00:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tonyb@cybernetics.com, jkosina@suse.cz, olsajiri@gmail.com


The patch titled
     ipc: make shm_get_stat() more robust
has been added to the -mm tree.  Its filename is
     make-shm_get_stat-more-robust.patch

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
@@ -551,12 +551,14 @@ static void shm_get_stat(struct ipc_name
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
 
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from tonyb@cybernetics.com are

linux-next.patch
dmar-fix-endless-unknown-dmar-structure-type-loop.patch
shm-fix-shmctlshm_info-lockup-with-config_shmem.patch
make-shm_get_stat-more-robust.patch

