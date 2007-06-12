From: akpm@linux-foundation.org
Subject: - potential-parse-error-in-ifdef-part-3.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:56:46 -0700
Message-ID: <200706121856.l5CIuk0v018418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44133 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755974AbXFLS5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: padator@wanadoo.fr, ak@suse.de, jens.axboe@oracle.com, lethal@linux-sh.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     potential parse error in ifdef part 3
has been removed from the -mm tree.  Its filename was
     potential-parse-error-in-ifdef-part-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: potential parse error in ifdef part 3
From: Yoann Padioleau <padator@wanadoo.fr>

Fix various bits of obviously-busted code which we're not happening to
compile, due to ifdefs.

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/math-emu/fpu_entry.c |    2 +-
 arch/ppc/syslib/qspan_pci.c    |    4 ++--
 arch/sh64/kernel/pci_sh5.c     |    8 ++++----
 drivers/cdrom/mcdx.c           |    2 +-
 drivers/tc/zs.c                |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/i386/math-emu/fpu_entry.c~potential-parse-error-in-ifdef-part-3 arch/i386/math-emu/fpu_entry.c
--- a/arch/i386/math-emu/fpu_entry.c~potential-parse-error-in-ifdef-part-3
+++ a/arch/i386/math-emu/fpu_entry.c
@@ -754,7 +754,7 @@ int save_i387_soft(void *s387, struct _f
     return -1;
   if ( offset )
     if (__copy_to_user(d+other, (u_char *)&S387->st_space, offset))
-      return -1
+      return -1;
   RE_ENTRANT_CHECK_ON;
 
   return 1;
diff -puN arch/ppc/syslib/qspan_pci.c~potential-parse-error-in-ifdef-part-3 arch/ppc/syslib/qspan_pci.c
--- a/arch/ppc/syslib/qspan_pci.c~potential-parse-error-in-ifdef-part-3
+++ a/arch/ppc/syslib/qspan_pci.c
@@ -365,13 +365,13 @@ int qspan_pcibios_find_class(unsigned in
 }
 
 void __init
-m8xx_pcibios_fixup(void))
+m8xx_pcibios_fixup(void)
 {
    /* Lots to do here, all board and configuration specific. */
 }
 
 void __init
-m8xx_setup_pci_ptrs(void))
+m8xx_setup_pci_ptrs(void)
 {
 	set_config_access_method(qspan);
 
diff -puN arch/sh64/kernel/pci_sh5.c~potential-parse-error-in-ifdef-part-3 arch/sh64/kernel/pci_sh5.c
--- a/arch/sh64/kernel/pci_sh5.c~potential-parse-error-in-ifdef-part-3
+++ a/arch/sh64/kernel/pci_sh5.c
@@ -521,10 +521,10 @@ void __init pcibios_fixup_bus(struct pci
 		bus->resource[0]->start = PCIBIOS_MIN_IO;
 		bus->resource[1]->start = PCIBIOS_MIN_MEM;
 #else
-		bus->resource[0]->end = 0
-		bus->resource[1]->end = 0
-		bus->resource[0]->start =0
-		  bus->resource[1]->start = 0;
+		bus->resource[0]->end = 0;
+		bus->resource[1]->end = 0;
+		bus->resource[0]->start =0;
+		bus->resource[1]->start = 0;
 #endif
 		/* Turn off downstream PF memory address range by default */
 		bus->resource[2]->start = 1024*1024;
diff -puN drivers/cdrom/mcdx.c~potential-parse-error-in-ifdef-part-3 drivers/cdrom/mcdx.c
--- a/drivers/cdrom/mcdx.c~potential-parse-error-in-ifdef-part-3
+++ a/drivers/cdrom/mcdx.c
@@ -1053,11 +1053,11 @@ static void __exit mcdx_exit(void)
 	if (unregister_blkdev(MAJOR_NR, "mcdx") != 0) {
 		xwarn("cleanup() unregister_blkdev() failed\n");
 	}
-	blk_cleanup_queue(mcdx_queue);
 #if !MCDX_QUIET
 	else
 	xinfo("cleanup() succeeded\n");
 #endif
+	blk_cleanup_queue(mcdx_queue);
 }
 
 #ifdef MODULE
diff -puN drivers/tc/zs.c~potential-parse-error-in-ifdef-part-3 drivers/tc/zs.c
--- a/drivers/tc/zs.c~potential-parse-error-in-ifdef-part-3
+++ a/drivers/tc/zs.c
@@ -2182,7 +2182,7 @@ struct dec_serial_hook zs_kgdbhook = {
 	.init_info	= kgdbhook_init_info,
 	.rx_char	= kgdbhook_rx_char,
 	.cflags		= B38400 | CS8 | CLOCAL,
-}
+};
 
 void __init zs_kgdb_hook(int tty_num)
 {
_

Patches currently in -mm which might be from padator@wanadoo.fr are

origin.patch
atari_pamsnetc-old-declaration-ritchie-style-fix.patch
