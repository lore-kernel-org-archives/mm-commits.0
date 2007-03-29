From: akpm@linux-foundation.org
Subject: - fix-kernel-build-with-embedded-proc_fs-proc_sysctl.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:30 -0700
Message-ID: <200703290742.l2T7gUav030306@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46141 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbXC2Hmk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikukkon@iki.fi, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Fix kernel build with EMBEDDED & PROC_FS & !PROC_SYSCTL
has been removed from the -mm tree.  Its filename was
     fix-kernel-build-with-embedded-proc_fs-proc_sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix kernel build with EMBEDDED & PROC_FS & !PROC_SYSCTL
From: "Mika Kukkonen" <mikukkon@iki.fi>

Without attached patch against current -git I get following with
!PROC_SYSCTL (with EMBEDDED and PROC_FS set):

  CC      init/version.o
  LD      init/built-in.o
  LD      vmlinux
fs/built-in.o: In function `do_proc_sys_lookup':
proc_sysctl.c:(.text+0x26583): undefined reference to `sysctl_head_next'
fs/built-in.o: In function `proc_sys_revalidate':
proc_sysctl.c:(.text+0x265bb): undefined reference to `sysctl_head_finish'
fs/built-in.o: In function `proc_sys_readdir':
proc_sysctl.c:(.text+0x26720): undefined reference to `sysctl_head_next'
proc_sysctl.c:(.text+0x267d8): undefined reference to `sysctl_head_finish'
proc_sysctl.c:(.text+0x268e7): undefined reference to `sysctl_head_next'
proc_sysctl.c:(.text+0x26910): undefined reference to `sysctl_head_finish'
fs/built-in.o: In function `proc_sys_write':
proc_sysctl.c:(.text+0x2695d): undefined reference to `sysctl_perm'
proc_sysctl.c:(.text+0x2699c): undefined reference to `sysctl_head_finish'
fs/built-in.o: In function `proc_sys_read':
proc_sysctl.c:(.text+0x269e9): undefined reference to `sysctl_perm'
proc_sysctl.c:(.text+0x26a25): undefined reference to `sysctl_head_finish'
fs/built-in.o: In function `proc_sys_permission':
proc_sysctl.c:(.text+0x26ad1): undefined reference to `sysctl_perm'
proc_sysctl.c:(.text+0x26adb): undefined reference to `sysctl_head_finish'
fs/built-in.o: In function `proc_sys_lookup':
proc_sysctl.c:(.text+0x26b39): undefined reference to `sysctl_head_finish'
make: *** [vmlinux] Virhe 1

All those functions are in fs/proc/proc_sysctl.c, which has no CONFIG_
#define's in it, so the patch makes the compilation of that file to depend
on CONFIG_PROC_SYSCTL (the simplest choice).

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/Makefile~fix-kernel-build-with-embedded-proc_fs-proc_sysctl fs/proc/Makefile
--- a/fs/proc/Makefile~fix-kernel-build-with-embedded-proc_fs-proc_sysctl
+++ a/fs/proc/Makefile
@@ -8,8 +8,9 @@ proc-y			:= nommu.o task_nommu.o
 proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 
 proc-y       += inode.o root.o base.o generic.o array.o \
-		proc_tty.o proc_misc.o proc_sysctl.o
+		proc_tty.o proc_misc.o
 
+proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
 proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
 proc-$(CONFIG_PROC_DEVICETREE)	+= proc_devtree.o
_

Patches currently in -mm which might be from mikukkon@iki.fi are

origin.patch
