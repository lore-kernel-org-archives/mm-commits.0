From: akpm@linux-foundation.org
Subject: + restore-shmid-as-inode-to-fix-proc-pid-maps-abi-breakage.patch added to -mm tree
Date: Fri, 08 Jun 2007 15:38:39 -0700
Message-ID: <200706082238.l58Mcdmn014598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60998 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969406AbXFHWis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 18:38:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, acahalan@gmail.com, ebiederm@xmission.com


The patch titled
     Restore shmid as inode# to fix /proc/pid/maps ABI breakage
has been added to the -mm tree.  Its filename is
     restore-shmid-as-inode-to-fix-proc-pid-maps-abi-breakage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Restore shmid as inode# to fix /proc/pid/maps ABI breakage
From: Badari Pulavarty <pbadari@us.ibm.com>

shmid used to be stored as inode# for shared memory segments. Some of
the proc-ps tools use this from /proc/pid/maps.  Recent cleanups
to newseg() changed it.  This patch sets inode number back to shared
memory id to fix breakage.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: "Albert Cahalan" <acahalan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN ipc/shm.c~restore-shmid-as-inode-to-fix-proc-pid-maps-abi-breakage ipc/shm.c
--- a/ipc/shm.c~restore-shmid-as-inode-to-fix-proc-pid-maps-abi-breakage
+++ a/ipc/shm.c
@@ -397,6 +397,11 @@ static int newseg (struct ipc_namespace 
 	shp->shm_nattch = 0;
 	shp->id = shm_buildid(ns, id, shp->shm_perm.seq);
 	shp->shm_file = file;
+	/*
+	 * shmid gets reported as "inode#" in /proc/pid/maps.
+	 * proc-ps tools use this. Changing this will break them.
+	 */
+	file->f_dentry->d_inode->i_ino = shp->id;
 
 	ns->shm_tot += numpages;
 	shm_unlock(shp);
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

move-three-functions-that-are-only-needed-for.patch
restore-shmid-as-inode-to-fix-proc-pid-maps-abi-breakage.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
