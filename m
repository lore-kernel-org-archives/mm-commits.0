From: akpm@linux-foundation.org
Subject: + ipccompat-remove-sc_semopm-macro.patch added to -mm tree
Date: Tue, 18 Feb 2014 13:39:37 -0800
Message-ID: <5303d319.Cnm5ojx1JeuIK/9+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBRVji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 16:39:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, davidlohr@hp.com

Subject: + ipccompat-remove-sc_semopm-macro.patch added to -mm tree
To: davidlohr@hp.com,manfred@colorfullife.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 13:39:37 -0800


The patch titled
     Subject: ipc/compat.c: remove sc_semopm macro
has been added to the -mm tree.  Its filename is
     ipccompat-remove-sc_semopm-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipccompat-remove-sc_semopm-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipccompat-remove-sc_semopm-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc/compat.c: remove sc_semopm macro

This macro appears to have been introduced back in the 2.5 era for
semtimedop32 backward compatibility on ia32:

https://lkml.org/lkml/2003/4/28/78

Nowadays, this syscall in compat just defaults back to the code found in
sem.c, so it is no longer used and can thus be removed:

long compat_sys_semtimedop(int semid, struct sembuf __user *tsems,
		unsigned nsops, const struct compat_timespec __user *timeout)
{
	struct timespec __user *ts64;
	if (compat_convert_timespec(&ts64, timeout))
		return -EFAULT;
	return sys_semtimedop(semid, tsems, nsops, ts64);
}

Furthermore, there are no users in compat.c.  After this change, kernel
builds just fine with both CONFIG_SYSVIPC_COMPAT and CONFIG_SYSVIPC.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/compat.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN ipc/compat.c~ipccompat-remove-sc_semopm-macro ipc/compat.c
--- a/ipc/compat.c~ipccompat-remove-sc_semopm-macro
+++ a/ipc/compat.c
@@ -113,9 +113,6 @@ struct compat_shm_info {
 	compat_ulong_t swap_attempts, swap_successes;
 };
 
-extern int sem_ctls[];
-#define sc_semopm	(sem_ctls[2])
