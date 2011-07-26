From: akpm@linux-foundation.org
Subject: [merged] include-linux-kernelh-fix-a-headers_check-warning.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:08 -0700
Message-ID: <201107260754.p6Q7sBkS003330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229Ab1GZHy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     include/linux/kernel.h: fix a headers_check warning
has been removed from the -mm tree.  Its filename was
     include-linux-kernelh-fix-a-headers_check-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/kernel.h: fix a headers_check warning
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix the warning:

usr/include/linux/kernel.h:65: userspace cannot reference
function or variable defined in the kernel

As Michal noted, BUILD_BUG_ON stuffs should be moved
under #ifdef __KERNEL__.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   47 +++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff -puN include/linux/kernel.h~include-linux-kernelh-fix-a-headers_check-warning include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-kernelh-fix-a-headers_check-warning
+++ a/include/linux/kernel.h
@@ -646,29 +646,6 @@ static inline void ftrace_dump(enum ftra
 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 	(type *)( (char *)__mptr - offsetof(type,member) );})
 
-struct sysinfo;
-extern int do_sysinfo(struct sysinfo *info);
-
-#endif /* __KERNEL__ */
-
-#define SI_LOAD_SHIFT	16
-struct sysinfo {
-	long uptime;			/* Seconds since boot */
-	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
-	unsigned long totalram;		/* Total usable main memory size */
-	unsigned long freeram;		/* Available memory size */
-	unsigned long sharedram;	/* Amount of shared memory */
-	unsigned long bufferram;	/* Memory used by buffers */
-	unsigned long totalswap;	/* Total swap space size */
-	unsigned long freeswap;		/* swap space still available */
-	unsigned short procs;		/* Number of current processes */
-	unsigned short pad;		/* explicit padding for m68k */
-	unsigned long totalhigh;	/* Total high memory size */
-	unsigned long freehigh;		/* Available high memory size */
-	unsigned int mem_unit;		/* Memory unit size in bytes */
-	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
-};
-
 #ifdef __CHECKER__
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
 #define BUILD_BUG_ON_ZERO(e) (0)
@@ -714,6 +691,30 @@ extern int __build_bug_on_failed;
 #endif
 #endif	/* __CHECKER__ */
 
+
+struct sysinfo;
+extern int do_sysinfo(struct sysinfo *info);
+
+#endif /* __KERNEL__ */
+
+#define SI_LOAD_SHIFT	16
+struct sysinfo {
+	long uptime;			/* Seconds since boot */
+	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
+	unsigned long totalram;		/* Total usable main memory size */
+	unsigned long freeram;		/* Available memory size */
+	unsigned long sharedram;	/* Amount of shared memory */
+	unsigned long bufferram;	/* Memory used by buffers */
+	unsigned long totalswap;	/* Total swap space size */
+	unsigned long freeswap;		/* swap space still available */
+	unsigned short procs;		/* Number of current processes */
+	unsigned short pad;		/* explicit padding for m68k */
+	unsigned long totalhigh;	/* Total high memory size */
+	unsigned long freehigh;		/* Available high memory size */
+	unsigned int mem_unit;		/* Memory unit size in bytes */
+	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
+};
+
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch
cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch
gcov-disable-constructors-for-uml.patch
include-linux-dma-mappingh-remove-dma_xxbit_mask-macros.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

