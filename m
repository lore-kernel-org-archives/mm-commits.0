From: akpm@linux-foundation.org
Subject: [merged] h8300-convert-to-asm-generic-hardirqh.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:44:11 -0700
Message-ID: <200909222044.n8MKiBZP013093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbZIVUo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:44:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300: convert to asm-generic/hardirq.h
has been removed from the -mm tree.  Its filename was
     h8300-convert-to-asm-generic-hardirqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: convert to asm-generic/hardirq.h
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/hardirq.h |   15 +++------------
 arch/h8300/kernel/irq.c          |    5 -----
 2 files changed, 3 insertions(+), 17 deletions(-)

diff -puN arch/h8300/include/asm/hardirq.h~h8300-convert-to-asm-generic-hardirqh arch/h8300/include/asm/hardirq.h
--- a/arch/h8300/include/asm/hardirq.h~h8300-convert-to-asm-generic-hardirqh
+++ a/arch/h8300/include/asm/hardirq.h
@@ -1,18 +1,7 @@
 #ifndef __H8300_HARDIRQ_H
 #define __H8300_HARDIRQ_H
 
-#include <linux/kernel.h>
-#include <linux/threads.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
-extern void ack_bad_irq(unsigned int irq);
+#include <asm/irq.h>
 
 #define HARDIRQ_BITS	8
 
@@ -25,4 +14,6 @@ extern void ack_bad_irq(unsigned int irq
 # error HARDIRQ_BITS is too low!
 #endif
 
+#include <asm-generic/hardirq.h>
+
 #endif
diff -puN arch/h8300/kernel/irq.c~h8300-convert-to-asm-generic-hardirqh arch/h8300/kernel/irq.c
--- a/arch/h8300/kernel/irq.c~h8300-convert-to-asm-generic-hardirqh
+++ a/arch/h8300/kernel/irq.c
@@ -81,11 +81,6 @@ struct irq_chip h8300irq_chip = {
 	.end		= h8300_end_irq,
 };
 
-void ack_bad_irq(unsigned int irq)
-{
-	printk("unexpected IRQ trap at vector %02x\n", irq);
-}
-
 #if defined(CONFIG_RAMKERNEL)
 static unsigned long __init *get_vector_address(void)
 {
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
avr32-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
vfs-seq_file-add-helpers-for-data-filling.patch
libfs-return-error-code-on-failed-attr-set.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
xtensa-convert-to-asm-generic-hardirqh.patch
frv-convert-to-asm-generic-hardirqh.patch
fs-turn-iprune_mutex-into-rwsem.patch
ntfs-remove-ntfs_file_write.patch
qnx4-remove-write-support.patch
fcntl-add-f_etown_ex.patch

