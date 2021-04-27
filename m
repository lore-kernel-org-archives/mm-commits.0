Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F387EC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 27 Apr 2021 00:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB4226113D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Apr 2021 00:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhD0ABf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Apr 2021 20:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhD0ABe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 26 Apr 2021 20:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1408F61040;
        Tue, 27 Apr 2021 00:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619481652;
        bh=nexsys/ulU8gVnhHvT6V4y+K8ELQWv9E9CcyGMxZOLE=;
        h=Date:From:To:Subject:From;
        b=Kg/iLui98l+mmCmVdHyYLAWyKIjxOPBhgugKm+We9Yvc2C4jrLa7kqi3O/p3jpkrJ
         041i2qDQosW+YAYkCucz3dCuYRPY4kXZEuAHZmeUL05CY+jkSB8sAIMfAvWztMZPrR
         IIv+US4+CycRVbuLrSg10PMUqK0n2OVf1fhyZlsI=
Date:   Mon, 26 Apr 2021 17:00:51 -0700
From:   akpm@linux-foundation.org
To:     ink@jurassic.park.msu.ru, lkp@intel.com, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org, rth@twiddle.net,
        viro@zeniv.linux.org.uk
Subject:  +
 alpha-csum_partial_copyc-add-function-prototypes-from-net-checksumh.patch
 added to -mm tree
Message-ID: <20210427000051.gZAUmar2a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: csum_partial_copy.c: add function prototypes from <net/checksum.h>
has been added to the -mm tree.  Its filename is
     alpha-csum_partial_copyc-add-function-prototypes-from-net-checksumh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/alpha-csum_partial_copyc-add-function-prototypes-from-net-checksumh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/alpha-csum_partial_copyc-add-function-prototypes-from-net-checksumh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

vfs-fs_parser-clean-up-kernel-doc-warnings.patch
alpha-eliminate-old-style-function-definitions.patch
alpha-csum_partial_copyc-add-function-prototypes-from-net-checksumh.patch
lib-parser-clean-up-kernel-doc.patch

