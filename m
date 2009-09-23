From: akpm@linux-foundation.org
Subject: + frv-use-asm-generic-hardirqh.patch added to -mm tree
Date: Wed, 23 Sep 2009 02:07:13 -0700
Message-ID: <200909230907.n8N97DWt017730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbZIWJHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 05:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, dhowells@redhat.com


The patch titled
     frv: use asm/generic-hardirq.h
has been added to the -mm tree.  Its filename is
     frv-use-asm-generic-hardirqh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: use asm/generic-hardirq.h
From: Christoph Hellwig <hch@lst.de>

Use asm/generic-hardirq.h to build asm/hardirq.h and also remove the unused
idle_timestamp field in irq_cpustat whilst we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/hardirq.h |   17 ++++-------------
 arch/frv/kernel/process.c      |    4 ----
 2 files changed, 4 insertions(+), 17 deletions(-)

diff -puN arch/frv/include/asm/hardirq.h~frv-use-asm-generic-hardirqh arch/frv/include/asm/hardirq.h
--- a/arch/frv/include/asm/hardirq.h~frv-use-asm-generic-hardirqh
+++ a/arch/frv/include/asm/hardirq.h
@@ -12,24 +12,15 @@
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
+#include <asm/atomic.h>
 
 extern atomic_t irq_err_count;
 static inline void ack_bad_irq(int irq)
 {
 	atomic_inc(&irq_err_count);
 }
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
 
 #endif
diff -puN arch/frv/kernel/process.c~frv-use-asm-generic-hardirqh arch/frv/kernel/process.c
--- a/arch/frv/kernel/process.c~frv-use-asm-generic-hardirqh
+++ a/arch/frv/kernel/process.c
@@ -83,13 +83,9 @@ void (*idle)(void) = core_sleep_idle;
  */
 void cpu_idle(void)
 {
-	int cpu = smp_processor_id();
-
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
frv-use-asm-generic-hardirqh.patch
fcntl-add-f_etown_ex.patch

