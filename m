From: akpm@linux-foundation.org
Subject: + xtensa-convert-to-asm-generic-hardirqh.patch added to -mm tree
Date: Wed, 12 Aug 2009 17:17:37 -0700
Message-ID: <200908130017.n7D0HbJv030452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957AbZHMARp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 20:17:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, chris@zankel.net


The patch titled
     xtensa: convert to asm-generic/hardirq.h
has been added to the -mm tree.  Its filename is
     xtensa-convert-to-asm-generic-hardirqh.patch

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
Subject: xtensa: convert to asm-generic/hardirq.h
From: Christoph Hellwig <hch@lst.de>

Also remove lots of unused irq_cpustat fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/hardirq.h |   15 +++------------
 arch/xtensa/kernel/irq.c          |    9 ---------
 2 files changed, 3 insertions(+), 21 deletions(-)

diff -puN arch/xtensa/include/asm/hardirq.h~xtensa-convert-to-asm-generic-hardirqh arch/xtensa/include/asm/hardirq.h
--- a/arch/xtensa/include/asm/hardirq.h~xtensa-convert-to-asm-generic-hardirqh
+++ a/arch/xtensa/include/asm/hardirq.h
@@ -11,18 +11,9 @@
 #ifndef _XTENSA_HARDIRQ_H
 #define _XTENSA_HARDIRQ_H
 
-#include <linux/cache.h>
-#include <asm/irq.h>
-
-/* headers.S is sensitive to the offsets of these fields */
-typedef struct {
-	unsigned int __softirq_pending;
-	unsigned int __syscall_count;
-	struct task_struct * __ksoftirqd_task; /* waitqueue is too large */
-	unsigned int __nmi_count;	       /* arch dependent */
-} ____cacheline_aligned irq_cpustat_t;
-
 void ack_bad_irq(unsigned int irq);
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
 
 #endif	/* _XTENSA_HARDIRQ_H */
diff -puN arch/xtensa/kernel/irq.c~xtensa-convert-to-asm-generic-hardirqh arch/xtensa/kernel/irq.c
--- a/arch/xtensa/kernel/irq.c~xtensa-convert-to-asm-generic-hardirqh
+++ a/arch/xtensa/kernel/irq.c
@@ -27,15 +27,6 @@ static unsigned int cached_irq_mask;
 atomic_t irq_err_count;
 
 /*
- * 'what should we do if we get a hw irq event on an illegal vector'.
- * each architecture has to answer this themselves.
- */
-void ack_bad_irq(unsigned int irq)
-{
-          printk("unexpected IRQ trap at vector %02x\n", irq);
-}
-
-/*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
  * handlers).
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

