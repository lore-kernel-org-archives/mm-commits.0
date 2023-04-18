Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB318C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 18:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjDRSzr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 14:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDRSzr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 14:55:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD08F6A4E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 11:55:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46778628A4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 18:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8D5C4339B;
        Tue, 18 Apr 2023 18:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681844144;
        bh=EIfPf8mjRhp080A0eiQ1mmjdfyjhE8c9TzYeV98r8b0=;
        h=Date:To:From:Subject:From;
        b=uZDfnpZ5xpa0Lo0ybS+jmIDQfXNI9//xrqV1NzRv3RcCMNpqs1EkKLZROKNURDz8f
         VfV4fk3YrTX2BxZn+H4P4xMVmZQCqaJ/v+G9CnWLs4k1xZ7IceavhGHzxHf2HM0qYu
         otD5ZfOllph9qHiVaIfz1HJNMhd6B0kvKa7zedzI=
Date:   Tue, 18 Apr 2023 11:55:43 -0700
To:     mm-commits@vger.kernel.org, Vincenzo.Frascino@arm.com,
        trix@redhat.com, ryabinin.a.a@gmail.com, peterz@infradead.org,
        nicolas@fjasle.eu, ndesaulniers@google.com, nathan@kernel.org,
        mpe@ellerman.id.au, masahiroy@kernel.org, glider@google.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-remove-hwasan-kernel-mem-intrinsic-prefix=1-for-clang-14.patch added to mm-unstable branch
Message-Id: <20230418185544.8A8D5C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove hwasan-kernel-mem-intrinsic-prefix=1 for clang-14
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-remove-hwasan-kernel-mem-intrinsic-prefix=1-for-clang-14.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-remove-hwasan-kernel-mem-intrinsic-prefix=1-for-clang-14.patch

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
Subject: kasan: remove hwasan-kernel-mem-intrinsic-prefix=1 for clang-14
Date: Tue, 18 Apr 2023 14:23:35 +0200

Some unknown -mllvm options (i.e.  those starting with the letter "h")
don't cause an error to be returned by clang, so the cc-option helper adds
the unknown hwasan-kernel-mem-intrinsic-prefix=1 flag to CFLAGS with
compilers that are new enough for hwasan but too old for this option.

This causes a rather unreadable build failure:

fixdep: error opening file: scripts/mod/.empty.o.d: No such file or directory
make[4]: *** [/home/arnd/arm-soc/scripts/Makefile.build:252: scripts/mod/empty.o] Error 2
fixdep: error opening file: scripts/mod/.devicetable-offsets.s.d: No such file or directory
make[4]: *** [/home/arnd/arm-soc/scripts/Makefile.build:114: scripts/mod/devicetable-offsets.s] Error 2

Add a version check to only allow this option with clang-15, gcc-13
or later versions.

Link: https://lkml.kernel.org/r/20230418122350.1646391-1-arnd@kernel.org
Fixes: 51287dcb00cc ("kasan: emit different calls for instrumentable memintrinsics")
Link: https://lore.kernel.org/all/CANpmjNMwYosrvqh4ogDO8rgn+SeDHM2b-shD21wTypm_6MMe=g@mail.gmail.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tom Rix <trix@redhat.com>
Cc: Vincenzo Frascino <Vincenzo.Frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/Makefile.kasan~kasan-remove-hwasan-kernel-mem-intrinsic-prefix=1-for-clang-14
+++ a/scripts/Makefile.kasan
@@ -69,7 +69,9 @@ CFLAGS_KASAN := -fsanitize=kernel-hwaddr
 		$(instrumentation_flags)
 
 # Instrument memcpy/memset/memmove calls by using instrumented __hwasan_mem*().
+ifeq ($(call clang-min-version, 150000)$(call gcc-min-version, 130000),y)
 CFLAGS_KASAN += $(call cc-param,hwasan-kernel-mem-intrinsic-prefix=1)
+endif
 
 endif # CONFIG_KASAN_SW_TAGS
 
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-make-arch_has_descending_max_zone_pfns-static.patch
mm-make-arch_has_descending_max_zone_pfns-static-v2.patch
kasan-remove-hwasan-kernel-mem-intrinsic-prefix=1-for-clang-14.patch

