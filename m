From: akpm@linux-foundation.org
Subject: + lib-genallocc-export-devm_gen_pool_create-for-modules.patch
 added to -mm tree
Date: Tue, 02 Dec 2014 14:14:32 -0800
Message-ID: <547e39c8.TYOLhZCo0H8SvZWI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbaLBWOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2014 17:14:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.simek@xilinx.com, catalin.marinas@arm.com, lauraa@codeaurora.org, olof@lixom.net, p.zabel@pengutronix.de, prabhakar.csengg@gmail.com, vladimir_zapolskiy@mentor.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc.c: export devm_gen_pool_create() for modules
has been added to the -mm tree.  Its filename is
     lib-genallocc-export-devm_gen_pool_create-for-modules.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-genallocc-export-devm_gen_pool_create-for-modules.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-genallocc-export-devm_gen_pool_create-for-modules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Simek <michal.simek@xilinx.com>
Subject: lib/genalloc.c: export devm_gen_pool_create() for modules

Modules can use this function for creating pool.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/genalloc.c~lib-genallocc-export-devm_gen_pool_create-for-modules lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-export-devm_gen_pool_create-for-modules
+++ a/lib/genalloc.c
@@ -598,6 +598,7 @@ struct gen_pool *devm_gen_pool_create(st
 
 	return pool;
 }
+EXPORT_SYMBOL(devm_gen_pool_create);
 
 /**
  * dev_get_gen_pool - Obtain the gen_pool (if any) for a device
_

Patches currently in -mm which might be from michal.simek@xilinx.com are

lib-genallocc-export-devm_gen_pool_create-for-modules.patch
linux-next.patch

