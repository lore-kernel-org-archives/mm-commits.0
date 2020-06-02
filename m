From: akpm@linux-foundation.org
Subject: + sh-remove-call-to-memset-after-dma_alloc_coherent.patch
 added to -mm tree
Date: Mon, 01 Jun 2020 17:55:39 -0700
Message-ID: <20200602005539.IYkgw8zEt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBAzl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 20:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be, glaubitz@physik.fu-berlin.de, krzk@kernel.org, kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org, romain.naour@gmail.com, sam@ravnborg.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: remove call to memset after dma_alloc_coherent
has been added to the -mm tree.  Its filename is
     sh-remove-call-to-memset-after-dma_alloc_coherent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-remove-call-to-memset-after-dma_alloc_coherent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-remove-call-to-memset-after-dma_alloc_coherent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
