From: akpm@linux-foundation.org
Subject: + fs-proc-dont-use-module_init-for-non-modular-core-code.patch
 added to -mm tree
Date: Mon, 13 Jan 2014 14:19:59 -0800
Message-ID: <52d4668f.5B46f9LrxBc2EUFs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaAMWUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 17:20:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.gortmaker@windriver.com

Subject: + fs-proc-dont-use-module_init-for-non-modular-core-code.patch added to -mm tree
To: paul.gortmaker@windriver.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 14:19:59 -0800


The patch titled
     Subject: fs/proc: don't use module_init for non-modular core code
has been added to the -mm tree.  Its filename is
     fs-proc-dont-use-module_init-for-non-modular-core-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-dont-use-module_init-for-non-modular-core-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-dont-use-module_init-for-non-modular-core-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: fs/proc: don't use module_init for non-modular core code

PROC_FS is a bool, so this code is either present or absent.  It will
never be modular, so using module_init as an alias for __initcall is
rather misleading.

Fix this up now, so that we can relocate module_init from init.h into
module.h in the future.  If we don't do this, we'd have to add module.h to
obviously non-modular code, and that would be ugly at best.

Note that direct use of __initcall is discouraged, vs.  one of the
priority categorized subgroups.  As __initcall gets mapped onto
device_initcall, our use of fs_initcall (which makes sense for fs code)
will thus change these registrations from level 6-device to level 5-fs
(i.e.  slightly earlier).  However no observable impact of that small
difference has been observed during testing, or is expected.

Also note that this change uncovers a missing semicolon bug in the
registration of vmcore_init as an initcall.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/cmdline.c    |    2 +-
 fs/proc/consoles.c   |    2 +-
 fs/proc/cpuinfo.c    |    2 +-
 fs/proc/devices.c    |    2 +-
 fs/proc/interrupts.c |    2 +-
 fs/proc/kcore.c      |    2 +-
 fs/proc/kmsg.c       |    2 +-
 fs/proc/loadavg.c    |    2 +-
 fs/proc/meminfo.c    |    2 +-
 fs/proc/nommu.c      |    2 +-
 fs/proc/page.c       |    2 +-
 fs/proc/softirqs.c   |    2 +-
 fs/proc/stat.c       |    2 +-
 fs/proc/uptime.c     |    2 +-
 fs/proc/version.c    |    2 +-
 fs/proc/vmcore.c     |    2 +-
 16 files changed, 16 insertions(+), 16 deletions(-)

diff -puN fs/proc/cmdline.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/cmdline.c
--- a/fs/proc/cmdline.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/cmdline.c
@@ -26,4 +26,4 @@ static int __init proc_cmdline_init(void
 	proc_create("cmdline", 0, NULL, &cmdline_proc_fops);
 	return 0;
 }
-module_init(proc_cmdline_init);
+fs_initcall(proc_cmdline_init);
diff -puN fs/proc/consoles.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/consoles.c
--- a/fs/proc/consoles.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/consoles.c
@@ -109,4 +109,4 @@ static int __init proc_consoles_init(voi
 	proc_create("consoles", 0, NULL, &proc_consoles_operations);
 	return 0;
 }
-module_init(proc_consoles_init);
+fs_initcall(proc_consoles_init);
diff -puN fs/proc/cpuinfo.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/cpuinfo.c
--- a/fs/proc/cpuinfo.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/cpuinfo.c
@@ -21,4 +21,4 @@ static int __init proc_cpuinfo_init(void
 	proc_create("cpuinfo", 0, NULL, &proc_cpuinfo_operations);
 	return 0;
 }
-module_init(proc_cpuinfo_init);
+fs_initcall(proc_cpuinfo_init);
diff -puN fs/proc/devices.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/devices.c
--- a/fs/proc/devices.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/devices.c
@@ -67,4 +67,4 @@ static int __init proc_devices_init(void
 	proc_create("devices", 0, NULL, &proc_devinfo_operations);
 	return 0;
 }
-module_init(proc_devices_init);
+fs_initcall(proc_devices_init);
diff -puN fs/proc/interrupts.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/interrupts.c
--- a/fs/proc/interrupts.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/interrupts.c
@@ -50,4 +50,4 @@ static int __init proc_interrupts_init(v
 	proc_create("interrupts", 0, NULL, &proc_interrupts_operations);
 	return 0;
 }
