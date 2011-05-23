From: akpm@linux-foundation.org
Subject: [merged] ipc-add-missing-sys_ni-entries-for-ipc-compatc-functions.patch removed from -mm tree
Date: Mon, 23 May 2011 12:14:16 -0700
Message-ID: <201105231912.p4NJCwo4005807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756219Ab1EWTNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 May 2011 15:13:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cernekee@gmail.com, arnd@arndb.de, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     ipc: add missing sys_ni entries for ipc/compat.c functions
has been removed from the -mm tree.  Its filename was
     ipc-add-missing-sys_ni-entries-for-ipc-compatc-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: add missing sys_ni entries for ipc/compat.c functions
From: Kevin Cernekee <cernekee@gmail.com>

When building with:

CONFIG_64BIT=y
CONFIG_MIPS32_COMPAT=y
CONFIG_COMPAT=y
CONFIG_MIPS32_O32=y
CONFIG_MIPS32_N32=y
CONFIG_SYSVIPC is not set
(and implicitly: CONFIG_SYSVIPC_COMPAT is not set)

the final link fails with unresolved symbols for:

compat_sys_semctl, compat_sys_msgsnd, compat_sys_msgrcv,
compat_sys_shmctl, compat_sys_msgctl, compat_sys_semtimedop

The fix is to add cond_syscall declarations for all syscalls in
ipc/compat.c

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys_ni.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN kernel/sys_ni.c~ipc-add-missing-sys_ni-entries-for-ipc-compatc-functions kernel/sys_ni.c
--- a/kernel/sys_ni.c~ipc-add-missing-sys_ni-entries-for-ipc-compatc-functions
+++ a/kernel/sys_ni.c
@@ -71,15 +71,22 @@ cond_syscall(compat_sys_epoll_pwait);
 cond_syscall(sys_semget);
 cond_syscall(sys_semop);
 cond_syscall(sys_semtimedop);
+cond_syscall(compat_sys_semtimedop);
 cond_syscall(sys_semctl);
+cond_syscall(compat_sys_semctl);
 cond_syscall(sys_msgget);
 cond_syscall(sys_msgsnd);
+cond_syscall(compat_sys_msgsnd);
 cond_syscall(sys_msgrcv);
+cond_syscall(compat_sys_msgrcv);
 cond_syscall(sys_msgctl);
+cond_syscall(compat_sys_msgctl);
 cond_syscall(sys_shmget);
 cond_syscall(sys_shmat);
+cond_syscall(compat_sys_shmat);
 cond_syscall(sys_shmdt);
 cond_syscall(sys_shmctl);
+cond_syscall(compat_sys_shmctl);
 cond_syscall(sys_mq_open);
 cond_syscall(sys_mq_unlink);
 cond_syscall(sys_mq_timedsend);
_

Patches currently in -mm which might be from cernekee@gmail.com are

origin.patch
linux-next.patch

