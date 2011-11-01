From: akpm@linux-foundation.org
Subject: [merged] kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:13 -0700
Message-ID: <201111012114.pA1LEDo1014653@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29834 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab1KAVO3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan@mindstab.net, drepper@akkadia.org, jmorris@namei.org, kay.sievers@vrfy.org, lennart@poettering.net, mingo@elte.hu, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: add cap_last_cap to /proc/sys/kernel
has been removed from the -mm tree.  Its filename was
     kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Ballard <dan@mindstab.net>
Subject: kernel/sysctl.c: add cap_last_cap to /proc/sys/kernel

Userspace needs to know the highest valid capability of the running
kernel, which right now cannot reliably be retrieved from the header files
only.  The fact that this value cannot be determined properly right now
creates various problems for libraries compiled on newer header files
which are run on older kernels.  They assume capabilities are available
which actually aren't.  libcap-ng is one example.  And we ran into the
same problem with systemd too.

Now the capability is exported in /proc/sys/kernel/cap_last_cap.

[akpm@linux-foundation.org: make cap_last_cap const, per Ulrich]
Signed-off-by: Dan Ballard <dan@mindstab.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Ulrich Drepper <drepper@akkadia.org>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
@@ -134,6 +135,7 @@ static int minolduid;
 static int min_percpu_pagelist_fract = 8;
 
 static int ngroups_max = NGROUPS_MAX;
+static const int cap_last_cap = CAP_LAST_CAP;
 
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
@@ -740,6 +742,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "cap_last_cap",
+		.data		= (void *)&cap_last_cap,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 #if defined(CONFIG_LOCKUP_DETECTOR)
 	{
 		.procname       = "watchdog",
_

Patches currently in -mm which might be from dan@mindstab.net are

origin.patch

