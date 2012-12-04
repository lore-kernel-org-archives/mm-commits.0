From: akpm@linux-foundation.org
Subject: + frv-properly-use-the-declarations-provided-by-asm-sectionsh.patch added to -mm tree
Date: Tue, 04 Dec 2012 13:07:33 -0800
Message-ID: <20121204210734.A395420005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:45737 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2LDVHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 16:07:36 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so87633wib.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 13:07:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dhowells@redhat.com


The patch titled
     Subject: frv: properly use the declarations provided by <asm/sections.h>
has been added to the -mm tree.  Its filename is
     frv-properly-use-the-declarations-provided-by-asm-sectionsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
cris-fix-i-o-macros.patch
cris-use-int-for-ssize_t-to-match-size_t.patch
frv-fix-use-of-extinct-_sbss-and-_ebss-in-debug-code.patch
frv-properly-use-the-declarations-provided-by-asm-sectionsh.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kconfig-centralise-config_arch_no_virt_to_bus.patch

