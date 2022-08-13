Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC59C19F2D
	for <mm-commits@archiver.kernel.org>; Sat, 13 Aug 2022 23:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiHMXxY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Aug 2022 19:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiHMXxW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 13 Aug 2022 19:53:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69998B9AE
        for <mm-commits@vger.kernel.org>; Sat, 13 Aug 2022 16:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53703B80ADA
        for <mm-commits@vger.kernel.org>; Sat, 13 Aug 2022 23:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E00C433D6;
        Sat, 13 Aug 2022 23:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660434798;
        bh=0HvdwuRHSDBBDGx6mpm8ss6QnVjuq50HJjNw4jhvGto=;
        h=Date:To:From:Subject:From;
        b=JuoYoAgKVqxU6KV3IrQfihhpFm+Yq4CkN6FMEdfo7q4Bx6bctjTCLQGv9LjFWnTKI
         p4WOrf9nwiX5g4alr0raW6+Am784yK8JdHIXiQfvj6Rnm8n40G9G3IGSgYz7Zg56xG
         XsAUCxvMdkjeza0NzC99cxxFNVixEIIZlDUDnb8U=
Date:   Sat, 13 Aug 2022 16:53:17 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, Jason@zx2c4.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        yury.norov@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-replace-gfph-inclusion-with-gfp_typesh.patch added to mm-hotfixes-unstable branch
Message-Id: <20220813235317.F2E00C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: replace gfp.h inclusion with gfp_types.h
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     radix-tree-replace-gfph-inclusion-with-gfp_typesh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-replace-gfph-inclusion-with-gfp_typesh.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

radix-tree-replace-gfph-inclusion-with-gfp_typesh.patch

