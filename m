Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F5DC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiJCVPN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJCVNw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A155466A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:08:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A474B815E2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A377C433C1;
        Mon,  3 Oct 2022 21:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831336;
        bh=1HipRIoSgCyjDw2F9yhfWKhQMEjP+fe8VgiDDdzSu/U=;
        h=Date:To:From:Subject:From;
        b=2YqxUm4ZxFc02A9XUhPbOAK9WtfW4hj1M/7V/ZHQ9nmknGtBYaS9bivrbtk3o19Ua
         HMDDPiRRBLn4B7oq3jcySl/WE/ssYggQGZndn6LMHy4dmg8NsQ1ef7yEYZqJKoPboK
         L2dLNtr52KGrk9EbMtQ7a09c/A0XxeQDl6Qu19Ac=
Date:   Mon, 03 Oct 2022 14:08:55 -0700
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
Subject: [merged mm-stable] x86-kmsan-disable-instrumentation-of-unsupported-code.patch removed from -mm tree
Message-Id: <20221003210856.1A377C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86: kmsan: disable instrumentation of unsupported code
has been removed from the -mm tree.  Its filename was
     x86-kmsan-disable-instrumentation-of-unsupported-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: x86: kmsan: disable instrumentation of unsupported code
Date: Thu, 15 Sep 2022 17:04:06 +0200

Instrumenting some files with KMSAN will result in kernel being unable to
link, boot or crashing at runtime for various reasons (e.g.  infinite
recursion caused by instrumentation hooks calling instrumented code
again).

Completely omit KMSAN instrumentation in the following places:
 - arch/x86/boot and arch/x86/realmode/rm, as KMSAN doesn't work for i386;
 - arch/x86/entry/vdso, which isn't linked with KMSAN runtime;
 - three files in arch/x86/kernel - boot problems;
 - arch/x86/mm/cpu_entry_area.c - recursion.

Link: https://lkml.kernel.org/r/20220915150417.722975-33-glider@google.com
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

 arch/x86/boot/Makefile            |    1 +
 arch/x86/boot/compressed/Makefile |    1 +
 arch/x86/entry/vdso/Makefile      |    3 +++
 arch/x86/kernel/Makefile          |    2 ++
 arch/x86/kernel/cpu/Makefile      |    1 +
 arch/x86/mm/Makefile              |    2 ++
 arch/x86/realmode/rm/Makefile     |    1 +
 7 files changed, 11 insertions(+)

--- a/arch/x86/boot/compressed/Makefile~x86-kmsan-disable-instrumentation-of-unsupported-code
+++ a/arch/x86/boot/compressed/Makefile
@@ -20,6 +20,7 @@
 # Sanitizer runtimes are unavailable and cannot be linked for early boot code.
 KASAN_SANITIZE			:= n
 KCSAN_SANITIZE			:= n
+KMSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
 
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
--- a/arch/x86/boot/Makefile~x86-kmsan-disable-instrumentation-of-unsupported-code
+++ a/arch/x86/boot/Makefile
@@ -12,6 +12,7 @@
 # Sanitizer runtimes are unavailable and cannot be linked for early boot code.
 KASAN_SANITIZE			:= n
 KCSAN_SANITIZE			:= n
+KMSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
 
 # Kernel does not boot with kcov instrumentation here.
--- a/arch/x86/entry/vdso/Makefile~x86-kmsan-disable-instrumentation-of-unsupported-code
+++ a/arch/x86/entry/vdso/Makefile
@@ -11,6 +11,9 @@ include $(srctree)/lib/vdso/Makefile
 
 # Sanitizer runtimes are unavailable and cannot be linked here.
 KASAN_SANITIZE			:= n
+KMSAN_SANITIZE_vclock_gettime.o := n
+KMSAN_SANITIZE_vgetcpu.o	:= n
+
 UBSAN_SANITIZE			:= n
 KCSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
--- a/arch/x86/kernel/cpu/Makefile~x86-kmsan-disable-instrumentation-of-unsupported-code
+++ a/arch/x86/kernel/cpu/Makefile
@@ -12,6 +12,7 @@ endif
 # If these files are instrumented, boot hangs during the first second.
 KCOV_INSTRUMENT_common.o := n
 KCOV_INSTRUMENT_perf_event.o := n
+KMSAN_SANITIZE_common.o := n
 
 # As above, instrumenting secondary CPU boot code causes boot hangs.
 KCSAN_SANITIZE_common.o := n
--- a/arch/x86/kernel/Makefile~x86-kmsan-disable-instrumentation-of-unsupported-code
+++ a/arch/x86/kernel/Makefile
@@ -33,6 +33,8 @@ KASAN_SANITIZE_sev.o					:= n
 # With some compiler versions the generated code results in boot hangs, caused
 # by several compilation units. To be safe, disable all instrumentation.
 KCSAN_SANITIZE := n
+KMSAN_SANITIZE_head$(BITS).o				:= n
+KMSAN_SANITIZE_nmi.o					:= n
 
 # If instrumentation of this dir is enabled, boot hangs during first second.
 # Probably could be more selective here, but note that files related to irqs,
--- a/arch/x86/mm/Makefile~x86-kmsan-disable-instrumentation-of-unsupported-code
+++ a/arch/x86/mm/Makefile
@@ -14,6 +14,8 @@ KASAN_SANITIZE_pgprot.o		:= n
 # Disable KCSAN entirely, because otherwise we get warnings that some functions
 # reference __initdata sections.
 KCSAN_SANITIZE := n
+# Avoid recursion by not calling KMSAN hooks for CEA code.
+KMSAN_SANITIZE_cpu_entry_area.o := n
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_mem_encrypt.o		= -pg
--- a/arch/x86/realmode/rm/Makefile~x86-kmsan-disable-instrumentation-of-unsupported-code
+++ a/arch/x86/realmode/rm/Makefile
@@ -10,6 +10,7 @@
 # Sanitizer runtimes are unavailable and cannot be linked here.
 KASAN_SANITIZE			:= n
 KCSAN_SANITIZE			:= n
+KMSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
 
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
_

Patches currently in -mm which might be from glider@google.com are


