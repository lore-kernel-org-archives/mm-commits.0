Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F2DC4361B
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 22:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 207BD22507
	for <mm-commits@archiver.kernel.org>; Mon, 14 Dec 2020 22:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388476AbgLNWXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 17:23:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407337AbgLNWXH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 17:23:07 -0500
Date:   Mon, 14 Dec 2020 14:22:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607984547;
        bh=2bh2j7PxTLr9YKpVDQpJKyYu2ZcKa/MysFXjgxFyOtE=;
        h=From:To:Subject:From;
        b=tcPL/W9N3Al0myGnGwnG4mPcI0qZClC7EmRAZIZekRaNZjDOJ/k3539Vjl/8k3DzN
         nrTKfWuUzU0UuNRhsjglYhoxR/fAfr4inu0VU32FTVrYevD60LUtnUzdStjOO95yRA
         PL7tjQ85iIn5YhHLjYHGC9/LFBKKca8lxCRMx/Rk=
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, arnd@arndb.de, dvyukov@google.com,
        elver@google.com, gregkh@linuxfoundation.org,
        keescook@chromium.org, mm-commits@vger.kernel.org
Subject:  + lkdtm-disable-kasan-for-rodatao.patch added to -mm tree
Message-ID: <20201214222226.k13eGkZdc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lkdtm: disable KASAN for rodata.o
has been added to the -mm tree.  Its filename is
     lkdtm-disable-kasan-for-rodatao.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lkdtm-disable-kasan-for-rodatao.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lkdtm-disable-kasan-for-rodatao.patch

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
Subject: lkdtm: disable KASAN for rodata.o

Building lkdtm with KASAN and Clang 11 or later results in the following
error when attempting to load the module:

  kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
  BUG: unable to handle page fault for address: ffffffffc019cd70
  #PF: supervisor instruction fetch in kernel mode
  #PF: error_code(0x0011) - permissions violation
  ...
  RIP: 0010:asan.module_ctor+0x0/0xffffffffffffa290 [lkdtm]
  ...
  Call Trace:
   do_init_module+0x17c/0x570
   load_module+0xadee/0xd0b0
   __x64_sys_finit_module+0x16c/0x1a0
   do_syscall_64+0x34/0x50
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

The reason is that rodata.o generates a dummy function that lives in
.rodata to validate that .rodata can't be executed; however, Clang 11 adds
KASAN globals support by generating module constructors to initialize
globals redzones.  When Clang 11 adds a module constructor to rodata.o, it
is also added to .rodata: any attempt to call it on initialization results
in the above error.

Therefore, disable KASAN instrumentation for rodata.o.

Link: https://lkml.kernel.org/r/20201214191413.3164796-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/lkdtm/Makefile~lkdtm-disable-kasan-for-rodatao
+++ a/drivers/misc/lkdtm/Makefile
@@ -11,6 +11,7 @@ lkdtm-$(CONFIG_LKDTM)		+= usercopy.o
 lkdtm-$(CONFIG_LKDTM)		+= stackleak.o
 lkdtm-$(CONFIG_LKDTM)		+= cfi.o
 
+KASAN_SANITIZE_rodata.o		:= n
 KASAN_SANITIZE_stackleak.o	:= n
 KCOV_INSTRUMENT_rodata.o	:= n
 
_

Patches currently in -mm which might be from elver@google.com are

lkdtm-disable-kasan-for-rodatao.patch
mm-add-kernel-electric-fence-infrastructure-fix.patch
mm-add-kernel-electric-fence-infrastructure-fix-2.patch
arm64-kfence-enable-kfence-for-arm64.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
maintainers-add-entry-for-kfence.patch

