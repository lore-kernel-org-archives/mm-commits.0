Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AC6C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjDRXdb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjDRXd2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EBF76A1
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30B5962ED3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A895C433D2;
        Tue, 18 Apr 2023 23:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860806;
        bh=YRN9HC4ajeJo/hnA/3xGO0+qn3xbjGECY/E3I0AErtc=;
        h=Date:To:From:Subject:From;
        b=tti/hV4kTe7CWg8w3R1qBFy0+DCEY4WSUpqO6EtRDEU03CyNF9j/jR8GQXB+F+7HW
         al1jwtBBVf3bRK1rIycExg5nOm1Wdm1DKjSDaXyAik4hT4+o1P10ukQ8T7n1KwGLa0
         n/Wuct2RjDyqLicAX4tRL5EMfotMyQzfhteNu6cQ=
Date:   Tue, 18 Apr 2023 16:33:25 -0700
To:     mm-commits@vger.kernel.org, Vincenzo.Frascino@arm.com,
        trix@redhat.com, ryabinin.a.a@gmail.com, peterz@infradead.org,
        nicolas@fjasle.eu, ndesaulniers@google.com, nathan@kernel.org,
        mpe@ellerman.id.au, masahiroy@kernel.org, glider@google.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-remove-hwasan-kernel-mem-intrinsic-prefix=1-for-clang-14.patch removed from -mm tree
Message-Id: <20230418233326.8A895C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: remove hwasan-kernel-mem-intrinsic-prefix=1 for clang-14
has been removed from the -mm tree.  Its filename was
     kasan-remove-hwasan-kernel-mem-intrinsic-prefix=1-for-clang-14.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

ocfs2-reduce-ioctl-stack-usage.patch

