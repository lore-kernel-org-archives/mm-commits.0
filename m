From: akpm@linux-foundation.org
Subject: [merged] sh-fix-build-error-in-mm-initc.patch removed
 from -mm tree
Date: Thu, 23 Apr 2020 12:51:24 -0700
Message-ID: <20200423195124.wZkiIZIc2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbgDWTv0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 15:51:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, geert+renesas@glider.be, linux@roeck-us.net, logang@deltatee.com, masahiroy@kernel.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: fix build error in mm/init.c
has been removed from the -mm tree.  Its filename was
     sh-fix-build-error-in-mm-initc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: sh: fix build error in mm/init.c

The closing parenthesis is missing.

Link: http://lkml.kernel.org/r/20200413014743.16353-1-masahiroy@kernel.org
Fixes: bfeb022f8fe4 ("mm/memory_hotplug: add pgprot_t to mhp_params")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
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
