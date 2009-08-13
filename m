From: akpm@linux-foundation.org
Subject: + avr32-convert-to-asm-generic-hardirqh.patch added to -mm tree
Date: Wed, 12 Aug 2009 17:17:19 -0700
Message-ID: <200908130017.n7D0HJFu029865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbZHMARf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 20:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, hskinnemoen@atmel.com


The patch titled
     avr32: convert to asm-generic/hardirq.h
has been added to the -mm tree.  Its filename is
     avr32-convert-to-asm-generic-hardirqh.patch

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
Subject: avr32: convert to asm-generic/hardirq.h
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/hardirq.h |   19 +------------------
 arch/avr32/kernel/irq.c          |    9 ---------
 2 files changed, 1 insertion(+), 27 deletions(-)

diff -puN arch/avr32/include/asm/hardirq.h~avr32-convert-to-asm-generic-hardirqh arch/avr32/include/asm/hardirq.h
--- a/arch/avr32/include/asm/hardirq.h~avr32-convert-to-asm-generic-hardirqh
+++ a/arch/avr32/include/asm/hardirq.h
@@ -1,23 +1,6 @@
 #ifndef __ASM_AVR32_HARDIRQ_H
 #define __ASM_AVR32_HARDIRQ_H
-
-#include <linux/threads.h>
-#include <asm/irq.h>
-
 #ifndef __ASSEMBLY__
-
-#include <linux/cache.h>
-
-/* entry.S is sensitive to the offsets of these fields */
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-void ack_bad_irq(unsigned int irq);
-
-/* Standard mappings for irq_cpustat_t above */
-#include <linux/irq_cpustat.h>
-
+#include <asm-generic/hardirq.h>
 #endif /* __ASSEMBLY__ */
-
 #endif /* __ASM_AVR32_HARDIRQ_H */
diff -puN arch/avr32/kernel/irq.c~avr32-convert-to-asm-generic-hardirqh arch/avr32/kernel/irq.c
--- a/arch/avr32/kernel/irq.c~avr32-convert-to-asm-generic-hardirqh
+++ a/arch/avr32/kernel/irq.c
@@ -16,15 +16,6 @@
 #include <linux/seq_file.h>
 #include <linux/sysdev.h>
 
-/*
- * 'what should we do if we get a hw irq event on an illegal vector'.
- * each architecture has to answer this themselves.
- */
-void ack_bad_irq(unsigned int irq)
-{
-	printk("unexpected IRQ %u\n", irq);
-}
-
 /* May be overridden by platform code */
 int __weak nmi_enable(void)
 {
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

