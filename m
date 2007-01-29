From: akpm@osdl.org
Subject: + sysctl-move-utsname-sysctls-to-their-own-file-fix.patch added to -mm tree
Date: Mon, 29 Jan 2007 14:39:45 -0800
Message-ID: <200701292239.l0TMdjY7001004@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59925 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012AbXA2Wjt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 17:39:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laurent.riffard@free.fr, ebiederm@xmission.com


The patch titled
     compile and link utsname_sysctl.o
has been added to the -mm tree.  Its filename is
     sysctl-move-utsname-sysctls-to-their-own-file-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
