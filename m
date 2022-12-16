Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7681FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 00:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiLPAlP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 19:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiLPAlP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 19:41:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F47C32BA9
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 16:41:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18DEC61FC6
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 00:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E5EC433EF;
        Fri, 16 Dec 2022 00:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671151273;
        bh=9FL82KnjjyMKkvHGnuT4P7Meto1DPM0btU26U/X9CjE=;
        h=Date:To:From:Subject:From;
        b=Vca4J0HJEdrevjFFqo92DZgVLvZRL7lXHwMFS82CjB6MMYyJrk0ILCsRXhXw48M43
         TEweidZClKwQ1xE2obFXjXGQDmlZszorfZ9Jlebw+6IA1lvArd19fW2lbGGTrqRUng
         3VgCYikkWnd0G/nlhmlPWM1pI0fbxyRQW6IwP0QY=
Date:   Thu, 15 Dec 2022 16:41:12 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, isabbasso@riseup.net,
        dan.j.williams@intel.com, akinobu.mita@gmail.com,
        weiyongjun1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fault-injection-allow-stacktrace-filter-for-x86-64.patch removed from -mm tree
Message-Id: <20221216004113.69E5EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fault-injection: allow stacktrace filter for x86-64
has been removed from the -mm tree.  Its filename was
     fault-injection-allow-stacktrace-filter-for-x86-64.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1982,7 +1982,6 @@ config FAIL_SUNRPC
 config FAULT_INJECTION_STACKTRACE_FILTER
 	bool "stacktrace filter for fault-injection capabilities"
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
-	depends on !X86_64
 	select STACKTRACE
 	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	help
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are


