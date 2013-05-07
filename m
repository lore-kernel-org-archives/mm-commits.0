From: akpm@linux-foundation.org
Subject: [merged] kernel-timerc-convert-compat_sys_sysinfo-to-compat_syscall_define.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:59 -0700
Message-ID: <20130507174759.7E3C45A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:36444 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759383Ab3EGRsA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:00 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so85008ves.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, arnd@arndb.de, linux@roeck-us.net, tglx@linutronix.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/timer.c: convert compat_sys_sysinfo to COMPAT_SYSCALL_DEFINE
has been removed from the -mm tree.  Its filename was
     kernel-timerc-convert-compat_sys_sysinfo-to-compat_syscall_define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kernel/timer.c: convert compat_sys_sysinfo to COMPAT_SYSCALL_DEFINE

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/timer.c~kernel-timerc-convert-compat_sys_sysinfo-to-compat_syscall_define kernel/timer.c
--- a/kernel/timer.c~kernel-timerc-convert-compat_sys_sysinfo-to-compat_syscall_define
+++ a/kernel/timer.c
@@ -1661,8 +1661,7 @@ struct compat_sysinfo {
 	char _f[20-2*sizeof(u32)-sizeof(int)];
 };
 
-asmlinkage long
-compat_sys_sysinfo(struct compat_sysinfo __user *info)
+COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
 {
 	struct sysinfo s;
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch
kernel-forkc-export-kernel_thread-to-modules.patch

