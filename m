From: akpm@linux-foundation.org
Subject: + m68k-kill-superfluous-extern.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:18:09 -0700
Message-ID: <200708152118.l7FLI9T9015466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58278 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761373AbXHOVSp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:18:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     m68k: Kill superfluous extern
has been added to the -mm tree.  Its filename is
     m68k-kill-superfluous-extern.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: Kill superfluous extern
From: Geert Uytterhoeven <geert@linux-m68k.org>

Kill a superfluous extern declaration

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/motorola.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/m68k/mm/motorola.c~m68k-kill-superfluous-extern arch/m68k/mm/motorola.c
--- a/arch/m68k/mm/motorola.c~m68k-kill-superfluous-extern
+++ a/arch/m68k/mm/motorola.c
@@ -210,11 +210,7 @@ void __init paging_init(void)
 	int i;
 
 #ifdef DEBUG
-	{
-		extern unsigned long availmem;
-		printk ("start of paging_init (%p, %lx)\n",
-			kernel_pg_dir, availmem);
-	}
+	printk ("start of paging_init (%p, %lx)\n", kernel_pg_dir, availmem);
 #endif
 
 	/* Fix the cache mode in the page descriptors for the 680[46]0.  */
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-asm-pageh-needs-linux-compilerh.patch
m68k-kill-superfluous-extern.patch
m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch
remove-dead-code-in-via-pmu68k.patch
m68k-use-_ac-instead-of-ifdef-__assembly__.patch
m68k-enable-arbitary-speed-tty-support.patch
m68k-dont-include-rodata-into-text-segment.patch
m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch
zorro-make-sysfs-config-attribute-read-only.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
