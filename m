From: akpm@linux-foundation.org
Subject: - proper-prototype-for-signals_init.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:48 -0800
Message-ID: <200802070021.m170LTmG006341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935035AbYBGAod (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     proper prototype for signals_init()
has been removed from the -mm tree.  Its filename was
     proper-prototype-for-signals_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proper prototype for signals_init()
From: Adrian Bunk <bunk@kernel.org>

Add a proper prototype for signals_init() in include/linux/signal.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    2 ++
 init/main.c            |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/signal.h~proper-prototype-for-signals_init include/linux/signal.h
--- a/include/linux/signal.h~proper-prototype-for-signals_init
+++ a/include/linux/signal.h
@@ -371,6 +371,8 @@ int unhandled_signal(struct task_struct 
 	(!siginmask(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
 	 (t)->sighand->action[(signr)-1].sa.sa_handler == SIG_DFL)
 
+void signals_init(void);
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_SIGNAL_H */
diff -puN init/main.c~proper-prototype-for-signals_init init/main.c
--- a/init/main.c~proper-prototype-for-signals_init
+++ a/init/main.c
@@ -57,6 +57,7 @@
 #include <linux/device.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
+#include <linux/signal.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -83,7 +84,6 @@ extern void init_IRQ(void);
 extern void fork_init(unsigned long);
 extern void mca_init(void);
 extern void sbus_init(void);
-extern void signals_init(void);
 extern void pidhash_init(void);
 extern void pidmap_init(void);
 extern void prio_tree_init(void);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
