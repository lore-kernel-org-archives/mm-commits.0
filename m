Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89313C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 22:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C85B23C83
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 22:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391970AbgLKVhw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 16:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405573AbgLKVhX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 16:37:23 -0500
Date:   Fri, 11 Dec 2020 13:36:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607722603;
        bh=WxPFqfjT5vknTH7sFF4MvYKi41O+VPD2FPGbc8Z5FzU=;
        h=From:To:Subject:In-Reply-To:From;
        b=AAw5n7FaKKh07dbBFl2FG/FHfghRub+fnBDoC+HlkO9n0SwOo76h7BX5vYoF8U5pJ
         KEyIo+gzna13huXJgQ83KE06g4jfGyp9dXGpR+tr75FqHWHjCOjoLwKBFaKL7ntWkS
         8T6fRZGkx0yVsLjmwVTg9NkQAm0ivuQQWqvIwZds=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, brho@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 5/8] initramfs: fix clang build failure
Message-ID: <20201211213642.d_d5sDaBb%akpm@linux-foundation.org>
In-Reply-To: <20201211133555.88407977f082963499ed343c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
