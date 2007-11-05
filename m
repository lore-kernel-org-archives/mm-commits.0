From: akpm@linux-foundation.org
Subject: + proper-show_interrupts-prototype.patch added to -mm tree
Date: Mon, 05 Nov 2007 14:59:00 -0800
Message-ID: <200711052259.lA5Mx0RS023988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203AbXKEW7K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 17:59:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     proper show_interrupts() prototype
has been added to the -mm tree.  Its filename is
     proper-show_interrupts-prototype.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -443,4 +443,6 @@ static inline void init_irq_proc(void)
 }
 #endif
 
+int show_interrupts(struct seq_file *p, void *v);
+
 #endif
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
fs-afs-vlocationc-fix-off-by-one.patch
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
git-dvb.patch
git-hwmon.patch
make-jffs2_get_acl-static.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
xtensa-iss_net_setup-must-be-__init.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
scheduled-oss-driver-removal.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
