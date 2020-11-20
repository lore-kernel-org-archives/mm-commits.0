Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9CBC2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 21:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C83422240C
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 21:44:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2i15DWus"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgKTVnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 16:43:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgKTVnt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 16:43:49 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1345C22403;
        Fri, 20 Nov 2020 21:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605908628;
        bh=8T20zZnh56ZaoSgIJtsMF4fjtSHScFdCau37bsyzaSs=;
        h=Date:From:To:Subject:From;
        b=2i15DWuszt48+BsXY0/KqLIty8M20kSIXDl+1M/YwVKIPGSQ/MRON0Dg9UIw0/Cb5
         CkghcXfRBnjyiW1Xq+SO0HQBZ5Q0DM1bJhwRixesEe/Zb+Eo7gY5Pdt7AgFlfOiKYU
         cvvn90qldS+TKNpFFgEkjaDV8zuXyWccTEWdPJJs=
Date:   Fri, 20 Nov 2020 13:43:47 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  +
 ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch added to
 -mm tree
Message-ID: <20201120214347.L7n7tgNTW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes

WARNING: space prohibited between function name and open parenthesis '('
#39: FILE: include/linux/log2.h:160:
+	 63 - __builtin_clzll (n)) :	\

total: 0 errors, 1 warnings, 9 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ilog2-improve-ilog2-for-constant-arguments.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/log2.h~ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes
+++ a/include/linux/log2.h
@@ -157,7 +157,7 @@ unsigned long __rounddown_pow_of_two(uns
 ( \
 	__builtin_constant_p(n) ?	\
 	((n) < 2 ? 0 :			\
-	 63 - __builtin_clzll (n)) :	\
+	 63 - __builtin_clzll(n)) :	\
 	(sizeof(n) <= 4) ?		\
 	__ilog2_u32(n) :		\
 	__ilog2_u64(n)			\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

