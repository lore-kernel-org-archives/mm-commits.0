Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C124C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0371264F21
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhBZAtN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:49:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229845AbhBZAtN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:49:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B071864EDB;
        Fri, 26 Feb 2021 00:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300512;
        bh=5NbLHoVgoBRxXBfVZ9jJVdUnhVMxhqjD7ZKZbqlyeB4=;
        h=Date:From:To:Subject:From;
        b=e6EZ78MjLD78qTgxUedE5g4teoz/ZFSivPJqJT0lirRpPskaRU+XDN5kZ2iU3T3aU
         GlIz2H7zmiHLxPcAc5lD+4M2BUl+GfPSRPbFztmldQ37nXPIKhpxQbPyksu1P6VQwn
         VDrw3VUd+kDjUm1DnlyQKJ0gZyST5zQqaOsx/XXw=
Date:   Thu, 25 Feb 2021 16:48:32 -0800
From:   akpm@linux-foundation.org
To:     elver@google.com, glider@google.com, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged] kfence-add-test-suite-fix.patch removed
 from -mm tree
Message-ID: <20210226004832.TacWMfCjZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: fix typo in test
has been removed from the -mm tree.  Its filename was
     kfence-add-test-suite-fix.patch

This patch was dropped because it was folded into kfence-add-test-suite.patch

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: fix typo in test

Fix a typo/accidental copy-paste that resulted in the obviously
incorrect 'GFP_KERNEL * 2' expression.

Link: https://lkml.kernel.org/r/X9lHQExmHGvETxY4@elver.google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/kfence_test.c~kfence-add-test-suite-fix
+++ a/mm/kfence/kfence_test.c
@@ -665,7 +665,7 @@ static void test_krealloc(struct kunit *
 	for (; i < size * 3; i++) /* Fill to extra bytes. */
 		buf[i] = i + 1;
 
-	buf = krealloc(buf, size * 2, GFP_KERNEL * 2); /* Shrink. */
+	buf = krealloc(buf, size * 2, GFP_KERNEL); /* Shrink. */
 	KUNIT_EXPECT_GE(test, ksize(buf), size * 2);
 	for (i = 0; i < size * 2; i++)
 		KUNIT_EXPECT_EQ(test, buf[i], (char)(i + 1));
_

Patches currently in -mm which might be from elver@google.com are

arm64-kfence-enable-kfence-for-arm64.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
kfence-add-test-suite-fix-2.patch
maintainers-add-entry-for-kfence.patch
kfence-report-sensitive-information-based-on-no_hash_pointers.patch

