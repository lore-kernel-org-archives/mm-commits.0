From: akpm@linux-foundation.org
Subject: [merged]
 sh-convert-iounmap-macros-to-inline-functions.patch removed from -mm tree
Date: Fri, 05 Jun 2020 13:21:28 -0700
Message-ID: <20200605202128.mYYFKkvG7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgFEUV3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:21:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be, glaubitz@physik.fu-berlin.de, krzk@kernel.org, kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org, romain.naour@gmail.com, sam@ravnborg.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: convert iounmap() macros to inline functions
has been removed from the -mm tree.  Its filename was
     sh-convert-iounmap-macros-to-inline-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: sh: convert iounmap() macros to inline functions

Macro iounmap() does nothing, but that results in unused variable warnings
all over the place.  This patch convert it to inline to avoid warning

We will get this kind of warning without this patch

	${LINUX}/drivers/thermal/broadcom/ns-thermal.c:78:21: \
	  warning: unused variable 'ns_thermal' [-Wunused-variable]
	struct ns_thermal *ns_thermal = platform_get_drvdata(pdev);
	^~~~~~~~~~

Link: https://marc.info/?l=linux-sh&m=157656903716172
Fixes: 98c90e5ea34e9 ("sh: remove __iounmap")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Romain Naour <romain.naour@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/io.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/include/asm/io.h~sh-convert-iounmap-macros-to-inline-functions
+++ a/arch/sh/include/asm/io.h
@@ -328,7 +328,7 @@ __ioremap_mode(phys_addr_t offset, unsig
 #else
 #define __ioremap(offset, size, prot)		((void __iomem *)(offset))
 #define __ioremap_mode(offset, size, prot)	((void __iomem *)(offset))
-#define iounmap(addr)				do { } while (0)
+static inline void iounmap(void __iomem *addr) {}
 #endif /* CONFIG_MMU */
 
 static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
_

Patches currently in -mm which might be from kuninori.morimoto.gx@renesas.com are

sh-clkfwk-remove-r8-r16-r32.patch
sh-use-generic-strncpy.patch
sh-add-missing-export_symbol-for-__delay.patch
