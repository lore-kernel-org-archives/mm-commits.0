From: akpm@linux-foundation.org
Subject: [folded-merged] early_printk-consolidate-random-copies-of-identical-code-v3-fix-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 15:59:33 -0700
Message-ID: <20130429225933.BED405A418D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:60218 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3D2W7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 18:59:35 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so422534ves.4
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 15:59:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.gortmaker@windriver.com, geert@linux-m68k.org, lethal@linux-sh.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: sh4: make the bios early console support depend on EARLY_PRINTK
has been removed from the -mm tree.  Its filename was
     early_printk-consolidate-random-copies-of-identical-code-v3-fix-fix.patch

This patch was dropped because it was folded into early_printk-consolidate-random-copies-of-identical-code.patch

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


