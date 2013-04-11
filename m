From: akpm@linux-foundation.org
Subject: + early_printk-consolidate-random-copies-of-identical-code-v3-fix-fix.patch added to -mm tree
Date: Thu, 11 Apr 2013 13:22:01 -0700
Message-ID: <20130411202201.7D77A5A41FA@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37567 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3DKUWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 16:22:03 -0400
Received: by mail-vc0-f202.google.com with SMTP id m16so181455vca.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 13:22:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paul.gortmaker@windriver.com, geert@linux-m68k.org, lethal@linux-sh.org, tglx@linutronix.de


The patch titled
     Subject: sh4: make the bios early console support depend on EARLY_PRINTK
has been added to the -mm tree.  Its filename is
     early_printk-consolidate-random-copies-of-identical-code-v3-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: sh4: make the bios early console support depend on EARLY_PRINTK

The commit "early_printk: consolidate random copies of identical code"
introduces a build failure for the lboxre2_defconfig because arch/sh
unconditionally assumes that there will be an early_console struct
present that it can populate with bios routines to drive the
early printk support.

Making this whole block conditional on EARLY_PRINTK solves the
problem and gets rid of unused runtime code for when the feature
is disabled at the same time.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/sh_bios.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/sh/kernel/sh_bios.c~early_printk-consolidate-random-copies-of-identical-code-v3-fix-fix arch/sh/kernel/sh_bios.c
--- a/arch/sh/kernel/sh_bios.c~early_printk-consolidate-random-copies-of-identical-code-v3-fix-fix
+++ a/arch/sh/kernel/sh_bios.c
@@ -104,6 +104,7 @@ void sh_bios_vbr_reload(void)
 		);
 }
 
+#ifdef CONFIG_EARLY_PRINTK
 /*
  *	Print a string through the BIOS
  */
@@ -168,3 +169,4 @@ static int __init setup_early_printk(cha
 	return 0;
 }
 early_param("earlyprintk", setup_early_printk);
+#endif
_

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

linux-next.patch
debug_locksh-make-warning-more-verbose.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix-fix.patch
misc-generic-on-chip-sram-allocation-driver.patch
media-coda-use-genalloc-api.patch
early_printk-consolidate-random-copies-of-identical-code.patch
early_printk-consolidate-random-copies-of-identical-code-v3.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix-fix.patch

