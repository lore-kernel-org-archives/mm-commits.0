From: akpm@linux-foundation.org
Subject: [merged] frv-fix-use-of-extinct-_sbss-and-_ebss-in-debug-code.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:02:25 -0800
Message-ID: <20121218200225.B824582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:53112 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2LRUC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:02:26 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so125132yen.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:02:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: fix use of extinct _sbss and _ebss in debug code
has been removed from the -mm tree.  Its filename was
     frv-fix-use-of-extinct-_sbss-and-_ebss-in-debug-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
cris-fix-i-o-macros.patch
cris-use-int-for-ssize_t-to-match-size_t.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kconfig-centralise-config_arch_no_virt_to_bus.patch

