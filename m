From: akpm@linux-foundation.org
Subject: +
 sh-add-export_symbolmin_low_pfn-and-export_symbolmax_low_pfn-to-sh_ksyms_32c.patch added to -mm tree
Date: Mon, 16 Dec 2013 11:55:52 -0800
Message-ID: <52af5ac8.aY08kWvjqu7xmuca%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3LPTzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lethal@linux-sh.org, kuninori.morimoto.gx@gmail.com, geert@linux-m68k.org, nobuhiro.iwamatsu.yj@renesas.com

Subject: + sh-add-export_symbolmin_low_pfn-and-export_symbolmax_low_pfn-to-sh_ksyms_32c.patch added to -mm tree
To: nobuhiro.iwamatsu.yj@renesas.com,geert@linux-m68k.org,kuninori.morimoto.gx@gmail.com,lethal@linux-sh.org
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:52 -0800


The patch titled
     Subject: sh: add EXPORT_SYMBOL(min_low_pfn) and EXPORT_SYMBOL(max_low_pfn) to sh_ksyms_32.c
has been added to the -mm tree.  Its filename is
     sh-add-export_symbolmin_low_pfn-and-export_symbolmax_low_pfn-to-sh_ksyms_32c.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-add-export_symbolmin_low_pfn-and-export_symbolmax_low_pfn-to-sh_ksyms_32c.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-add-export_symbolmin_low_pfn-and-export_symbolmax_low_pfn-to-sh_ksyms_32c.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: sh: add EXPORT_SYMBOL(min_low_pfn) and EXPORT_SYMBOL(max_low_pfn) to sh_ksyms_32.c

Min_low_pfn and max_low_pfn were used in pfn_valid macro if defined
CONFIG_FLATMEM. When the functions that use the pfn_valid is used in driver
module, max_low_pfn and min_low_pfn is to undefined, and fail to build.

ERROR: "min_low_pfn" [drivers/block/aoe/aoe.ko] undefined!
ERROR: "max_low_pfn" [drivers/block/aoe/aoe.ko] undefined!
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2

This patch fix this problem.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/sh_ksyms_32.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/sh/kernel/sh_ksyms_32.c~sh-add-export_symbolmin_low_pfn-and-export_symbolmax_low_pfn-to-sh_ksyms_32c arch/sh/kernel/sh_ksyms_32.c
--- a/arch/sh/kernel/sh_ksyms_32.c~sh-add-export_symbolmin_low_pfn-and-export_symbolmax_low_pfn-to-sh_ksyms_32c
+++ a/arch/sh/kernel/sh_ksyms_32.c
@@ -20,6 +20,11 @@ EXPORT_SYMBOL(csum_partial_copy_generic)
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(__clear_user);
 EXPORT_SYMBOL(empty_zero_page);
+#ifdef CONFIG_FLATMEM
+/* need in pfn_valid macro */
+EXPORT_SYMBOL(min_low_pfn);
+EXPORT_SYMBOL(max_low_pfn);
+#endif
 
 #define DECLARE_EXPORT(name)		\
 	extern void name(void);EXPORT_SYMBOL(name)
_

Patches currently in -mm which might be from nobuhiro.iwamatsu.yj@renesas.com are

sh-always-link-in-helper-functions-extracted-from-libgcc.patch
sh-add-export_symbolmin_low_pfn-and-export_symbolmax_low_pfn-to-sh_ksyms_32c.patch

