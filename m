Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B1FC48BE5
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B259E606A5
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhFJWSd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 18:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhFJWSd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 18:18:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1DA661425;
        Thu, 10 Jun 2021 22:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363380;
        bh=K16eAEL/T73PpEiKGBW5mQUr50nnJC0ywalvZl08JOI=;
        h=Date:From:To:Subject:From;
        b=eoXnilBIpHMrLEJcSNKzcPzIV/AFLPeWUzN2JTJGp4peoLkOyZ5JAmi6iAHryVh6a
         wfJzCQSyfmtf5eckFqFJd7fXOWChuHGBMX45Zidnjcjc0DG/E9HGpFlShe1mNLCqtD
         3/hs8d/yDoVuMklpH0IIaV9aGXcGOYMlSuhwqpb0=
Date:   Thu, 10 Jun 2021 15:16:20 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, colin.king@canonical.com, jgg@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com
Subject:  [to-be-updated]
 mm-selftests-for-exclusive-device-memory-fix.patch removed from -mm tree
Message-ID: <20210610221620.DlOz3Kc8w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: selftests: fix potential integer overflow on shift of a int
has been removed from the -mm tree.  Its filename was
     mm-selftests-for-exclusive-device-memory-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm: selftests: fix potential integer overflow on shift of a int

The left shift of the int mapped is evaluated using 32 bit arithmetic and
then assigned to an unsigned long.  In the case where mapped is 0x80000
when PAGE_SHIFT is 12 will lead to the upper bits being sign extended in
the unsigned long.  Larger values can lead to an int overflow.  Avoid this
by making mapped an unsigned long.

Addresses-Coverity: ("Uninitentional integer overflow")
Link: https://lkml.kernel.org/r/20210526170530.3766167-1-colin.king@canonical.com
Fixes: 8b2a105c3794 ("mm: selftests for exclusive device memory")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/test_hmm.c~mm-selftests-for-exclusive-device-memory-fix
+++ a/lib/test_hmm.c
@@ -733,7 +733,8 @@ static int dmirror_exclusive(struct dmir
 
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
-		int i, mapped;
+		unsigned long mapped;
+		int i;
 
 		if (end < addr + (ARRAY_SIZE(pages) << PAGE_SHIFT))
 			next = end;
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
ocfs2-remove-redundant-assignment-to-pointer-queue.patch
lib-math-rational-add-kunit-test-cases-fix-2.patch

