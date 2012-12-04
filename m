From: akpm@linux-foundation.org
Subject: + frv-fix-use-of-extinct-_sbss-and-_ebss-in-debug-code.patch added to -mm tree
Date: Tue, 04 Dec 2012 13:07:29 -0800
Message-ID: <20121204210730.C22AB200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40717 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2LDVHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 16:07:33 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so321239eei.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 13:07:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dhowells@redhat.com


The patch titled
     Subject: frv: fix use of extinct _sbss and _ebss in debug code
has been added to the -mm tree.  Its filename is
     frv-fix-use-of-extinct-_sbss-and-_ebss-in-debug-code.patch

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
Subject: frv: fix use of extinct _sbss and _ebss in debug code

Nowadays it should probably use __bss_start and __bss_stop

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/setup.c |    2 +-
 arch/frv/mm/init.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/frv/kernel/setup.c~frv-fix-use-of-extinct-_sbss-and-_ebss-in-debug-code arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~frv-fix-use-of-extinct-_sbss-and-_ebss-in-debug-code
+++ a/arch/frv/kernel/setup.c
@@ -817,7 +817,7 @@ void __init setup_arch(char **cmdline_p)
 	printk("KERNEL -> TEXT=0x%06x-0x%06x DATA=0x%06x-0x%06x BSS=0x%06x-0x%06x\n",
 	       (int) &_stext, (int) &_etext,
 	       (int) &_sdata, (int) &_edata,
-	       (int) &_sbss, (int) &_ebss);
+	       (int) &__bss_start, (int) &__bss_stop);
 #endif
 
 #ifdef CONFIG_VT
diff -puN arch/frv/mm/init.c~frv-fix-use-of-extinct-_sbss-and-_ebss-in-debug-code arch/frv/mm/init.c
--- a/arch/frv/mm/init.c~frv-fix-use-of-extinct-_sbss-and-_ebss-in-debug-code
+++ a/arch/frv/mm/init.c
@@ -146,7 +146,7 @@ void __init mem_init(void)
 
 #else
 	codek = (_etext - _stext) >> 10;
-	datak = 0; //(_ebss - _sdata) >> 10;
+	datak = 0; //(__bss_stop - _sdata) >> 10;
 #endif
 
 	tmp = nr_free_pages() << PAGE_SHIFT;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
cris-fix-i-o-macros.patch
cris-use-int-for-ssize_t-to-match-size_t.patch
frv-fix-use-of-extinct-_sbss-and-_ebss-in-debug-code.patch
frv-properly-use-the-declarations-provided-by-asm-sectionsh.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kconfig-centralise-config_arch_no_virt_to_bus.patch

