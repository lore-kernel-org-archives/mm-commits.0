From: akpm@linux-foundation.org
Subject: [folded-merged] kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:15:17 -0700
Message-ID: <20130430221518.449595A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61103 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760884Ab3D3WPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:15:19 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so113137qab.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:15:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@roeck-us.net, sfr@canb.auug.org.au, tglx@linutronix.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch

This patch was dropped because it was folded into kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes

WARNING: space prohibited between function name and open parenthesis '('
#244: FILE: kernel/sys.c:2453:
+	    __put_user (s.uptime, &info->uptime) ||

WARNING: space prohibited between function name and open parenthesis '('
#245: FILE: kernel/sys.c:2454:
+	    __put_user (s.loads[0], &info->loads[0]) ||

WARNING: space prohibited between function name and open parenthesis '('
#246: FILE: kernel/sys.c:2455:
+	    __put_user (s.loads[1], &info->loads[1]) ||

WARNING: space prohibited between function name and open parenthesis '('
#247: FILE: kernel/sys.c:2456:
+	    __put_user (s.loads[2], &info->loads[2]) ||

WARNING: space prohibited between function name and open parenthesis '('
#248: FILE: kernel/sys.c:2457:
+	    __put_user (s.totalram, &info->totalram) ||

WARNING: space prohibited between function name and open parenthesis '('
#249: FILE: kernel/sys.c:2458:
+	    __put_user (s.freeram, &info->freeram) ||

WARNING: space prohibited between function name and open parenthesis '('
#250: FILE: kernel/sys.c:2459:
+	    __put_user (s.sharedram, &info->sharedram) ||

WARNING: space prohibited between function name and open parenthesis '('
#251: FILE: kernel/sys.c:2460:
+	    __put_user (s.bufferram, &info->bufferram) ||

WARNING: space prohibited between function name and open parenthesis '('
#252: FILE: kernel/sys.c:2461:
+	    __put_user (s.totalswap, &info->totalswap) ||

WARNING: space prohibited between function name and open parenthesis '('
#253: FILE: kernel/sys.c:2462:
+	    __put_user (s.freeswap, &info->freeswap) ||

WARNING: space prohibited between function name and open parenthesis '('
#254: FILE: kernel/sys.c:2463:
+	    __put_user (s.procs, &info->procs) ||

WARNING: space prohibited between function name and open parenthesis '('
#255: FILE: kernel/sys.c:2464:
+	    __put_user (s.totalhigh, &info->totalhigh) ||

WARNING: space prohibited between function name and open parenthesis '('
#256: FILE: kernel/sys.c:2465:
+	    __put_user (s.freehigh, &info->freehigh) ||

WARNING: space prohibited between function name and open parenthesis '('
#257: FILE: kernel/sys.c:2466:
+	    __put_user (s.mem_unit, &info->mem_unit))

total: 0 errors, 14 warnings, 452 lines checked

./patches/kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN kernel/sys.c~kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes kernel/sys.c
--- a/kernel/sys.c~kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes
+++ a/kernel/sys.c
@@ -2451,20 +2451,20 @@ COMPAT_SYSCALL_DEFINE1(sysinfo, struct c
 	}
 
 	if (!access_ok(VERIFY_WRITE, info, sizeof(struct compat_sysinfo)) ||
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
+	    __put_user(s.uptime, &info->uptime) ||
+	    __put_user(s.loads[0], &info->loads[0]) ||
+	    __put_user(s.loads[1], &info->loads[1]) ||
+	    __put_user(s.loads[2], &info->loads[2]) ||
+	    __put_user(s.totalram, &info->totalram) ||
+	    __put_user(s.freeram, &info->freeram) ||
+	    __put_user(s.sharedram, &info->sharedram) ||
+	    __put_user(s.bufferram, &info->bufferram) ||
+	    __put_user(s.totalswap, &info->totalswap) ||
+	    __put_user(s.freeswap, &info->freeswap) ||
+	    __put_user(s.procs, &info->procs) ||
+	    __put_user(s.totalhigh, &info->totalhigh) ||
+	    __put_user(s.freehigh, &info->freehigh) ||
+	    __put_user(s.mem_unit, &info->mem_unit))
 		return -EFAULT;
 
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-usb-storage-realtek_crc-fix-build.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch

