From: akpm@linux-foundation.org
Subject: [merged]
 sh-remove-call-to-memset-after-dma_alloc_coherent.patch removed from -mm
 tree
Date: Thu, 09 Jul 2020 13:42:23 -0700
Message-ID: <20200709204223.UusBwCPjr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgGIUmY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 16:42:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be, glaubitz@physik.fu-berlin.de, krzk@kernel.org, kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org, romain.naour@gmail.com, sam@ravnborg.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: remove call to memset after dma_alloc_coherent
has been removed from the -mm tree.  Its filename was
     sh-remove-call-to-memset-after-dma_alloc_coherent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Zhou <chenzhou10@huawei.com>
Subject: sh: remove call to memset after dma_alloc_coherent

Function dma_alloc_coherent use in buf already zeroes out memory,
so memset is not needed.

Link: https://marc.info/?l=linux-sh&m=157793031102356
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Romain Naour <romain.naour@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/consistent.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/sh/mm/consistent.c~sh-remove-call-to-memset-after-dma_alloc_coherent
+++ a/arch/sh/mm/consistent.c
@@ -57,8 +57,6 @@ int __init platform_resource_setup_memor
 		return -ENOMEM;
 	}
 
-	memset(buf, 0, memsize);
