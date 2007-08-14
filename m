From: akpm@linux-foundation.org
Subject: - blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:02:20 -0700
Message-ID: <200708140502.l7E52LiJ031970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760995AbXHNFDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:03:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin arch: after removing fs.h from mm.h, fix the broken on Blackfin arch
has been removed from the -mm tree.  Its filename was
     blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Blackfin arch: after removing fs.h from mm.h, fix the broken on Blackfin arch
From: Bryan Wu <bryan.wu@analog.com>

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/init_task.c |    1 +
 arch/blackfin/kernel/process.c   |    2 ++
 arch/blackfin/kernel/sys_bfin.c  |    1 +
 arch/blackfin/kernel/traps.c     |    1 +
 4 files changed, 5 insertions(+)

diff -puN arch/blackfin/kernel/init_task.c~blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch arch/blackfin/kernel/init_task.c
--- a/arch/blackfin/kernel/init_task.c~blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch
+++ a/arch/blackfin/kernel/init_task.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
+#include <linux/fs.h>
 
 static struct fs_struct init_fs = INIT_FS;
 static struct files_struct init_files = INIT_FILES;
diff -puN arch/blackfin/kernel/process.c~blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch arch/blackfin/kernel/process.c
--- a/arch/blackfin/kernel/process.c~blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch
+++ a/arch/blackfin/kernel/process.c
@@ -33,6 +33,8 @@
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/err.h>
 
 #include <asm/blackfin.h>
 #include <asm/fixed_code.h>
diff -puN arch/blackfin/kernel/sys_bfin.c~blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch arch/blackfin/kernel/sys_bfin.c
--- a/arch/blackfin/kernel/sys_bfin.c~blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch
+++ a/arch/blackfin/kernel/sys_bfin.c
@@ -37,6 +37,7 @@
 #include <linux/syscalls.h>
 #include <linux/mman.h>
 #include <linux/file.h>
+#include <linux/fs.h>
 #include <linux/uaccess.h>
 #include <linux/ipc.h>
 #include <linux/unistd.h>
diff -puN arch/blackfin/kernel/traps.c~blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch arch/blackfin/kernel/traps.c
--- a/arch/blackfin/kernel/traps.c~blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch
+++ a/arch/blackfin/kernel/traps.c
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
+#include <linux/fs.h>
 #include <asm/traps.h>
 #include <asm/cacheflush.h>
 #include <asm/blackfin.h>
_

Patches currently in -mm which might be from bryan.wu@analog.com are

cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
blackfin-enable-arbitary-speed-serial-setting.patch
