From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-fix-build-error-in-mm-initc.patch added to -mm tree
Date: Mon, 13 Apr 2020 13:34:46 -0700
Message-ID: <20200413203446.SLJfIKrXM%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388526AbgDMUoU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 16:44:20 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, logang@deltatee.com, masahiroy@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: fix build error in mm/init.c
has been added to the -mm tree.  Its filename is
     sh-fix-build-error-in-mm-initc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-fix-build-error-in-mm-initc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-fix-build-error-in-mm-initc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: sh: fix build error in mm/init.c

The closing parenthesis is missing.

Link: http://lkml.kernel.org/r/20200413014743.16353-1-masahiroy@kernel.org
Fixes: bfeb022f8fe4 ("mm/memory_hotplug: add pgprot_t to mhp_params")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/mm/init.c~sh-fix-build-error-in-mm-initc
+++ a/arch/sh/mm/init.c
@@ -412,7 +412,7 @@ int arch_add_memory(int nid, u64 start,
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	if (WARN_ON_ONCE(params->pgprot.pgprot != PAGE_KERNEL.pgprot)
+	if (WARN_ON_ONCE(params->pgprot.pgprot != PAGE_KERNEL.pgprot))
 		return -EINVAL;
 
 	/* We only have ZONE_NORMAL, so this is easy.. */
_

Patches currently in -mm which might be from masahiroy@kernel.org are

sh-fix-build-error-in-mm-initc.patch
