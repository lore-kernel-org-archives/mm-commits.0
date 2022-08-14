Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642F6C25B06
	for <mm-commits@archiver.kernel.org>; Sun, 14 Aug 2022 23:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiHNXgr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 19:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiHNXgr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 19:36:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C0E63E4
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 16:36:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7ABA60F22
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 23:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AAEC433D6;
        Sun, 14 Aug 2022 23:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660520205;
        bh=7yC0e/usFsAr1vbkoRL7tGjMVYc3SEhsQB7yOL8Ei94=;
        h=Date:To:From:Subject:From;
        b=JrSaN0d4jWvrpODw/wTDMvMGO6uyJpryEzcnU1kawf9no2htASu9ngk02tALeVR8V
         t3hvA1yefVEm8Nued6zfyySuK/SDhWn7XT80/N/j3bodL1jhC+tDuDOLeXXGGX1wt4
         crZuPOkrfjCda/Sqi6epsTMe+Pr9Aub8yyxrjQMQ=
Date:   Sun, 14 Aug 2022 16:36:44 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, Jason@zx2c4.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        yury.norov@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] radix-tree-replace-gfph-inclusion-with-gfp_typesh.patch removed from -mm tree
Message-Id: <20220814233645.31AAEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: radix-tree: replace gfp.h inclusion with gfp_types.h
has been removed from the -mm tree.  Its filename was
     radix-tree-replace-gfph-inclusion-with-gfp_typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: radix-tree: replace gfp.h inclusion with gfp_types.h
Date: Thu, 11 Aug 2022 22:34:25 -0700

Radix tree header includes gfp.h for __GFP_BITS_SHIFT only. Now we
have gfp_types.h for this.

Fixes powerpc allmodconfig build:
   In file included from include/linux/nodemask.h:97,
                    from include/linux/mmzone.h:17,
                    from include/linux/gfp.h:7,
                    from include/linux/radix-tree.h:12,
                    from include/linux/idr.h:15,
                    from include/linux/kernfs.h:12,
                    from include/linux/sysfs.h:16,
                    from include/linux/kobject.h:20,
                    from include/linux/pci.h:35,
                    from arch/powerpc/kernel/prom_init.c:24:
   include/linux/random.h: In function 'add_latent_entropy':
>> include/linux/random.h:25:46: error: 'latent_entropy' undeclared (first use in this function); did you mean 'add_latent_entropy'?
      25 |         add_device_randomness((const void *)&latent_entropy, sizeof(latent_entropy));
         |                                              ^~~~~~~~~~~~~~
         |                                              add_latent_entropy
   include/linux/random.h:25:46: note: each undeclared identifier is reported only once for each function it appears in

Link: https://lkml.kernel.org/r/20220812053425.2499799-1-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/radix-tree.h~radix-tree-replace-gfph-inclusion-with-gfp_typesh
+++ a/include/linux/radix-tree.h
@@ -9,7 +9,7 @@
 #define _LINUX_RADIX_TREE_H
 
 #include <linux/bitops.h>
-#include <linux/gfp.h>
+#include <linux/gfp_types.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/math.h>
_

Patches currently in -mm which might be from yury.norov@gmail.com are


