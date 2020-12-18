Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDA5C4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 18:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA1023B08
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 18:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgLRSqv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 13:46:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgLRSqu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 13:46:50 -0500
Date:   Fri, 18 Dec 2020 10:46:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608317169;
        bh=gt6rZMgX7XJJOcXgQxnRG+BYSLrMy8lEH4GteV9T2Ws=;
        h=From:To:Subject:From;
        b=g5yAlGXDq4IreN6nwzCsIiE1hovpNRTDXr36bQYQLh2WTMgxt13TPEJkNrTUDJHFh
         Gtdopgjux+8woGyblifMhOiPSYGTcU1c5x/fyEgydzIlbu1QFJhC6sxn4TVTS8g04b
         tQyG9RTaL0UcPyhmiUkS3MDHWNPIzyqi4mjDrDKI=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, lkp@intel.com, glider@google.com,
        elver@google.com
Subject:  + kfence-add-test-suite-fix.patch added to -mm tree
Message-ID: <20201218184609.6_iMR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: fix typo in test
has been added to the -mm tree.  Its filename is
     kfence-add-test-suite-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-add-test-suite-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-add-test-suite-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-add-kernel-electric-fence-infrastructure-fix.patch
mm-add-kernel-electric-fence-infrastructure-fix-2.patch
arm64-kfence-enable-kfence-for-arm64.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
kfence-add-test-suite-fix.patch
maintainers-add-entry-for-kfence.patch

