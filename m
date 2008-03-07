From: akpm@linux-foundation.org
Subject: - ia64-remove-unnecessary-nfs-includes-from-sys_ia32c.patch removed from -mm tree
Date: Fri, 07 Mar 2008 15:00:40 -0800
Message-ID: <200803072300.m27N0ecq021714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756856AbYCGXBs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 18:01:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, bfields@citi.umich.edu, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: remove unnecessary nfs includes from sys_ia32.c
has been removed from the -mm tree.  Its filename was
     ia64-remove-unnecessary-nfs-includes-from-sys_ia32c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: remove unnecessary nfs includes from sys_ia32.c
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Cinpilation of 2.6.25-rc2-mm1 on ia64 generates many warnings.

----------------------------------------------------------------
% LANG=C make arch/ia64/ia32/sys_ia32.o
<-mm1% LANG=C make arch/ia64/ia32/sys_ia32.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      arch/ia64/ia32/sys_ia32.o
In file included from arch/ia64/ia32/sys_ia32.c:59:
arch/ia64/ia32/ia32priv.h:297:1: warning: "elf_check_arch" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/device.h:21,
                 from include/linux/backing-dev.h:15,
                 from include/linux/nfs_fs_sb.h:5,
                 from include/linux/nfs_fs.h:50,
                 from arch/ia64/ia32/sys_ia32.c:35:
include/asm/elf.h:19:1: warning: this is the location of the previous definition
In file included from arch/ia64/ia32/sys_ia32.c:59:
arch/ia64/ia32/ia32priv.h:302:1: warning: "ELF_CLASS" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/device.h:21,
                 from include/linux/backing-dev.h:15,
                 from include/linux/nfs_fs_sb.h:5,
                 from include/linux/nfs_fs.h:50,
                 from arch/ia64/ia32/sys_ia32.c:35:
include/asm/elf.h:24:1: warning: this is the location of the previous definition
In file included from arch/ia64/ia32/sys_ia32.c:59:
arch/ia64/ia32/ia32priv.h:304:1: warning: "ELF_ARCH" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/device.h:21,
                 from include/linux/backing-dev.h:15,
                 from include/linux/nfs_fs_sb.h:5,
                 from include/linux/nfs_fs.h:50,
                 from arch/ia64/ia32/sys_ia32.c:35:
include/asm/elf.h:26:1: warning: this is the location of the previous definition
In file included from arch/ia64/ia32/sys_ia32.c:59:
arch/ia64/ia32/ia32priv.h:318:1: warning: "ELF_EXEC_PAGESIZE" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/device.h:21,
                 from include/linux/backing-dev.h:15,
                 from include/linux/nfs_fs_sb.h:5,
                 from include/linux/nfs_fs.h:50,
                 from arch/ia64/ia32/sys_ia32.c:35:
include/asm/elf.h:34:1: warning: this is the location of the previous definition
In file included from arch/ia64/ia32/sys_ia32.c:59:
arch/ia64/ia32/ia32priv.h:327:1: warning: "ELF_ET_DYN_BASE" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/device.h:21,
                 from include/linux/backing-dev.h:15,
                 from include/linux/nfs_fs_sb.h:5,
                 from include/linux/nfs_fs.h:50,
                 from arch/ia64/ia32/sys_ia32.c:35:
include/asm/elf.h:43:1: warning: this is the location of the previous definition
In file included from arch/ia64/ia32/sys_ia32.c:59:
arch/ia64/ia32/ia32priv.h:330:1: warning: "ELF_PLAT_INIT" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/device.h:21,
                 from include/linux/backing-dev.h:15,
                 from include/linux/nfs_fs_sb.h:5,
                 from include/linux/nfs_fs.h:50,
                 from arch/ia64/ia32/sys_ia32.c:35:
include/asm/elf.h:140:1: warning: this is the location of the previous definition
In file included from arch/ia64/ia32/sys_ia32.c:59:
arch/ia64/ia32/ia32priv.h:342:1: warning: "SET_PERSONALITY" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/device.h:21,
                 from include/linux/backing-dev.h:15,
                 from include/linux/nfs_fs_sb.h:5,
                 from include/linux/nfs_fs.h:50,
                 from arch/ia64/ia32/sys_ia32.c:35:
include/asm/elf.h:180:1: warning: this is the location of the previous definition
------------------------------------------------------------------------

IA64 support 2 ELF format (IA64 binary and IA32 binary),
thus if 2 elf related header included, cause many warning or error.

about 2 week ago, J. Bruce Fields proposed this problem fixed patch.
(http://marc.info/?l=linux-ia64&m=120329313305695&w=2)

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/sys_ia32.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/ia64/ia32/sys_ia32.c~ia64-remove-unnecessary-nfs-includes-from-sys_ia32c arch/ia64/ia32/sys_ia32.c
--- a/arch/ia64/ia32/sys_ia32.c~ia64-remove-unnecessary-nfs-includes-from-sys_ia32c
+++ a/arch/ia64/ia32/sys_ia32.c
@@ -32,13 +32,8 @@
 #include <linux/shm.h>
 #include <linux/slab.h>
 #include <linux/uio.h>
-#include <linux/nfs_fs.h>
+#include <linux/socket.h>
 #include <linux/quota.h>
-#include <linux/sunrpc/svc.h>
-#include <linux/nfsd/nfsd.h>
-#include <linux/nfsd/cache.h>
-#include <linux/nfsd/xdr.h>
-#include <linux/nfsd/syscall.h>
 #include <linux/poll.h>
 #include <linux/eventpoll.h>
 #include <linux/personality.h>
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch

