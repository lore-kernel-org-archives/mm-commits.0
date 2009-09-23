From: akpm@linux-foundation.org
Subject: [to-be-updated] frv-convert-to-asm-generic-hardirqh.patch removed from -mm tree
Date: Wed, 23 Sep 2009 02:06:31 -0700
Message-ID: <200909230906.n8N96VYJ016316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbZIWJHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 05:07:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: convert to asm-generic/hardirq.h
has been removed from the -mm tree.  Its filename was
     frv-convert-to-asm-generic-hardirqh.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: convert to asm-generic/hardirq.h
From: Christoph Hellwig <hch@lst.de>

And also remove the unused idle_timestamp field in irq_cpustat.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/hardirq.h |   17 +++--------------
 arch/frv/kernel/process.c      |    2 --
 2 files changed, 3 insertions(+), 16 deletions(-)

diff -puN arch/frv/include/asm/hardirq.h~frv-convert-to-asm-generic-hardirqh arch/frv/include/asm/hardirq.h
--- a/arch/frv/include/asm/hardirq.h~frv-convert-to-asm-generic-hardirqh
+++ a/arch/frv/include/asm/hardirq.h
@@ -12,24 +12,13 @@
 #ifndef __ASM_HARDIRQ_H
 #define __ASM_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-	unsigned long idle_timestamp;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
-#ifdef CONFIG_SMP
-#error SMP not available on FR-V
-#endif /* CONFIG_SMP */
-
 extern atomic_t irq_err_count;
 static inline void ack_bad_irq(int irq)
 {
 	atomic_inc(&irq_err_count);
 }
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
 
 #endif
diff -puN arch/frv/kernel/process.c~frv-convert-to-asm-generic-hardirqh arch/frv/kernel/process.c
--- a/arch/frv/kernel/process.c~frv-convert-to-asm-generic-hardirqh
+++ a/arch/frv/kernel/process.c
@@ -88,8 +88,6 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		while (!need_resched()) {
-			irq_stat[cpu].idle_timestamp = jiffies;
-
 			check_pgt_cache();
 
 			if (!frv_dma_inprogress && idle)
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
fs-turn-iprune_mutex-into-rwsem.patch
ntfs-remove-ntfs_file_write.patch
qnx4-remove-write-support.patch
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
fcntl-add-f_etown_ex.patch

