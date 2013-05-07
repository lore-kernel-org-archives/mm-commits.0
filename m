From: akpm@linux-foundation.org
Subject: [merged] kernel-compatc-make-do_sysinfo-static.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:56 -0700
Message-ID: <20130507174756.7EDE931C1EC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59264 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351Ab3EGRr6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:58 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so109554qae.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, arnd@arndb.de, linux@roeck-us.net, tglx@linutronix.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/compat.c: make do_sysinfo() static
has been removed from the -mm tree.  Its filename was
     kernel-compatc-make-do_sysinfo-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kernel/compat.c: make do_sysinfo() static

The only use outside of kernel/timer.c was in kernel/compat.c, so move
compat_sys_sysinfo() next to sys_sysinfo() in kernel/timer.c.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 -
 kernel/compat.c        |   65 ------------------------------------
 kernel/timer.c         |   70 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 69 insertions(+), 68 deletions(-)

diff -puN include/linux/kernel.h~kernel-compatc-make-do_sysinfo-static include/linux/kernel.h
--- a/include/linux/kernel.h~kernel-compatc-make-do_sysinfo-static
+++ a/include/linux/kernel.h
@@ -798,6 +798,4 @@ static inline void ftrace_dump(enum ftra
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
 #endif
 
-extern int do_sysinfo(struct sysinfo *info);
-
 #endif
diff -puN kernel/compat.c~kernel-compatc-make-do_sysinfo-static kernel/compat.c
--- a/kernel/compat.c~kernel-compatc-make-do_sysinfo-static
+++ a/kernel/compat.c
@@ -1138,71 +1138,6 @@ asmlinkage long compat_sys_migrate_pages
 }
 #endif
 
-struct compat_sysinfo {
-	s32 uptime;
-	u32 loads[3];
-	u32 totalram;
-	u32 freeram;
-	u32 sharedram;
-	u32 bufferram;
-	u32 totalswap;
-	u32 freeswap;
-	u16 procs;
-	u16 pad;
-	u32 totalhigh;
-	u32 freehigh;
-	u32 mem_unit;
-	char _f[20-2*sizeof(u32)-sizeof(int)];
-};
-
-asmlinkage long
-compat_sys_sysinfo(struct compat_sysinfo __user *info)
-{
-	struct sysinfo s;
-
-	do_sysinfo(&s);
-
-	/* Check to see if any memory value is too large for 32-bit and scale
-	 *  down if needed
-	 */
-	if ((s.totalram >> 32) || (s.totalswap >> 32)) {
-		int bitcount = 0;
-
-		while (s.mem_unit < PAGE_SIZE) {
-			s.mem_unit <<= 1;
-			bitcount++;
-		}
-
-		s.totalram >>= bitcount;
-		s.freeram >>= bitcount;
-		s.sharedram >>= bitcount;
-		s.bufferram >>= bitcount;
-		s.totalswap >>= bitcount;
-		s.freeswap >>= bitcount;
-		s.totalhigh >>= bitcount;
-		s.freehigh >>= bitcount;
-	}
-
-	if (!access_ok(VERIFY_WRITE, info, sizeof(struct compat_sysinfo)) ||
-	    __put_user (s.uptime, &info->uptime) ||
-	    __put_user (s.loads[0], &info->loads[0]) ||
-	    __put_user (s.loads[1], &info->loads[1]) ||
-	    __put_user (s.loads[2], &info->loads[2]) ||
-	    __put_user (s.totalram, &info->totalram) ||
-	    __put_user (s.freeram, &info->freeram) ||
-	    __put_user (s.sharedram, &info->sharedram) ||
-	    __put_user (s.bufferram, &info->bufferram) ||
-	    __put_user (s.totalswap, &info->totalswap) ||
-	    __put_user (s.freeswap, &info->freeswap) ||
-	    __put_user (s.procs, &info->procs) ||
-	    __put_user (s.totalhigh, &info->totalhigh) ||
-	    __put_user (s.freehigh, &info->freehigh) ||
-	    __put_user (s.mem_unit, &info->mem_unit))
-		return -EFAULT;
-
-	return 0;
-}
-
 COMPAT_SYSCALL_DEFINE2(sched_rr_get_interval,
 		       compat_pid_t, pid,
 		       struct compat_timespec __user *, interval)
