From: akpm@linux-foundation.org
Subject: [merged] m32r-convert-to-asm-generic-hardirqh.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:44:32 -0700
Message-ID: <200909222044.n8MKiWST013802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbZIVUop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:44:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: convert to asm-generic/hardirq.h
has been removed from the -mm tree.  Its filename was
     m32r-convert-to-asm-generic-hardirqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: convert to asm-generic/hardirq.h
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/hardirq.h |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN arch/m32r/include/asm/hardirq.h~m32r-convert-to-asm-generic-hardirqh arch/m32r/include/asm/hardirq.h
--- a/arch/m32r/include/asm/hardirq.h~m32r-convert-to-asm-generic-hardirqh
+++ a/arch/m32r/include/asm/hardirq.h
@@ -2,14 +2,7 @@
 #ifndef __ASM_HARDIRQ_H
 #define __ASM_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+#include <asm/irq.h>
 
 #if NR_IRQS > 256
 #define HARDIRQ_BITS	9
@@ -26,11 +19,7 @@ typedef struct {
 # error HARDIRQ_BITS is too low!
 #endif
 
-static inline void ack_bad_irq(int irq)
-{
-	printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", irq);
-	BUG();
-}
+#include <asm-generic/hardirq.h>
 
 #endif /* __ASM_HARDIRQ_H */
 #endif /* __KERNEL__ */
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

