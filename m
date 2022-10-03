Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A95C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJCVPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiJCVNx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BB0543FC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01A02B81614
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95990C433D6;
        Mon,  3 Oct 2022 21:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831344;
        bh=ioOxvd6iX7/3AOWTTPcGYynS2uNgVTfLCWeewhQytQI=;
        h=Date:To:From:Subject:From;
        b=j3T1UAbMq3pNuCaXqiJ+sM6e2cBh+LpZaxLnAnvFsresiRK/7eDQbtqgKXa+u8QLP
         xkVXXCSxOdumyscr5PbXVvGinZCtYUNSQD9+378L9BAt7o11/vLZ0I/qaoWmwaY/Vy
         WK0yb85F2tDdUrKlsuJdtJ9Uta9SkhOsssbuwkIE=
Date:   Mon, 03 Oct 2022 14:09:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, vegard.nossum@oracle.com, vbabka@suse.cz,
        tglx@linutronix.de, sfr@canb.auug.org.au, rostedt@goodmis.org,
        rientjes@google.com, pmladek@suse.com, peterz@infradead.org,
        penberg@kernel.org, mst@redhat.com, mingo@redhat.com,
        mark.rutland@arm.com, luto@kernel.org, keescook@chromium.org,
        iii@linux.ibm.com, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, gor@linux.ibm.com, elver@google.com,
        edumazet@google.com, ebiggers@kernel.org, ebiggers@google.com,
        dvyukov@google.com, cl@linux.com, bp@alien8.de, axboe@kernel.dk,
        ast@kernel.org, arnd@arndb.de, andreyknvl@google.com,
        andreyknvl@gmail.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-kasan-kmsan-support-config_generic_csum-on-x86-enable-it-for-kasan-kmsan.patch removed from -mm tree
Message-Id: <20221003210904.95990C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86: kasan: kmsan: support CONFIG_GENERIC_CSUM on x86, enable it for KASAN/KMSAN
has been removed from the -mm tree.  Its filename was
     x86-kasan-kmsan-support-config_generic_csum-on-x86-enable-it-for-kasan-kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: x86: kasan: kmsan: support CONFIG_GENERIC_CSUM on x86, enable it for KASAN/KMSAN
Date: Thu, 15 Sep 2022 17:04:11 +0200

This is needed to allow memory tools like KASAN and KMSAN see the memory
accesses from the checksum code.  Without CONFIG_GENERIC_CSUM the tools
can't see memory accesses originating from handwritten assembly code.

For KASAN it's a question of detecting more bugs, for KMSAN using the C
implementation also helps avoid false positives originating from seemingly
uninitialized checksum values.

Link: https://lkml.kernel.org/r/20220915150417.722975-38-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                |    4 ++++
 arch/x86/include/asm/checksum.h |   16 ++++++++++------
 arch/x86/lib/Makefile           |    2 ++
 3 files changed, 16 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/checksum.h~x86-kasan-kmsan-support-config_generic_csum-on-x86-enable-it-for-kasan-kmsan
+++ a/arch/x86/include/asm/checksum.h
@@ -1,9 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#define  _HAVE_ARCH_COPY_AND_CSUM_FROM_USER 1
-#define HAVE_CSUM_COPY_USER
-#define _HAVE_ARCH_CSUM_AND_COPY
-#ifdef CONFIG_X86_32
-# include <asm/checksum_32.h>
+#ifdef CONFIG_GENERIC_CSUM
+# include <asm-generic/checksum.h>
 #else
-# include <asm/checksum_64.h>
+# define  _HAVE_ARCH_COPY_AND_CSUM_FROM_USER 1
+# define HAVE_CSUM_COPY_USER
+# define _HAVE_ARCH_CSUM_AND_COPY
+# ifdef CONFIG_X86_32
+#  include <asm/checksum_32.h>
+# else
+#  include <asm/checksum_64.h>
+# endif
 #endif
--- a/arch/x86/Kconfig~x86-kasan-kmsan-support-config_generic_csum-on-x86-enable-it-for-kasan-kmsan
+++ a/arch/x86/Kconfig
@@ -325,6 +325,10 @@ config GENERIC_ISA_DMA
 	def_bool y
 	depends on ISA_DMA_API
 
+config GENERIC_CSUM
+	bool
+	default y if KMSAN || KASAN
+
 config GENERIC_BUG
 	def_bool y
 	depends on BUG
--- a/arch/x86/lib/Makefile~x86-kasan-kmsan-support-config_generic_csum-on-x86-enable-it-for-kasan-kmsan
+++ a/arch/x86/lib/Makefile
@@ -65,7 +65,9 @@ ifneq ($(CONFIG_X86_CMPXCHG64),y)
 endif
 else
         obj-y += iomap_copy_64.o
+ifneq ($(CONFIG_GENERIC_CSUM),y)
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
+endif
         lib-y += clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o
_

Patches currently in -mm which might be from glider@google.com are


