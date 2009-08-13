From: akpm@linux-foundation.org
Subject: + cris-convert-to-asm-generic-hardirqh.patch added to -mm tree
Date: Wed, 12 Aug 2009 17:17:21 -0700
Message-ID: <200908130017.n7D0HL5C029873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZHMARe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 20:17:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris: convert to asm-generic/hardirq.h
has been added to the -mm tree.  Its filename is
     cris-convert-to-asm-generic-hardirqh.patch

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

