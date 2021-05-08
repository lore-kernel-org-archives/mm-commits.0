Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B81C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3159B60E0B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhEHWwq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWwp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5BA360233;
        Sat,  8 May 2021 22:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514303;
        bh=6dgpB2rpkSI6T3OTItWQMLdqmWGDQ/lQBqbI9CVekOg=;
        h=Date:From:To:Subject:From;
        b=qkM8Jqhz0HREfP8O+vap62WWVH4Vxgeo7i/GGA2KCPZx+51eClPoJwjVtkI8fGLA4
         a70v4MPMUndHRexjkO20ut7KUJjFql2Ehe2QpUUddPU5z0q1Ik5AXlr3vXfNt0uBSm
         l0IY8jjKeOynDtWJJsd1da+K2lsrrRDF1qr8xqZ8=
Date:   Sat, 08 May 2021 15:51:42 -0700
From:   akpm@linux-foundation.org
To:     ink@jurassic.park.msu.ru, lkp@intel.com, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org, rth@twiddle.net,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 alpha-csum_partial_copyc-add-function-prototypes-from-net-checksumh.patch
 removed from -mm tree
Message-ID: <20210508225142.iISZsqtYZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: csum_partial_copy.c: add function prototypes from <net/checksum.h>
has been removed from the -mm tree.  Its filename was
     alpha-csum_partial_copyc-add-function-prototypes-from-net-checksumh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: alpha: csum_partial_copy.c: add function prototypes from <net/checksum.h>

Fix "no previous prototype" W=1 warnings from the kernel test robot:

../arch/alpha/lib/csum_partial_copy.c:349:1: error: no previous prototype for 'csum_and_copy_from_user' [-Werror=missing-prototypes]
  349 | csum_and_copy_from_user(const void __user *src, void *dst, int len)
      | ^~~~~~~~~~~~~~~~~~~~~~~
../arch/alpha/lib/csum_partial_copy.c:358:1: error: no previous prototype for 'csum_partial_copy_nocheck' [-Werror=missing-prototypes]
  358 | csum_partial_copy_nocheck(const void *src, void *dst, int len)
      | ^~~~~~~~~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20210425235749.19113-1-rdunlap@infradead.org
Fixes: 808b49da54e6 ("alpha: turn csum_partial_copy_from_user() into csum_and_copy_from_user()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/csum_partial_copy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/alpha/lib/csum_partial_copy.c~alpha-csum_partial_copyc-add-function-prototypes-from-net-checksumh
+++ a/arch/alpha/lib/csum_partial_copy.c
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <net/checksum.h>
 
 
 #define ldq_u(x,y) \
_

Patches currently in -mm which might be from rdunlap@infradead.org are


