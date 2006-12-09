From: akpm@osdl.org
Subject: + m68k-export_symbolcache_clearpush-bogus-comment.patch added to -mm tree
Date: Sat, 09 Dec 2006 14:34:23 -0800
Message-ID: <200612092234.kB9MYN75006123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55614 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875AbWLIWeb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 17:34:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     m68k: EXPORT_SYMBOL(cache_{clear,push}) bogus comment
has been added to the -mm tree.  Its filename is
     m68k-export_symbolcache_clearpush-bogus-comment.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: EXPORT_SYMBOL(cache_{clear,push}) bogus comment

Remove bogus comments about unexporting cache_{push,clear}(), as inline
dma_cache_maintenance() (used by at least bionet and pamsnet) calls them.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/m68k/mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/m68k/mm/memory.c~m68k-export_symbolcache_clearpush-bogus-comment arch/m68k/mm/memory.c
--- a/arch/m68k/mm/memory.c~m68k-export_symbolcache_clearpush-bogus-comment
+++ a/arch/m68k/mm/memory.c
@@ -299,7 +299,7 @@ void cache_clear (unsigned long paddr, i
 	mach_l2_flush(0);
 #endif
 }
-EXPORT_SYMBOL(cache_clear);	/* probably can be unexported */
+EXPORT_SYMBOL(cache_clear);
 
 
 /*
@@ -352,7 +352,7 @@ void cache_push (unsigned long paddr, in
 	mach_l2_flush(1);
 #endif
 }
-EXPORT_SYMBOL(cache_push);	/* probably can be unexported */
+EXPORT_SYMBOL(cache_push);
 
 #ifndef CONFIG_SINGLE_MEMORY_CHUNK
 int mm_end_of_chunk (unsigned long addr, int len)
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
m68k-hp300-hp-lance-updates.patch
sun3-general-updates.patch
sun3-scsi-make-sun3-scsi-drivers-compile-work-again.patch
m68k-atari-2618-atari-ide-interrupt-needs-sa_shirq.patch
m68k-export_symbolcache_clearpush-bogus-comment.patch
amiga-pcmcia-ne2000-ethernet-dev-irq-init.patch

