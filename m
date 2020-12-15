Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B45C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E462320721
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgLODSL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:18:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbgLODMU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:20 -0500
Date:   Mon, 14 Dec 2020 19:09:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001765;
        bh=h6IcqHUVRxqsYEEEosg3/yVLmCImuMCpNgbygP8kzOc=;
        h=From:To:Subject:In-Reply-To:From;
        b=eyTodMmHo7WaLpq2h9SbrJh9diEDd6t5gwi2DwcHVP4MtyP/5590QjXDY9Pb3N0M2
         I3EJmxtfCl0PMeFsNTfnzVAgXhfXrbouFtjQbFlhV/0fNVAnSnIqKgYMUrN7bsKyD+
         1YxDOpgEV2L9cfcpS3BPhoyBPhWLzZDVcW0mj6tE=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, arnd@arndb.de,
        dvyukov@google.com, elver@google.com, gregkh@linuxfoundation.org,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 105/200] lkdtm: disable KASAN for rodata.o
Message-ID: <20201215030924._Zr2uvTm3%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
