From: akpm@linux-foundation.org
Subject: [obsolete] revert-procfs-do-not-confuse-jiffies-with-cputime64_t.patch removed from -mm tree
Date: Tue, 24 Jan 2012 14:19:36 -0800
Message-ID: <20120124221937.74CA91013E6@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:45209 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2AXWTi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2012 17:19:38 -0500
Received: by vbbfo1 with SMTP id fo1so163505vbb.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2012 14:19:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: revert procfs-do-not-confuse-jiffies-with-cputime64_t
has been removed from the -mm tree.  Its filename was
     revert-procfs-do-not-confuse-jiffies-with-cputime64_t.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert procfs-do-not-confuse-jiffies-with-cputime64_t

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/cputime.h    |    1 -
 arch/powerpc/include/asm/cputime.h |    2 --
 arch/s390/include/asm/cputime.h    |    2 --
 fs/proc/stat.c                     |    4 ++--
 include/asm-generic/cputime.h      |    1 -
 5 files changed, 2 insertions(+), 8 deletions(-)

diff -puN arch/ia64/include/asm/cputime.h~revert-procfs-do-not-confuse-jiffies-with-cputime64_t arch/ia64/include/asm/cputime.h
--- a/arch/ia64/include/asm/cputime.h~revert-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/ia64/include/asm/cputime.h
@@ -60,7 +60,6 @@ typedef u64 cputime64_t;
  */
 #define cputime_to_usecs(__ct)		((__ct) / NSEC_PER_USEC)
 #define usecs_to_cputime(__usecs)	((__usecs) * NSEC_PER_USEC)
-#define usecs_to_cputime64(__usecs)	usecs_to_cputime(__usecs)
 
 /*
  * Convert cputime <-> seconds
diff -puN arch/powerpc/include/asm/cputime.h~revert-procfs-do-not-confuse-jiffies-with-cputime64_t arch/powerpc/include/asm/cputime.h
--- a/arch/powerpc/include/asm/cputime.h~revert-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/powerpc/include/asm/cputime.h
@@ -150,8 +150,6 @@ static inline cputime_t usecs_to_cputime
 	return ct;
 }
 
-#define usecs_to_cputime64(us)		usecs_to_cputime(us)
-
 /*
  * Convert cputime <-> seconds
  */
diff -puN arch/s390/include/asm/cputime.h~revert-procfs-do-not-confuse-jiffies-with-cputime64_t arch/s390/include/asm/cputime.h
--- a/arch/s390/include/asm/cputime.h~revert-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/arch/s390/include/asm/cputime.h
@@ -87,8 +87,6 @@ usecs_to_cputime(const unsigned int m)
 	return (cputime_t) m * 4096;
 }
 
-#define usecs_to_cputime64(m)		usecs_to_cputime(m)
-
 /*
  * Convert cputime to milliseconds and back.
  */
diff -puN fs/proc/stat.c~revert-procfs-do-not-confuse-jiffies-with-cputime64_t fs/proc/stat.c
--- a/fs/proc/stat.c~revert-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/fs/proc/stat.c
@@ -32,7 +32,7 @@ static cputime64_t get_idle_time(int cpu
 		idle = kstat_cpu(cpu).cpustat.idle;
 		idle = cputime64_add(idle, arch_idle_time(cpu));
 	} else
-		idle = usecs_to_cputime64(idle_time);
+		idle = nsecs_to_jiffies64(1000 * idle_time);
 
 	return idle;
 }
@@ -46,7 +46,7 @@ static cputime64_t get_iowait_time(int c
 		/* !NO_HZ so we can rely on cpustat.iowait */
 		iowait = kstat_cpu(cpu).cpustat.iowait;
 	else
-		iowait = usecs_to_cputime64(iowait_time);
+		iowait = nsecs_to_jiffies64(1000 * iowait_time);
 
 	return iowait;
 }
diff -puN include/asm-generic/cputime.h~revert-procfs-do-not-confuse-jiffies-with-cputime64_t include/asm-generic/cputime.h
--- a/include/asm-generic/cputime.h~revert-procfs-do-not-confuse-jiffies-with-cputime64_t
+++ a/include/asm-generic/cputime.h
@@ -40,7 +40,6 @@ typedef u64 cputime64_t;
  */
 #define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct)
 #define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs)
-#define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
 
 /*
  * Convert cputime to seconds and back.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

