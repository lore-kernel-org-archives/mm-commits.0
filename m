Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB46C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJCVOp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiJCVNf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EE04D248
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:08:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F636611E3
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE8BC433C1;
        Mon,  3 Oct 2022 21:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831302;
        bh=BwwAZWfICI1hITZzUhmsbobgDF30UmEngpI4QaGOfjA=;
        h=Date:To:From:Subject:From;
        b=gppZ5HHtFsrMdhiNoM83Fr9DKiPckoM08mYF3/ksRyVPknmvRtGy+kN4Qt/WW4CRJ
         slZnICPXgSfNRNafE8CTnpPQa7QOA4r7hJyM45eXQmf7P0WoaoiCmGrdBtd+FirPTY
         EJJi0HfblFCUv1tODt6aNnAThZm2fvbdprl82Bm4=
Date:   Mon, 03 Oct 2022 14:08:21 -0700
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
Subject: [merged mm-stable] kmsan-disable-instrumentation-of-unsupported-common-kernel-code.patch removed from -mm tree
Message-Id: <20221003210822.6AE8BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: disable instrumentation of unsupported common kernel code
has been removed from the -mm tree.  Its filename was
     kmsan-disable-instrumentation-of-unsupported-common-kernel-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: disable instrumentation of unsupported common kernel code
Date: Thu, 15 Sep 2022 17:03:46 +0200

EFI stub cannot be linked with KMSAN runtime, so we disable
instrumentation for it.

Instrumenting kcov, stackdepot or lockdep leads to infinite recursion
caused by instrumentation hooks calling instrumented code again.

Link: https://lkml.kernel.org/r/20220915150417.722975-13-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
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

 drivers/firmware/efi/libstub/Makefile |    1 +
 kernel/Makefile                       |    1 +
 kernel/locking/Makefile               |    3 ++-
 lib/Makefile                          |    3 +++
 4 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/Makefile~kmsan-disable-instrumentation-of-unsupported-common-kernel-code
+++ a/drivers/firmware/efi/libstub/Makefile
@@ -46,6 +46,7 @@ GCOV_PROFILE			:= n
 # Sanitizer runtimes are unavailable and cannot be linked here.
 KASAN_SANITIZE			:= n
 KCSAN_SANITIZE			:= n
+KMSAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
 
--- a/kernel/locking/Makefile~kmsan-disable-instrumentation-of-unsupported-common-kernel-code
+++ a/kernel/locking/Makefile
@@ -5,8 +5,9 @@ KCOV_INSTRUMENT		:= n
 
 obj-y += mutex.o semaphore.o rwsem.o percpu-rwsem.o
 
-# Avoid recursion lockdep -> KCSAN -> ... -> lockdep.
+# Avoid recursion lockdep -> sanitizer -> ... -> lockdep.
 KCSAN_SANITIZE_lockdep.o := n
+KMSAN_SANITIZE_lockdep.o := n
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = $(CC_FLAGS_FTRACE)
--- a/kernel/Makefile~kmsan-disable-instrumentation-of-unsupported-common-kernel-code
+++ a/kernel/Makefile
@@ -38,6 +38,7 @@ KCOV_INSTRUMENT_kcov.o := n
 KASAN_SANITIZE_kcov.o := n
 KCSAN_SANITIZE_kcov.o := n
 UBSAN_SANITIZE_kcov.o := n
+KMSAN_SANITIZE_kcov.o := n
 CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack) -fno-stack-protector
 
 # Don't instrument error handlers
--- a/lib/Makefile~kmsan-disable-instrumentation-of-unsupported-common-kernel-code
+++ a/lib/Makefile
@@ -270,6 +270,9 @@ obj-$(CONFIG_POLYNOMIAL) += polynomial.o
 CFLAGS_stackdepot.o += -fno-builtin
 obj-$(CONFIG_STACKDEPOT) += stackdepot.o
 KASAN_SANITIZE_stackdepot.o := n
+# In particular, instrumenting stackdepot.c with KMSAN will result in infinite
+# recursion.
+KMSAN_SANITIZE_stackdepot.o := n
 KCOV_INSTRUMENT_stackdepot.o := n
 
 obj-$(CONFIG_REF_TRACKER) += ref_tracker.o
_

Patches currently in -mm which might be from glider@google.com are


