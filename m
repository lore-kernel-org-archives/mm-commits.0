From: akpm@linux-foundation.org
Subject: [merged] cris-convert-to-asm-generic-hardirqh.patch removed from -mm tree
Date: Wed, 02 Sep 2009 12:08:15 -0700
Message-ID: <200909021908.n82J8FNL010391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209AbZIBTI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 15:08:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: convert to asm-generic/hardirq.h
has been removed from the -mm tree.  Its filename was
     cris-convert-to-asm-generic-hardirqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: convert to asm-generic/hardirq.h
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/hardirq.h |   12 ++----------
 arch/cris/kernel/irq.c          |    5 -----
 2 files changed, 2 insertions(+), 15 deletions(-)

diff -puN arch/cris/include/asm/hardirq.h~cris-convert-to-asm-generic-hardirqh arch/cris/include/asm/hardirq.h
--- a/arch/cris/include/asm/hardirq.h~cris-convert-to-asm-generic-hardirqh
+++ a/arch/cris/include/asm/hardirq.h
@@ -2,16 +2,6 @@
 #define __ASM_HARDIRQ_H
 
 #include <asm/irq.h>
-#include <linux/threads.h>
-#include <linux/cache.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h> /* Standard mappings for irq_cpustat_t above */
-
-void ack_bad_irq(unsigned int irq);
 
 #define HARDIRQ_BITS	8
 
@@ -24,4 +14,6 @@ void ack_bad_irq(unsigned int irq);
 # error HARDIRQ_BITS is too low!
 #endif
 
+#include <asm-generic/hardirq.h>
+
 #endif /* __ASM_HARDIRQ_H */
diff -puN arch/cris/kernel/irq.c~cris-convert-to-asm-generic-hardirqh arch/cris/kernel/irq.c
--- a/arch/cris/kernel/irq.c~cris-convert-to-asm-generic-hardirqh
+++ a/arch/cris/kernel/irq.c
@@ -38,11 +38,6 @@
 
 #include <asm/io.h>
 
-void ack_bad_irq(unsigned int irq)
-{
-	printk("unexpected IRQ trap at vector %02x\n", irq);
-}
-
 int show_interrupts(struct seq_file *p, void *v)
 {
 	int i = *(loff_t *) v, j;
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
avr32-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
vfs-fix-d_path-for-unreachable-paths.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
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
h8300-convert-to-asm-generic-hardirqh.patch
alpha-convert-to-asm-generic-hardirqh.patch
m32r-convert-to-asm-generic-hardirqh.patch
m68k-convert-to-asm-generic-hardirqh.patch
um-convert-to-asm-generic-hardirqh.patch
fs-turn-iprune_mutex-into-rwsem.patch
ntfs-remove-ntfs_file_write.patch
qnx4-remove-write-support.patch
fcntl-add-f_etown_ex.patch

