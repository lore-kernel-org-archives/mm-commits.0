From: akpm@linux-foundation.org
Subject: - proper-show_interrupts-prototype.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:32 -0800
Message-ID: <200802070021.m170LDPx006297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933492AbYBGAoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     proper show_interrupts() prototype
has been removed from the -mm tree.  Its filename was
     proper-show_interrupts-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proper show_interrupts() prototype
From: Adrian Bunk <bunk@kernel.org>

Add a proper prototype for show_interrupts() in include/linux/interrupt.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/irq.c   |    1 +
 fs/proc/proc_misc.c       |    2 +-
 include/linux/interrupt.h |    2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/h8300/kernel/irq.c~proper-show_interrupts-prototype arch/h8300/kernel/irq.c
--- a/arch/h8300/kernel/irq.c~proper-show_interrupts-prototype
+++ a/arch/h8300/kernel/irq.c
@@ -14,6 +14,7 @@
 #include <linux/random.h>
 #include <linux/bootmem.h>
 #include <linux/irq.h>
+#include <linux/interrupt.h>
 
 #include <asm/system.h>
 #include <asm/traps.h>
diff -puN fs/proc/proc_misc.c~proper-show_interrupts-prototype fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~proper-show_interrupts-prototype
+++ a/fs/proc/proc_misc.c
@@ -29,6 +29,7 @@
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/pagemap.h>
+#include <linux/interrupt.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
@@ -599,7 +600,6 @@ static void int_seq_stop(struct seq_file
 }
 
 
-extern int show_interrupts(struct seq_file *f, void *v); /* In arch code */
 static struct seq_operations int_seq_ops = {
 	.start = int_seq_start,
 	.next  = int_seq_next,
diff -puN include/linux/interrupt.h~proper-show_interrupts-prototype include/linux/interrupt.h
--- a/include/linux/interrupt.h~proper-show_interrupts-prototype
+++ a/include/linux/interrupt.h
@@ -444,4 +444,6 @@ static inline void init_irq_proc(void)
 }
 #endif
 
+int show_interrupts(struct seq_file *p, void *v);
+
 #endif
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
