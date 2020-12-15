Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8ACC2D0E4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D3CB22CB2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgLOX7P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727562AbgLOXWx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:53 -0500
Date:   Tue, 15 Dec 2020 15:20:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074433;
        bh=udoM7xzuHvsR68XBPLe3It9bGX0akoqUsmzy+o0t3vE=;
        h=From:To:Subject:From;
        b=FhakVpOK37kKhXa3GjOcIr8TjDtAbZ9VXhNsAazYJ3usqMw/eyA0w6ryqj/FXjU3v
         zGzWG9ywAIWMVXTDYN2OPoFxZI+rjMdx81sEklVpFPozKJVcndo1ZwIA7/TK7I7GlH
         nwHtKH7nJbi52NuqLWsYqKulfNGyiYsbVKMX4zXg=
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, arnd@arndb.de, dvyukov@google.com,
        elver@google.com, gregkh@linuxfoundation.org,
        keescook@chromium.org, mm-commits@vger.kernel.org
Subject:  [merged] lkdtm-disable-kasan-for-rodatao.patch removed
 from -mm tree
Message-ID: <20201215232032.05bHIKTRS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lkdtm: disable KASAN for rodata.o
has been removed from the -mm tree.  Its filename was
     lkdtm-disable-kasan-for-rodatao.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-add-kernel-electric-fence-infrastructure-fix.patch
mm-add-kernel-electric-fence-infrastructure-fix-2.patch
arm64-kfence-enable-kfence-for-arm64.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
maintainers-add-entry-for-kfence.patch

