From: akpm@osdl.org
Subject: - sysctl-move-utsname-sysctls-to-their-own-file-fix.patch removed from -mm tree
Date: Tue, 30 Jan 2007 11:38:12 -0800
Message-ID: <200701301938.l0UJcCmw026796@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44586 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbXA3TiO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 14:38:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laurent.riffard@free.fr, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     compile and link utsname_sysctl.o
has been removed from the -mm tree.  Its filename was
     sysctl-move-utsname-sysctls-to-their-own-file-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: compile and link utsname_sysctl.o
From: Laurent Riffard <laurent.riffard@free.fr>

The utsname stuff has been moved from kernel/sysctl.c to the new file
utsname_sysctl.c. Let's use it...

Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/Makefile~sysctl-move-utsname-sysctls-to-their-own-file-fix kernel/Makefile
--- a/kernel/Makefile~sysctl-move-utsname-sysctls-to-their-own-file-fix
+++ a/kernel/Makefile
@@ -8,7 +8,8 @@ obj-y     = sched.o fork.o exec_domain.o
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o rcupdate.o srcu.o utsname.o
+	    hrtimer.o rwsem.o latency.o nsproxy.o rcupdate.o srcu.o utsname.o \
+	    utsname_sysctl.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
_

Patches currently in -mm which might be from laurent.riffard@free.fr are

reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix.patch
