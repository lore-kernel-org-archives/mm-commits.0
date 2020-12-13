Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78724C1B0E3
	for <mm-commits@archiver.kernel.org>; Sun, 13 Dec 2020 06:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 483DA23138
	for <mm-commits@archiver.kernel.org>; Sun, 13 Dec 2020 06:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730779AbgLMGGE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Dec 2020 01:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgLMGF7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Dec 2020 01:05:59 -0500
Date:   Sat, 12 Dec 2020 22:05:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607839518;
        bh=rUQu2zzHuQFUGerso+x4Iexfg9aYpDgoF27f76dDdi0=;
        h=From:To:Subject:From;
        b=pufibjjMEZ9GHzBuRGZodZaJM+f1gkMDso3qkuoHUeiX/nCbp1lq71x1OYRhE5Nvu
         37IZV0OiOcypmlV4qTY0ClFtiHPkpzP49moD488+xOpzx2T/KEH1WyNOzxsWbxdCec
         i/Rq+ueJJkDs+nT+584d/conuOKvHHIq2aFmAkLE=
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, brho@google.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com
Subject:  [merged] initramfs-fix-clang-build-failure.patch removed
 from -mm tree
Message-ID: <20201213060518.yqrwiM16x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: fix clang build failure
has been removed from the -mm tree.  Its filename was
     initramfs-fix-clang-build-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


