Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39543C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbiHQPyW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237775AbiHQPyV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:54:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F281C883C8
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:54:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4FCCB81E1C
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640A5C433D6;
        Wed, 17 Aug 2022 15:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660751657;
        bh=yBDuQH1RDFomNll6/Y3MdVYwKKmR8ulmjaqZ2jow+kw=;
        h=Date:To:From:Subject:From;
        b=Osy1gcxnrWaoaM1uF1wwTnenQVatLJ+lA57sDZnX8R5KIr9mbqMxf9y7+RUptjX6j
         BHxnvXP1WVWzA9S5yoCYSrURqNYCe8mNs6cP4Jaxq3qq6iz05EqNZGlTFHXJIeoVOd
         T75Q/Ffr0eEBpegOU971Y5y6BpoPYFWxUh0KOmAw=
Date:   Wed, 17 Aug 2022 08:54:16 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, isabbasso@riseup.net,
        dan.j.williams@intel.com, akinobu.mita@gmail.com,
        weiyongjun1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-injection-allow-stacktrace-filter-for-x86-64.patch added to mm-nonmm-unstable branch
Message-Id: <20220817155417.640A5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fault-injection: allow stacktrace filter for x86-64
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-injection-allow-stacktrace-filter-for-x86-64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-injection-allow-stacktrace-filter-for-x86-64.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: fault-injection: allow stacktrace filter for x86-64
Date: Wed, 17 Aug 2022 08:03:29 +0000

This patchset allow fault injection to run on x86_64 and makes stacktrace
filter work as expected.  With this, we can test a device driver module
with fault injection more easily.


This patch (of 4):

FAULT_INJECTION_STACKTRACE_FILTER option was apparently disallowed on
x86_64 because of problems with the stack unwinder:

    commit 6d690dcac92a84f98fd774862628ff871b713660
    Author: Akinobu Mita <akinobu.mita@gmail.com>
    Date:   Sat May 12 10:36:53 2007 -0700

        fault injection: disable stacktrace filter for x86-64

However, there is no problems whatsoever with this today. Let's allow
it again.

Link: https://lkml.kernel.org/r/20220817080332.1052710-1-weiyongjun1@huawei.com
Link: https://lkml.kernel.org/r/20220817080332.1052710-2-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Isabella Basso <isabbasso@riseup.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/Kconfig.debug~fault-injection-allow-stacktrace-filter-for-x86-64
+++ a/lib/Kconfig.debug
@@ -1944,7 +1944,6 @@ config FAIL_SUNRPC
 config FAULT_INJECTION_STACKTRACE_FILTER
 	bool "stacktrace filter for fault-injection capabilities"
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
-	depends on !X86_64
 	select STACKTRACE
 	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	help
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are

fault-injection-allow-stacktrace-filter-for-x86-64.patch
fault-injection-skip-stacktrace-filtering-by-default.patch
fault-injection-make-some-stack-filter-attrs-more-readable.patch
fault-injection-make-stacktrace-filter-works-as-expected.patch

