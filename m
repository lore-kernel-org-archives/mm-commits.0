From: akpm@linux-foundation.org
Subject: + sys_semctl-fix-kernel-stack-leakage.patch added to -mm tree
Date: Thu, 23 Sep 2010 15:06:03 -0700
Message-ID: <201009232206.o8NM63YZ021919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755794Ab0IWWGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 18:06:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, dan.j.rosenberg@gmail.com, manfred@colorfullife.com


The patch titled
     sys_semctl: fix kernel stack leakage
has been added to the -mm tree.  Its filename is
     sys_semctl-fix-kernel-stack-leakage.patch

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
Subject: sys_semctl: fix kernel stack leakage
From: Dan Rosenberg <drosenberg@vsecurity.com>

The semctl syscall has several code paths that lead to the leakage of
uninitialized kernel stack memory (namely the IPC_INFO, SEM_INFO,
IPC_STAT, and SEM_STAT commands) during the use of the older, obsolete
version of the semid_ds struct.

The copy_semid_to_user() function declares a semid_ds struct on the stack
and copies it back to the user without initializing or zeroing the
"sem_base", "sem_pending", "sem_pending_last", and "undo" pointers,
allowing the leakage of 16 bytes of kernel stack memory.

The code is still reachable on 32-bit systems - when calling semctl()
newer glibc's automatically OR the IPC command with the IPC_64 flag, but
invoking the syscall directly allows users to use the older versions of
the struct.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN ipc/sem.c~sys_semctl-fix-kernel-stack-leakage ipc/sem.c
--- a/ipc/sem.c~sys_semctl-fix-kernel-stack-leakage
+++ a/ipc/sem.c
@@ -743,6 +743,8 @@ static unsigned long copy_semid_to_user(
 	    {
 		struct semid_ds out;
 
+		memset(&out, 0, sizeof(out));
+
 		ipc64_perm_to_ipc_perm(&in->sem_perm, &out.sem_perm);
 
 		out.sem_otime	= in->sem_otime;
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

origin.patch
sys_semctl-fix-kernel-stack-leakage.patch
drivers-serial-serial_corec-prevent-reading-uninitialized-stack-memory.patch
drivers-char-amiserialc-prevent-reading-uninitialized-stack-memory.patch
drivers-char-nozomic-prevent-reading-uninitialized-stack-memory.patch