-module_init(proc_interrupts_init);
+fs_initcall(proc_interrupts_init);
diff -puN fs/proc/kcore.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/kcore.c
--- a/fs/proc/kcore.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/kcore.c
@@ -639,4 +639,4 @@ static int __init proc_kcore_init(void)
 
 	return 0;
 }
-module_init(proc_kcore_init);
+fs_initcall(proc_kcore_init);
diff -puN fs/proc/kmsg.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/kmsg.c
--- a/fs/proc/kmsg.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/kmsg.c
@@ -61,4 +61,4 @@ static int __init proc_kmsg_init(void)
 	proc_create("kmsg", S_IRUSR, NULL, &proc_kmsg_operations);
 	return 0;
 }
-module_init(proc_kmsg_init);
+fs_initcall(proc_kmsg_init);
diff -puN fs/proc/loadavg.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/loadavg.c
--- a/fs/proc/loadavg.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/loadavg.c
@@ -42,4 +42,4 @@ static int __init proc_loadavg_init(void
 	proc_create("loadavg", 0, NULL, &loadavg_proc_fops);
 	return 0;
 }
-module_init(proc_loadavg_init);
+fs_initcall(proc_loadavg_init);
diff -puN fs/proc/meminfo.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/meminfo.c
@@ -220,4 +220,4 @@ static int __init proc_meminfo_init(void
 	proc_create("meminfo", 0, NULL, &meminfo_proc_fops);
 	return 0;
 }
-module_init(proc_meminfo_init);
+fs_initcall(proc_meminfo_init);
diff -puN fs/proc/nommu.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/nommu.c
--- a/fs/proc/nommu.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/nommu.c
@@ -131,4 +131,4 @@ static int __init proc_nommu_init(void)
 	return 0;
 }
 
-module_init(proc_nommu_init);
+fs_initcall(proc_nommu_init);
diff -puN fs/proc/page.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/page.c
--- a/fs/proc/page.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/page.c
@@ -219,4 +219,4 @@ static int __init proc_page_init(void)
 	proc_create("kpageflags", S_IRUSR, NULL, &proc_kpageflags_operations);
 	return 0;
 }
-module_init(proc_page_init);
+fs_initcall(proc_page_init);
diff -puN fs/proc/softirqs.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/softirqs.c
--- a/fs/proc/softirqs.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/softirqs.c
@@ -41,4 +41,4 @@ static int __init proc_softirqs_init(voi
 	proc_create("softirqs", 0, NULL, &proc_softirqs_operations);
 	return 0;
 }
-module_init(proc_softirqs_init);
+fs_initcall(proc_softirqs_init);
diff -puN fs/proc/stat.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/stat.c
--- a/fs/proc/stat.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/stat.c
@@ -221,4 +221,4 @@ static int __init proc_stat_init(void)
 	proc_create("stat", 0, NULL, &proc_stat_operations);
 	return 0;
 }
-module_init(proc_stat_init);
+fs_initcall(proc_stat_init);
diff -puN fs/proc/uptime.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/uptime.c
--- a/fs/proc/uptime.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/uptime.c
@@ -49,4 +49,4 @@ static int __init proc_uptime_init(void)
 	proc_create("uptime", 0, NULL, &uptime_proc_fops);
 	return 0;
 }
-module_init(proc_uptime_init);
+fs_initcall(proc_uptime_init);
diff -puN fs/proc/version.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/version.c
--- a/fs/proc/version.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/version.c
@@ -31,4 +31,4 @@ static int __init proc_version_init(void
 	proc_create("version", 0, NULL, &version_proc_fops);
 	return 0;
 }
-module_init(proc_version_init);
+fs_initcall(proc_version_init);
diff -puN fs/proc/vmcore.c~fs-proc-dont-use-module_init-for-non-modular-core-code fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~fs-proc-dont-use-module_init-for-non-modular-core-code
+++ a/fs/proc/vmcore.c
@@ -1082,7 +1082,7 @@ static int __init vmcore_init(void)
 		proc_vmcore->size = vmcore_size;
 	return 0;
 }
-module_init(vmcore_init)
+fs_initcall(vmcore_init);
 
 /* Cleanup function for vmcore module. */
 void vmcore_cleanup(void)
_

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

lib-percpu_counterc-fix-__percpu_counter_add.patch
fs-ramfs-dont-use-module_init-for-non-modular-core-code.patch
printk-flush-conflicting-continuation-line.patch
printk-flush-conflicting-continuation-line-fix.patch
fs-proc-dont-use-module_init-for-non-modular-core-code.patch
linux-next.patch

