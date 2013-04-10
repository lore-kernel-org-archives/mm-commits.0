From: akpm@linux-foundation.org
Subject: + ipc-sysv-shared-memory-limited-to-8tib.patch added to -mm tree
Date: Wed, 10 Apr 2013 16:02:10 -0700
Message-ID: <20130410230210.7B27D5A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:58370 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937449Ab3DJXCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 19:02:12 -0400
Received: by mail-ie0-f202.google.com with SMTP id x12so163978ief.3
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 16:02:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, athorlton@sgi.com, stable@vger.kernel.org


The patch titled
     Subject: ipc: sysv shared memory limited to 8TiB
has been added to the -mm tree.  Its filename is
     ipc-sysv-shared-memory-limited-to-8tib.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Robin Holt <holt@sgi.com>
Reported-by: Alex Thorlton <athorlton@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
_

Patches currently in -mm which might be from holt@sgi.com are

ipc-sysv-shared-memory-limited-to-8tib.patch