diff -puN kernel/timer.c~kernel-compatc-make-do_sysinfo-static kernel/timer.c
--- a/kernel/timer.c~kernel-compatc-make-do_sysinfo-static
+++ a/kernel/timer.c
@@ -41,6 +41,7 @@
 #include <linux/sched.h>
 #include <linux/sched/sysctl.h>
 #include <linux/slab.h>
+#include <linux/compat.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1567,7 +1568,7 @@ SYSCALL_DEFINE0(gettid)
  * do_sysinfo - fill in sysinfo struct
  * @info: pointer to buffer to fill
  */
-int do_sysinfo(struct sysinfo *info)
+static int do_sysinfo(struct sysinfo *info)
 {
 	unsigned long mem_total, sav_total;
 	unsigned int mem_unit, bitcount;
@@ -1642,6 +1643,73 @@ SYSCALL_DEFINE1(sysinfo, struct sysinfo
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_sysinfo {
+	s32 uptime;
+	u32 loads[3];
+	u32 totalram;
+	u32 freeram;
+	u32 sharedram;
+	u32 bufferram;
+	u32 totalswap;
+	u32 freeswap;
+	u16 procs;
+	u16 pad;
+	u32 totalhigh;
+	u32 freehigh;
+	u32 mem_unit;
+	char _f[20-2*sizeof(u32)-sizeof(int)];
+};
+
+asmlinkage long
+compat_sys_sysinfo(struct compat_sysinfo __user *info)
+{
+	struct sysinfo s;
+
+	do_sysinfo(&s);
+
+	/* Check to see if any memory value is too large for 32-bit and scale
+	 *  down if needed
+	 */
+	if ((s.totalram >> 32) || (s.totalswap >> 32)) {
+		int bitcount = 0;
+
+		while (s.mem_unit < PAGE_SIZE) {
+			s.mem_unit <<= 1;
+			bitcount++;
+		}
+
+		s.totalram >>= bitcount;
+		s.freeram >>= bitcount;
+		s.sharedram >>= bitcount;
+		s.bufferram >>= bitcount;
+		s.totalswap >>= bitcount;
+		s.freeswap >>= bitcount;
+		s.totalhigh >>= bitcount;
+		s.freehigh >>= bitcount;
+	}
+
+	if (!access_ok(VERIFY_WRITE, info, sizeof(struct compat_sysinfo)) ||
+	    __put_user (s.uptime, &info->uptime) ||
+	    __put_user (s.loads[0], &info->loads[0]) ||
+	    __put_user (s.loads[1], &info->loads[1]) ||
+	    __put_user (s.loads[2], &info->loads[2]) ||
+	    __put_user (s.totalram, &info->totalram) ||
+	    __put_user (s.freeram, &info->freeram) ||
+	    __put_user (s.sharedram, &info->sharedram) ||
+	    __put_user (s.bufferram, &info->bufferram) ||
+	    __put_user (s.totalswap, &info->totalswap) ||
+	    __put_user (s.freeswap, &info->freeswap) ||
+	    __put_user (s.procs, &info->procs) ||
+	    __put_user (s.totalhigh, &info->totalhigh) ||
+	    __put_user (s.freehigh, &info->freehigh) ||
+	    __put_user (s.mem_unit, &info->mem_unit))
+		return -EFAULT;
+
+	return 0;
+}
+#endif /* CONFIG_COMPAT */
+
 static int __cpuinit init_timers_cpu(int cpu)
 {
 	int j;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch
kernel-forkc-export-kernel_thread-to-modules.patch

