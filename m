Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BB1C636CC
	for <mm-commits@archiver.kernel.org>; Wed, 15 Feb 2023 20:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjBOUXV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Feb 2023 15:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjBOUXN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2023 15:23:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BC23E09C
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 12:23:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B03861D40
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 20:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670ADC4339B;
        Wed, 15 Feb 2023 20:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676492589;
        bh=6qpafuCUOGD9mvgYnQB7ex7FT8gZpGm0ic575SecKjA=;
        h=Date:To:From:Subject:From;
        b=fDmS0AO+ojLtJqwVT8xY8f7+sKntZD/f0lIvIeOJYHFNIQmFaTI2jbchKQUbTiiBz
         WAf/Y/JJK21Qp27QYR0+7UT5nHAsCccBeWkfDAgPxm7F9ACDd3ns7WhtKUM2BZoZ3E
         LcM+SmHsN9hQCYTPEx2FIuhe1UARCsECOHTxJt10=
Date:   Wed, 15 Feb 2023 12:23:08 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, peterz@infradead.org,
        Kuan-Ying.Lee@mediatek.com, jpoimboe@kernel.org, glider@google.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + objtool-add-uaccess-exceptions-for-__tsan_volatile_read-write.patch added to mm-unstable branch
Message-Id: <20230215202309.670ADC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: objtool: add UACCESS exceptions for __tsan_volatile_read/write
has been added to the -mm mm-unstable branch.  Its filename is
     objtool-add-uaccess-exceptions-for-__tsan_volatile_read-write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/objtool-add-uaccess-exceptions-for-__tsan_volatile_read-write.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: objtool: add UACCESS exceptions for __tsan_volatile_read/write
Date: Wed, 15 Feb 2023 14:00:58 +0100

A lot of the tsan helpers are already excempt from the UACCESS warnings,
but some more functions were added that need the same thing:

kernel/kcsan/core.o: warning: objtool: __tsan_volatile_read16+0x0: call to __tsan_unaligned_read16() with UACCESS enabled
kernel/kcsan/core.o: warning: objtool: __tsan_volatile_write16+0x0: call to __tsan_unaligned_write16() with UACCESS enabled
vmlinux.o: warning: objtool: __tsan_unaligned_volatile_read16+0x4: call to __tsan_unaligned_read16() with UACCESS enabled
vmlinux.o: warning: objtool: __tsan_unaligned_volatile_write16+0x4: call to __tsan_unaligned_write16() with UACCESS enabled

As Marco points out, these functions don't even call each other
explicitly but instead gcc (but not clang) notices the functions
being identical and turns one symbol into a direct branch to the
other.

Link: https://lkml.kernel.org/r/20230215130058.3836177-4-arnd@kernel.org
Fixes: 75d75b7a4d54 ("kcsan: Support distinguishing volatile accesses")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/objtool/check.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/objtool/check.c~objtool-add-uaccess-exceptions-for-__tsan_volatile_read-write
+++ a/tools/objtool/check.c
@@ -1186,6 +1186,8 @@ static const char *uaccess_safe_builtin[
 	"__tsan_atomic64_compare_exchange_val",
 	"__tsan_atomic_thread_fence",
 	"__tsan_atomic_signal_fence",
+	"__tsan_unaligned_read16",
+	"__tsan_unaligned_write16",
 	/* KCOV */
 	"write_comp_data",
 	"check_kcov_mode",
_

Patches currently in -mm which might be from arnd@arndb.de are

maple_tree-reduce-stack-usage-with-gcc-9-and-earlier.patch
kasan-mark-addr_has_metadata-__always_inline.patch
kmsan-disable-ftrace-in-kmsan-core-code.patch
objtool-add-uaccess-exceptions-for-__tsan_volatile_read-write.patch

