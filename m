Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E31C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 22:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiK1WYr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 17:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiK1WYp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 17:24:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F0C10FC6
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 14:24:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3983BB80F79
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 22:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2E1C433D6;
        Mon, 28 Nov 2022 22:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669674282;
        bh=fxSplx6/5kqYBlvp4GsFTrZr99BjHhfQsdJdpTQMitM=;
        h=Date:To:From:Subject:From;
        b=MJmn10ubW4TZtHjMeBfSV+AhmAronr7Kr3TBrtb7VSYD9aeid9ZQJFmn+dAMiOl0P
         LA77VfHthikWGfr72PbXX0f84YJGl7eSkKb6xwwuf6UAPWftJ54L2jOt3lGf3tTIP0
         KoATclKeR69OlCFE7ZSuKZdtHqSbkcC/tm0B+8fQ=
Date:   Mon, 28 Nov 2022 14:24:41 -0800
To:     mm-commits@vger.kernel.org, keescook@chromium.org, Jason@zx2c4.com,
        elver@google.com, davidgow@google.com, arnd@arndb.de,
        anders.roxell@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-kcsan-kcsan_test-build-without-structleak-plugin.patch added to mm-nonmm-unstable branch
Message-Id: <20221128222441.EE2E1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: kcsan: kcsan_test: build without structleak plugin
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-kcsan-kcsan_test-build-without-structleak-plugin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-kcsan-kcsan_test-build-without-structleak-plugin.patch

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
From: Anders Roxell <anders.roxell@linaro.org>
Subject: kernel: kcsan: kcsan_test: build without structleak plugin
Date: Mon, 28 Nov 2022 11:43:58 +0100

Building kcsan_test with strucleak plugin enabled makes the stack frame
size to grow.

kernel/kcsan/kcsan_test.c:704:1: error: the frame size of 3296 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Turn off the structleak plugin checks for kcsan_test.

Link: https://lkml.kernel.org/r/20221128104358.2660634-1-anders.roxell@linaro.org
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Marco Elver <elver@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Gow <davidgow@google.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcsan/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/kcsan/Makefile~kernel-kcsan-kcsan_test-build-without-structleak-plugin
+++ a/kernel/kcsan/Makefile
@@ -17,4 +17,5 @@ KCSAN_INSTRUMENT_BARRIERS_selftest.o :=
 obj-$(CONFIG_KCSAN_SELFTEST) += selftest.o
 
 CFLAGS_kcsan_test.o := $(CFLAGS_KCSAN) -g -fno-omit-frame-pointer
+CFLAGS_kcsan_test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
 obj-$(CONFIG_KCSAN_KUNIT_TEST) += kcsan_test.o
_

Patches currently in -mm which might be from anders.roxell@linaro.org are

kernel-kcsan-kcsan_test-build-without-structleak-plugin.patch

