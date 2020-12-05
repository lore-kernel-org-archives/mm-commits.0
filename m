Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D7DC4361A
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 00:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B2ED22D6E
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 00:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgLEAgU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Dec 2020 19:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgLEAgU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Dec 2020 19:36:20 -0500
Date:   Fri, 04 Dec 2020 16:35:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607128540;
        bh=vebketH8C36WVfFZQeQWwtKL0ivWMZ+gRl+6EDk2pps=;
        h=From:To:Subject:From;
        b=Wo+byRidSihiocrIWV6I0FvwH8B84gbV9aPIpAwBg8yob15QUymIcKhqzib5NYC3r
         I5eLfQY36h7wqytKhm04L/LFIc5nK4MkVSazLD7vmAZWgoZ5VxGU70V+BpFCGDaXVf
         9aL1pVtsvK4xyw+rfvPgIitkn5iVS9ZvOpPr6nGU=
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, brho@google.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com
Subject:  + initramfs-fix-clang-build-failure.patch added to -mm
 tree
Message-ID: <20201205003539.xRLUku27T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: fix clang build failure
has been added to the -mm tree.  Its filename is
     initramfs-fix-clang-build-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/initramfs-fix-clang-build-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/initramfs-fix-clang-build-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: initramfs: fix clang build failure

There is only one function in init/initramfs.c that is in the .text
section, and it is marked __weak.  When building with clang-12 and the
integrated assembler, this leads to a bug with recordmcount:

./scripts/recordmcount  "init/initramfs.o"
Cannot find symbol for section 2: .text.
init/initramfs.o: failed

I'm not quite sure what exactly goes wrong, but I notice that this
function is only ever called from an __init function, and normally
inlined.  Marking it __init as well is clearly correct and it leads to
recordmcount no longer complaining.

Link: https://lkml.kernel.org/r/20201204165742.3815221-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Barret Rhoden <brho@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/initramfs.c~initramfs-fix-clang-build-failure
+++ a/init/initramfs.c
@@ -535,7 +535,7 @@ extern unsigned long __initramfs_size;
 #include <linux/initrd.h>
 #include <linux/kexec.h>
 
-void __weak free_initrd_mem(unsigned long start, unsigned long end)
+void __weak __init free_initrd_mem(unsigned long start, unsigned long end)
 {
 #ifdef CONFIG_ARCH_KEEP_MEMBLOCK
 	unsigned long aligned_start = ALIGN_DOWN(start, PAGE_SIZE);
_

Patches currently in -mm which might be from arnd@arndb.de are

selftest-fpu-avoid-clang-warning.patch
kbuild-avoid-static_assert-for-genksyms.patch
initramfs-fix-clang-build-failure.patch
elfcore-fix-building-with-clang.patch

