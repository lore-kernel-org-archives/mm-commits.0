From: akpm@linux-foundation.org
Subject: + kernel-timerc-convert-compat_sys_sysinfo-to-compat_syscall_define.patch added to -mm tree
Date: Mon, 08 Apr 2013 14:36:09 -0700
Message-ID: <20130408213609.E4CDA5A43A6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:39245 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934661Ab3DHVgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 17:36:12 -0400
Received: by mail-oa0-f73.google.com with SMTP id o6so1590220oag.0
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 14:36:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, arnd@arndb.de, linux@roeck-us.net, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel/timer.c: convert compat_sys_sysinfo to COMPAT_SYSCALL_DEFINE
has been added to the -mm tree.  Its filename is
     kernel-timerc-convert-compat_sys_sysinfo-to-compat_syscall_define.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix.patch
kernel-compatc-make-do_sysinfo-static.patch
kernel-timerc-convert-compat_sys_sysinfo-to-compat_syscall_define.patch
kconfig-consolidate-config_debug_strict_user_copy_checks.patch
kconfig-consolidate-config_debug_strict_user_copy_checks-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

