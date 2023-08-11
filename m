Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CD6C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbjHKXEM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236882AbjHKXDH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0503F35B1;
        Fri, 11 Aug 2023 16:01:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A800F634A6;
        Fri, 11 Aug 2023 23:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FC1C433C7;
        Fri, 11 Aug 2023 23:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794875;
        bh=yP+OIzP3vIQ7YbcyQlWr3/Nims+782IpswnvOG9I+EU=;
        h=Date:To:From:Subject:From;
        b=QC5It2UtlSRRRqevMpv5flKrUt9EIyYj+KNA6d0hu1ueMcfQxV/utzdTrsVHHXvdJ
         ARtaLNJr6HFIawzfkcGjHCy0AZKDYrCv8YL7+a/m8G9DIgPLHsqdPkvhpEL4QmiiMi
         1YBXLjQr3gfF9/Qb0jzlCtddTenNVagTGiWFvFzI=
Date:   Fri, 11 Aug 2023 16:01:14 -0700
To:     mm-commits@vger.kernel.org, xkernel.wang@foxmail.com,
        stable@vger.kernel.org, glider@google.com, ajd@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_meminit-allocate-pages-up-to-order-max_order.patch removed from -mm tree
Message-Id: <20230811230115.06FC1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/test_meminit: allocate pages up to order MAX_ORDER
has been removed from the -mm tree.  Its filename was
     lib-test_meminit-allocate-pages-up-to-order-max_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


