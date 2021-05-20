Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8159AC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 21:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536C3613AA
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 21:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhETViz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 17:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230255AbhETViy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 17:38:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5D4E6135A;
        Thu, 20 May 2021 21:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621546652;
        bh=2bcjjftStXArIMpF1JhVHGzUc/XE8b2msDYYghIP/Lk=;
        h=Date:From:To:Subject:From;
        b=tMj9Yu3XuzZihT7p7qQu4d5amDhvYs+91EMACA3XqNSsPtfFtTHUB7gBJkzDAHTxf
         hrtDLA0qOpN4UUtf7fD4Zz2h774gv/S8WKFXYTuLIufL2RO72vk8z75zs5aSEsyjuH
         eb+uZt2IRs4Yewi91cK78b7gE303pB77sr4BaX7k=
Date:   Thu, 20 May 2021 14:37:32 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, glaubitz@physik.fu-berlin.de,
        lkp@intel.com, mm-commits@vger.kernel.org
Subject:  + kernelh-split-out-panic-and-oops-helpers-fix-2.patch
 added to -mm tree
Message-ID: <20210520213732.-EJTDki5k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: split out panic and oops helpers (ia64 fix)
has been added to the -mm tree.  Its filename is
     kernelh-split-out-panic-and-oops-helpers-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernelh-split-out-panic-and-oops-helpers-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernelh-split-out-panic-and-oops-helpers-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: split out panic and oops helpers (ia64 fix)

Follow up fix for the "kernel.h: split out panic and oops helpers" patch.

Link: https://lkml.kernel.org/r/20210520130557.55277-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/pal.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/ia64/include/asm/pal.h~kernelh-split-out-panic-and-oops-helpers-fix-2
+++ a/arch/ia64/include/asm/pal.h
@@ -99,6 +99,7 @@
 
 #include <linux/types.h>
 #include <asm/fpu.h>
+#include <asm/intrinsics.h>
 
 /*
  * Data types needed to pass information into PAL procedures and
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-panic-and-oops-helpers.patch
kernelh-split-out-panic-and-oops-helpers-fix-2.patch
lib-string_helpers-switch-to-use-bit-macro.patch
lib-string_helpers-move-escape_np-check-inside-else-branch-in-a-loop.patch
lib-string_helpers-drop-indentation-level-in-string_escape_mem.patch
lib-string_helpers-introduce-escape_na-for-escaping-non-ascii.patch
lib-string_helpers-introduce-escape_nap-to-escape-non-ascii-and-non-printable.patch
lib-string_helpers-allow-to-append-additional-characters-to-be-escaped.patch
lib-test-string_helpers-print-flags-in-hexadecimal-format.patch
lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch
lib-test-string_helpers-add-test-cases-for-new-features.patch
maintainers-add-myself-as-designated-reviewer-for-generic-string-library.patch
seq_file-introduce-seq_escape_mem.patch
seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch
seq_file-convert-seq_escape-to-use-seq_escape_str.patch
nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch
seq_file-drop-unused-_escape_mem_ascii.patch

