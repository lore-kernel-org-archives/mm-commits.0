From: akpm@google.com
Subject: + kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel.patch added to -mm tree
Date: Mon, 17 Oct 2011 15:41:42 -0700
Message-ID: <201110172241.p9HMfgZN021179@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:10341 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab1JQWl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2011 18:41:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan@mindstab.net, drepper@akkadia.org, jmorris@namei.org, kay.sievers@vrfy.org, lennart@poettering.net, mingo@elte.hu, rdunlap@xenotime.net


The patch titled
     Subject: kernel/sysctl.c: add cap_last_cap to /proc/sys/kernel
has been added to the -mm tree.  Its filename is
     kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel.patch

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
From: Dan Ballard <dan@mindstab.net>
Subject: kernel/sysctl.c: add cap_last_cap to /proc/sys/kernel

Userspace needs to know the highest valid capability of the running
kernel, which right now cannot reliably be retrieved from the header files
only.  The fact that this value cannot be determined properly right now
creates various problems for libraries compiled on newer header files
which are run on older kernels.  They assume capabilities are available
which actually aren't.

Now the capability is exported in /proc/sys/kernel/cap_last_cap.

Signed-off-by: Dan Ballard <dan@mindstab.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Ulrich Drepper <drepper@akkadia.org>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 Documentation/sysctl/kernel.txt |    8 ++++++++
 kernel/sysctl.c                 |    9 +++++++++
 2 files changed, 17 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel
+++ a/Documentation/sysctl/kernel.txt
@@ -24,6 +24,7 @@ show up in /proc/sys/kernel:
 - bootloader_type	     [ X86 only ]
 - bootloader_version	     [ X86 only ]
 - callhome		     [ S390 only ]
+- cap_last_cap
 - core_pattern
 - core_pipe_limit
 - core_uses_pid
@@ -155,6 +156,13 @@ on has a service contract with IBM.
 
 ==============================================================
 
+cap_last_cap
+
+Highest valid capability of the running kernel.  Exports
+CAP_LAST_CAP from the kernel.
+
+==============================================================
+
 core_pattern:
 
 core_pattern is used to specify a core dumpfile pattern name.
diff -puN kernel/sysctl.c~kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel
+++ a/kernel/sysctl.c
@@ -57,6 +57,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/kmod.h>
+#include <linux/capability.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -133,6 +134,7 @@ static int minolduid;
 static int min_percpu_pagelist_fract = 8;
 
 static int ngroups_max = NGROUPS_MAX;
+static int cap_last_cap = CAP_LAST_CAP;
 
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
@@ -739,6 +741,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "cap_last_cap",
+		.data		= &cap_last_cap,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 #if defined(CONFIG_LOCKUP_DETECTOR)
 	{
 		.procname       = "watchdog",
_
Subject: Subject: kernel/sysctl.c: add cap_last_cap to /proc/sys/kernel

Patches currently in -mm which might be from dan@mindstab.net are

kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel.patch

