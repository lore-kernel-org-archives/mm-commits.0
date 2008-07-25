From: akpm@linux-foundation.org
Subject: - flag-parameters-fix-compile-error-of-sys_epoll_create1.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:53:58 -0700
Message-ID: <200807252253.m6PMrwg9002767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbYGYWy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangchen@cn.fujitsu.com, davidel@xmailserver.org, drepper@redhat.com, mm-commits@vger.kernel.org


The patch titled
     flag parameters: fix compile error of sys_epoll_create1
has been removed from the -mm tree.  Its filename was
     flag-parameters-fix-compile-error-of-sys_epoll_create1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: fix compile error of sys_epoll_create1
From: Wang Chen <wangchen@cn.fujitsu.com>

  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      vmlinux
arch/x86/kernel/built-in.o: In function `sys_call_table':
(.rodata+0x8a4): undefined reference to `sys_epoll_create1'
make: *** [vmlinux] Error 1

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys_ni.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sys_ni.c~flag-parameters-fix-compile-error-of-sys_epoll_create1 kernel/sys_ni.c
--- a/kernel/sys_ni.c~flag-parameters-fix-compile-error-of-sys_epoll_create1
+++ a/kernel/sys_ni.c
@@ -57,6 +57,7 @@ cond_syscall(compat_sys_set_robust_list)
 cond_syscall(sys_get_robust_list);
 cond_syscall(compat_sys_get_robust_list);
 cond_syscall(sys_epoll_create);
+cond_syscall(sys_epoll_create1);
 cond_syscall(sys_epoll_ctl);
 cond_syscall(sys_epoll_wait);
 cond_syscall(sys_epoll_pwait);
_

Patches currently in -mm which might be from wangchen@cn.fujitsu.com are

origin.patch

