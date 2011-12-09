From: akpm@linux-foundation.org
Subject: [merged] sys_getppid-add-missing-rcu_dereference.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:54 -0800
Message-ID: <201112092008.pB9K8s0Z021129@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bw0-f74.google.com ([209.85.214.74]:56669 "EHLO
	mail-bw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1LIUI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:58 -0500
Received: by bkas6 with SMTP id s6so69495bka.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:08:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msb@chromium.org, keescook@chromium.org, oleg@redhat.com, tglx@linutronix.de, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sys_getppid: add missing rcu_dereference
has been removed from the -mm tree.  Its filename was
     sys_getppid-add-missing-rcu_dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mandeep Singh Baines <msb@chromium.org>
Subject: sys_getppid: add missing rcu_dereference

In order to safely dereference current->real_parent inside an
rcu_read_lock, we need an rcu_dereference.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/timer.c~sys_getppid-add-missing-rcu_dereference kernel/timer.c
--- a/kernel/timer.c~sys_getppid-add-missing-rcu_dereference
+++ a/kernel/timer.c
@@ -1368,7 +1368,7 @@ SYSCALL_DEFINE0(getppid)
 	int pid;
 
 	rcu_read_lock();
-	pid = task_tgid_vnr(current->real_parent);
+	pid = task_tgid_vnr(rcu_dereference(current->real_parent));
 	rcu_read_unlock();
 
 	return pid;
_

Patches currently in -mm which might be from msb@chromium.org are

origin.patch
linux-next.patch

