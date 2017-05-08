From: akpm@linux-foundation.org
Subject: [patch 050/114] ipc/shm: some shmat cleanups
Date: Mon, 08 May 2017 15:57:03 -0700
Message-ID: <20170508225703.cn7ADV3n5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752482AbdEHW5E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/shm: some shmat cleanups

Clean up early flag and address some minutia.

Link: http://lkml.kernel.org/r/1486673582-6979-3-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN ipc/shm.c~ipc-shm-some-shmat-cleanups ipc/shm.c
--- a/ipc/shm.c~ipc-shm-some-shmat-cleanups
+++ a/ipc/shm.c
@@ -1095,11 +1095,11 @@ long do_shmat(int shmid, char __user *sh
 	      ulong *raddr, unsigned long shmlba)
 {
 	struct shmid_kernel *shp;
-	unsigned long addr;
+	unsigned long addr = (unsigned long)shmaddr;
 	unsigned long size;
 	struct file *file;
 	int    err;
-	unsigned long flags;
+	unsigned long flags = MAP_SHARED;
 	unsigned long prot;
 	int acc_mode;
 	struct ipc_namespace *ns;
@@ -1111,7 +1111,8 @@ long do_shmat(int shmid, char __user *sh
 	err = -EINVAL;
 	if (shmid < 0)
 		goto out;
-	else if ((addr = (ulong)shmaddr)) {
+
+	if (addr) {
 		if (addr & (shmlba - 1)) {
 			/*
 			 * Round down to the nearest multiple of shmlba.
@@ -1126,13 +1127,10 @@ long do_shmat(int shmid, char __user *sh
 #endif
 					goto out;
 		}
-		flags = MAP_SHARED | MAP_FIXED;
-	} else {
-		if ((shmflg & SHM_REMAP))
-			goto out;
 
-		flags = MAP_SHARED;
-	}
+		flags |= MAP_FIXED;
+	} else if ((shmflg & SHM_REMAP))
+		goto out;
 
 	if (shmflg & SHM_RDONLY) {
 		prot = PROT_READ;
_
