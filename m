From: akpm@linux-foundation.org
Subject: - remove-capabilityh-from-mmh.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:49 -0700
Message-ID: <200707162055.l6GKtnvh001967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757300AbXGPVJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:09:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Remove capability.h from mm.h
has been removed from the -mm tree.  Its filename was
     remove-capabilityh-from-mmh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove capability.h from mm.h
From: Alexey Dobriyan <adobriyan@gmail.com>

I forgot to remove capability.h from mm.h while removing sched.h!  This
patch remedies that, because the only inline function which was using
CAP_something was made out of line.

Cross-compile tested without regressions on:

	all powerpc defconfigs
	all mips defconfigs
	all m68k defconfigs
	all arm defconfigs
	all ia64 defconfigs

	alpha alpha-allnoconfig alpha-defconfig alpha-up
	arm
	i386 i386-allnoconfig i386-defconfig i386-up
	ia64 ia64-allnoconfig ia64-defconfig ia64-up
	m68k
	mips
	parisc parisc-allnoconfig parisc-defconfig parisc-up
	powerpc powerpc-up
	s390 s390-allnoconfig s390-defconfig s390-up
	sparc sparc-allnoconfig sparc-defconfig sparc-up
	sparc64 sparc64-allnoconfig sparc64-defconfig sparc64-up
	um-x86_64
	x86_64 x86_64-allnoconfig x86_64-defconfig x86_64-up

as well as my two usual configs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci-sysfs.c |    2 +-
 drivers/pci/proc.c      |    2 +-
 fs/gfs2/eaops.c         |    1 +
 include/linux/mm.h      |    1 -
 kernel/time/ntp.c       |    2 +-
 5 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/pci/pci-sysfs.c~remove-capabilityh-from-mmh drivers/pci/pci-sysfs.c
--- a/drivers/pci/pci-sysfs.c~remove-capabilityh-from-mmh
+++ a/drivers/pci/pci-sysfs.c
@@ -20,7 +20,7 @@
 #include <linux/stat.h>
 #include <linux/topology.h>
 #include <linux/mm.h>
-
+#include <linux/capability.h>
 #include "pci.h"
 
 static int sysfs_initialized;	/* = 0 */
diff -puN drivers/pci/proc.c~remove-capabilityh-from-mmh drivers/pci/proc.c
--- a/drivers/pci/proc.c~remove-capabilityh-from-mmh
+++ a/drivers/pci/proc.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-
+#include <linux/capability.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 #include "pci.h"
diff -puN fs/gfs2/eaops.c~remove-capabilityh-from-mmh fs/gfs2/eaops.c
--- a/fs/gfs2/eaops.c~remove-capabilityh-from-mmh
+++ a/fs/gfs2/eaops.c
@@ -11,6 +11,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
+#include <linux/capability.h>
 #include <linux/xattr.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
diff -puN include/linux/mm.h~remove-capabilityh-from-mmh include/linux/mm.h
--- a/include/linux/mm.h~remove-capabilityh-from-mmh
+++ a/include/linux/mm.h
@@ -2,7 +2,6 @@
 #define _LINUX_MM_H
 
 #include <linux/errno.h>
-#include <linux/capability.h>
 
 #ifdef __KERNEL__
 
diff -puN kernel/time/ntp.c~remove-capabilityh-from-mmh kernel/time/ntp.c
--- a/kernel/time/ntp.c~remove-capabilityh-from-mmh
+++ a/kernel/time/ntp.c
@@ -13,7 +13,7 @@
 #include <linux/timex.h>
 #include <linux/jiffies.h>
 #include <linux/hrtimer.h>
-
+#include <linux/capability.h>
 #include <asm/div64.h>
 #include <asm/timex.h>
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
ptrace_peekdata-consolidation.patch
ptrace_pokedata-consolidation.patch
