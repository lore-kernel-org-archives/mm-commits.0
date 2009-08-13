From: akpm@linux-foundation.org
Subject: + sparc32-convert-to-asm-generic-hardirqh.patch added to -mm tree
Date: Wed, 12 Aug 2009 17:17:33 -0700
Message-ID: <200908130017.n7D0HXAp030258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbZHMARn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 20:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, davem@davemloft.net


The patch titled
     sparc32: convert to asm-generic/hardirq.h
has been added to the -mm tree.  Its filename is
     sparc32-convert-to-asm-generic-hardirqh.patch

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
Subject: sparc32: convert to asm-generic/hardirq.h
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/hardirq_32.h |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN arch/sparc/include/asm/hardirq_32.h~sparc32-convert-to-asm-generic-hardirqh arch/sparc/include/asm/hardirq_32.h
--- a/arch/sparc/include/asm/hardirq_32.h~sparc32-convert-to-asm-generic-hardirqh
+++ a/arch/sparc/include/asm/hardirq_32.h
@@ -7,17 +7,7 @@
 #ifndef __SPARC_HARDIRQ_H
 #define __SPARC_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/spinlock.h>
-#include <linux/cache.h>
-
-/* entry.S is sensitive to the offsets of these fields */ /* XXX P3 Is it? */
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
 #define HARDIRQ_BITS    8
+#include <asm-generic/hardirq.h>
 
 #endif /* __SPARC_HARDIRQ_H */
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

