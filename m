From: akpm@linux-foundation.org
Subject: + frv-convert-to-asm-generic-hardirqh.patch added to -mm tree
Date: Wed, 12 Aug 2009 17:17:23 -0700
Message-ID: <200908130017.n7D0HNu4029965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbZHMARs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 20:17:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, dhowells@redhat.com


The patch titled
     frv: convert to asm-generic/hardirq.h
has been added to the -mm tree.  Its filename is
     frv-convert-to-asm-generic-hardirqh.patch

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
vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
vfs-allow-file-truncations-when-both-suid-and-write-permissions-set.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
alpha-convert-to-asm-generic-hardirqh.patch
avr32-convert-to-asm-generic-hardirqh.patch
cris-convert-to-asm-generic-hardirqh.patch
frv-convert-to-asm-generic-hardirqh.patch
h8300-convert-to-asm-generic-hardirqh.patch
m32r-convert-to-asm-generic-hardirqh.patch
m68k-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
um-convert-to-asm-generic-hardirqh.patch
xtensa-convert-to-asm-generic-hardirqh.patch

