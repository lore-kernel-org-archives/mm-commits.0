From: akpm@linux-foundation.org
Subject: [merged] frv-properly-use-the-declarations-provided-by-asm-sectionsh.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:02:28 -0800
Message-ID: <20121218200229.1F77B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:34949 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2LRUCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:02:31 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so63131wgb.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:02:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: properly use the declarations provided by <asm/sections.h>
has been removed from the -mm tree.  Its filename was
     frv-properly-use-the-declarations-provided-by-asm-sectionsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: frv: properly use the declarations provided by <asm/sections.h>

  - Remove the superfluous address-of ('&') operators,
  - Remove the unneeded casts, use %p to format pointers instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/setup.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN arch/frv/kernel/setup.c~frv-properly-use-the-declarations-provided-by-asm-sectionsh arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~frv-properly-use-the-declarations-provided-by-asm-sectionsh
+++ a/arch/frv/kernel/setup.c
@@ -804,9 +804,9 @@ void __init setup_arch(char **cmdline_p)
 
 	BUG_ON(memory_start == memory_end);
 
-	init_mm.start_code = (unsigned long) &_stext;
-	init_mm.end_code = (unsigned long) &_etext;
-	init_mm.end_data = (unsigned long) &_edata;
+	init_mm.start_code = (unsigned long) _stext;
+	init_mm.end_code = (unsigned long) _etext;
+	init_mm.end_data = (unsigned long) _edata;
 #if 0 /* DAVIDM - don't set brk just incase someone decides to use it */
 	init_mm.brk = (unsigned long) &_end;
 #else
@@ -814,10 +814,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 #ifdef DEBUG
-	printk("KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x BSS=0x%06x-0x%06x\n",
-	       (int) &_stext, (int) &_etext,
-	       (int) &_sdata, (int) &_edata,
-	       (int) &__bss_start, (int) &__bss_stop);
+	printk("KERNEL -> TEXT=0x%p-0x%p DATA=0x%p-0x%p BSS=0x%p-0x%p\n",
+	       _stext, _etext, _sdata, _edata, __bss_start, __bss_stop);
 #endif
 
 #ifdef CONFIG_VT
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
cris-fix-i-o-macros.patch
cris-use-int-for-ssize_t-to-match-size_t.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kconfig-centralise-config_arch_no_virt_to_bus.patch

