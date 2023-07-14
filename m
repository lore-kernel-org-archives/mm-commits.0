Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF07EC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jul 2023 18:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbjGNSBb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jul 2023 14:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbjGNSB3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2023 14:01:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A281FEE;
        Fri, 14 Jul 2023 11:01:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E413E61DA6;
        Fri, 14 Jul 2023 18:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FA5C433C7;
        Fri, 14 Jul 2023 18:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689357640;
        bh=mdcv/FM4N68eE3+TesEzVD0Rb6YhlzvBEV+7V26Lcb4=;
        h=Date:To:From:Subject:From;
        b=2VCXVKV94UdhMhBwH2KcUk5dDo3KlHtFC/8t/DwHdh7o7kXMnJsggaeCPTD7XAqmC
         EuMMawvVV5K6/E8HlacB2EF1+uWUlssQbuhwUVpdsVo3R1z0WrXgQkeMWJCBkeh/JQ
         N4SxIVJqJWtUaRABf2DhYHlV1OPfejXDk9rhl/0I=
Date:   Fri, 14 Jul 2023 11:00:39 -0700
To:     mm-commits@vger.kernel.org, xkernel.wang@foxmail.com,
        stable@vger.kernel.org, glider@google.com, ajd@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_meminit-allocate-pages-up-to-order-max_order.patch added to mm-unstable branch
Message-Id: <20230714180040.36FA5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_meminit: allocate pages up to order MAX_ORDER
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_meminit-allocate-pages-up-to-order-max_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_meminit-allocate-pages-up-to-order-max_order.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Donnellan <ajd@linux.ibm.com>
Subject: lib/test_meminit: allocate pages up to order MAX_ORDER
Date: Fri, 14 Jul 2023 11:52:38 +1000

test_pages() tests the page allocator by calling alloc_pages() with
different orders up to order 10.

However, different architectures and platforms support different maximum
contiguous allocation sizes.  The default maximum allocation order
(MAX_ORDER) is 10, but architectures can use CONFIG_ARCH_FORCE_MAX_ORDER
to override this.  On platforms where this is less than 10, test_meminit()
will blow up with a WARN().  This is expected, so let's not do that.

Replace the hardcoded "10" with the MAX_ORDER macro so that we test
allocations up to the expected platform limit.

Link: https://lkml.kernel.org/r/20230714015238.47931-1-ajd@linux.ibm.com
Fixes: 5015a300a522 ("lib: introduce test_meminit module")
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Xiaoke Wang <xkernel.wang@foxmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_meminit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_meminit.c~lib-test_meminit-allocate-pages-up-to-order-max_order
+++ a/lib/test_meminit.c
@@ -93,7 +93,7 @@ static int __init test_pages(int *total_
 	int failures = 0, num_tests = 0;
 	int i;
 
-	for (i = 0; i < 10; i++)
+	for (i = 0; i <= MAX_ORDER; i++)
 		num_tests += do_alloc_pages_order(i, &failures);
 
 	REPORT_FAILURES_IN_FN();
_

Patches currently in -mm which might be from ajd@linux.ibm.com are

lib-test_meminit-allocate-pages-up-to-order-max_order.patch

