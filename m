From: akpm@linux-foundation.org
Subject: - kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:19 -0700
Message-ID: <200710180659.l9I6xJTt030973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40489 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754508AbXJRG7e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:59:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel/sys_ni.c: add dummy sys_ni_syscall() prototype
has been removed from the -mm tree.  Its filename was
     kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/sys_ni.c: add dummy sys_ni_syscall() prototype
From: Adrian Bunk <bunk@kernel.org>

kernel/sys_ni.c can't #include <linux/syscalls.h> due to cond_syscall(),
but let's tell gcc to not warn with -Wmissing-prototypes.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys_ni.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/sys_ni.c~kernel-sys_nic-add-dummy-sys_ni_syscall-prototype kernel/sys_ni.c
--- a/kernel/sys_ni.c~kernel-sys_nic-add-dummy-sys_ni_syscall-prototype
+++ a/kernel/sys_ni.c
@@ -4,6 +4,10 @@
 
 #include <asm/unistd.h>
 
+/*  we can't #include <linux/syscalls.h> here,
+    but tell gcc to not warn with -Wmissing-prototypes  */
+asmlinkage long sys_ni_syscall(void);
+
 /*
  * Non-implemented system calls get redirected here.
  */
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-nfs-make-nfs_wb_page_priority-static.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
