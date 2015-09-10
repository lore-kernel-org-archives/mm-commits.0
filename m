From: akpm@linux-foundation.org
Subject: +
 mm-early_ioremap-add-explicit-include-of-asm-early_ioremaph.patch added to
 -mm tree
Date: Thu, 10 Sep 2015 13:32:47 -0700
Message-ID: <55f1e8ef.o/zeboTzunXAPNS+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbbIJUcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 16:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, msalter@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/early_ioremap: add explicit #include of asm/early_ioremap.h
has been added to the -mm tree.  Its filename is
     mm-early_ioremap-add-explicit-include-of-asm-early_ioremaph.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-early_ioremap-add-explicit-include-of-asm-early_ioremaph.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-early_ioremap-add-explicit-include-of-asm-early_ioremaph.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: mm/early_ioremap: add explicit #include of asm/early_ioremap.h

Commit 6b0f68e32ea8 ("mm: add utility for early copy from unmapped ram")
introduces a function copy_from_early_mem() into mm/early_ioremap.c which
itself calls early_memremap()/early_memunmap().  However, since
early_memunmap() has not been declared yet at this point in the .c file,
nor by any explicitly included header files, we are depending on a
transitive include of asm/early_ioremap.h to declare it, which is fragile.

So instead, include this header explicitly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/early_ioremap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/early_ioremap.c~mm-early_ioremap-add-explicit-include-of-asm-early_ioremaph mm/early_ioremap.c
--- a/mm/early_ioremap.c~mm-early_ioremap-add-explicit-include-of-asm-early_ioremaph
+++ a/mm/early_ioremap.c
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <asm/fixmap.h>
+#include <asm/early_ioremap.h>
 
 #ifdef CONFIG_MMU
 static int early_ioremap_debug __initdata;
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

mm-early_ioremap-add-explicit-include-of-asm-early_ioremaph.patch

