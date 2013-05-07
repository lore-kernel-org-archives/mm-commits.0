From: akpm@linux-foundation.org
Subject: [merged] ipc-sysv-shared-memory-limited-to-8tib.patch removed from -mm tree
Date: Tue, 07 May 2013 10:52:33 -0700
Message-ID: <20130507175233.7CCE35A4111__6056.01750216937$1367949175$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:45352 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759623Ab3EGRwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:52:34 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so86573qec.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:52:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, athorlton@sgi.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: sysv shared memory limited to 8TiB
has been removed from the -mm tree.  Its filename was
     ipc-sysv-shared-memory-limited-to-8tib.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: ipc: sysv shared memory limited to 8TiB

Trying to run an application which was trying to put data into half of
memory using shmget(), we found that having a shmall value below 8EiB-8TiB
would prevent us from using anything more than 8TiB.  By setting
kernel.shmall greater than 8EiB-8TiB would make the job work.

In the newseg() function, ns->shm_tot which, at 8TiB is INT_MAX.

ipc/shm.c:
 458 static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 459 {
...
 465         int numpages = (size + PAGE_SIZE -1) >> PAGE_SHIFT;
...
 474         if (ns->shm_tot + numpages > ns->shm_ctlall)
 475                 return -ENOSPC;

[akpm@linux-foundation.org: make ipc/shm.c:newseg()'s numpages size_t, not int]
Signed-off-by: Robin Holt <holt@sgi.com>
Reported-by: Alex Thorlton <athorlton@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 +-
 ipc/shm.c                     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-sysv-shared-memory-limited-to-8tib include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-sysv-shared-memory-limited-to-8tib
+++ a/include/linux/ipc_namespace.h
@@ -43,8 +43,8 @@ struct ipc_namespace {
 
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
+	unsigned long	shm_tot;
 	int		shm_ctlmni;
-	int		shm_tot;
 	/*
 	 * Defines whether IPC_RMID is forced for _all_ shm segments regardless
 	 * of shmctl()
diff -puN ipc/shm.c~ipc-sysv-shared-memory-limited-to-8tib ipc/shm.c
--- a/ipc/shm.c~ipc-sysv-shared-memory-limited-to-8tib
+++ a/ipc/shm.c
@@ -462,7 +462,7 @@ static int newseg(struct ipc_namespace *
 	size_t size = params->u.size;
 	int error;
 	struct shmid_kernel *shp;
-	int numpages = (size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	size_t numpages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	struct file * file;
 	char name[13];
 	int id;
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

