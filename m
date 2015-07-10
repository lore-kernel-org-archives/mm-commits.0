From: akpm@linux-foundation.org
Subject: +
 genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2.patch
 added to -mm tree
Date: Fri, 10 Jul 2015 14:27:02 -0700
Message-ID: <55a038a6.j6TEd6yyjJRWCiNq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbbGJV1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 17:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir_zapolskiy@mentor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2
has been added to the -mm tree.  Its filename is
     genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2

* Added the same change in gen_pool_get() argument list
  to account a recently added client in arm/mach-socfpga/pm.c

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-socfpga/pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-socfpga/pm.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2 arch/arm/mach-socfpga/pm.c
--- a/arch/arm/mach-socfpga/pm.c~genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2
+++ a/arch/arm/mach-socfpga/pm.c
@@ -56,7 +56,7 @@ static int socfpga_setup_ocram_self_refr
 		goto put_node;
 	}
 
-	ocram_pool = gen_pool_get(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev, NULL);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
_

Patches currently in -mm which might be from vladimir_zapolskiy@mentor.com are

genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-v2.patch
genalloc-add-support-of-multiple-gen_pools-per-device.patch

