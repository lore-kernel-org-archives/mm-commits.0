Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAA4C0502C
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 02:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345349AbiH0CJV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 22:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345461AbiH0CJJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 22:09:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACB4EE485
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 19:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6990961D2E
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 02:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01DEC433D6;
        Sat, 27 Aug 2022 02:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661566128;
        bh=kDZZirl4ZunhTnWUPHO32PY351KPz2r8ygUQqnGVDrU=;
        h=Date:To:From:Subject:From;
        b=dO43Nc6Eor5XBuzgf2vXIoTEXU+kp8zwwVlp45Ov60qMtXKpMFj9/KqPVJKTzqlx+
         Mp4X/Ojqvf6OZCX7droTZHATdUgXUotB6iI3pnkXyGsppY32wqCGclfYRhroCnhpfj
         DTfW3jVqL992ahm8z8SWLx02fcnb/QJ2w51lF2QY=
Date:   Fri, 26 Aug 2022 19:08:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, vegard.nossum@oracle.com, vbabka@suse.cz,
        tglx@linutronix.de, rostedt@goodmis.org, rientjes@google.com,
        pmladek@suse.com, peterz@infradead.org, penberg@kernel.org,
        mst@redhat.com, mingo@redhat.com, mark.rutland@arm.com,
        luto@kernel.org, keescook@chromium.org, iii@linux.ibm.com,
        iamjoonsoo.kim@lge.com, herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, gor@linux.ibm.com, elver@google.com,
        edumazet@google.com, ebiggers@google.com, dvyukov@google.com,
        cl@linux.com, bp@alien8.de, axboe@kernel.dk, ast@kernel.org,
        arnd@arndb.de, andreyknvl@google.com, andreyknvl@gmail.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-asm-instrument-usercopy-in-get_user-and-put_user.patch added to mm-unstable branch
Message-Id: <20220827020848.B01DEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: asm: instrument usercopy in get_user() and put_user()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-asm-instrument-usercopy-in-get_user-and-put_user.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-asm-instrument-usercopy-in-get_user-and-put_user.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: x86: asm: instrument usercopy in get_user() and put_user()
Date: Fri, 26 Aug 2022 17:07:27 +0200

Use hooks from instrumented.h to notify bug detection tools about usercopy
events in variations of get_user() and put_user().

Link: https://lkml.kernel.org/r/20220826150807.723137-5-glider@google.com
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
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uaccess.h |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/uaccess.h~x86-asm-instrument-usercopy-in-get_user-and-put_user
+++ a/arch/x86/include/asm/uaccess.h
@@ -5,6 +5,7 @@
  * User space memory access functions
  */
 #include <linux/compiler.h>
+#include <linux/instrumented.h>
 #include <linux/kasan-checks.h>
 #include <linux/string.h>
 #include <asm/asm.h>
@@ -103,6 +104,7 @@ extern int __get_user_bad(void);
 		     : "=a" (__ret_gu), "=r" (__val_gu),		\
 			ASM_CALL_CONSTRAINT				\
 		     : "0" (ptr), "i" (sizeof(*(ptr))));		\
+	instrument_get_user(__val_gu);					\
 	(x) = (__force __typeof__(*(ptr))) __val_gu;			\
 	__builtin_expect(__ret_gu, 0);					\
 })
@@ -192,9 +194,11 @@ extern void __put_user_nocheck_8(void);
 	int __ret_pu;							\
 	void __user *__ptr_pu;						\
 	register __typeof__(*(ptr)) __val_pu asm("%"_ASM_AX);		\
-	__chk_user_ptr(ptr);						\
-	__ptr_pu = (ptr);						\
-	__val_pu = (x);							\
+	__typeof__(*(ptr)) __x = (x); /* eval x once */			\
+	__typeof__(ptr) __ptr = (ptr); /* eval ptr once */		\
+	__chk_user_ptr(__ptr);						\
+	__ptr_pu = __ptr;						\
+	__val_pu = __x;							\
 	asm volatile("call __" #fn "_%P[size]"				\
 		     : "=c" (__ret_pu),					\
 			ASM_CALL_CONSTRAINT				\
@@ -202,6 +206,7 @@ extern void __put_user_nocheck_8(void);
 		       "r" (__val_pu),					\
 		       [size] "i" (sizeof(*(ptr)))			\
 		     :"ebx");						\
+	instrument_put_user(__x, __ptr, sizeof(*(ptr)));		\
 	__builtin_expect(__ret_pu, 0);					\
 })
 
@@ -248,23 +253,25 @@ extern void __put_user_nocheck_8(void);
 
 #define __put_user_size(x, ptr, size, label)				\
 do {									\
+	__typeof__(*(ptr)) __x = (x); /* eval x once */			\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
 	case 1:								\
-		__put_user_goto(x, ptr, "b", "iq", label);		\
+		__put_user_goto(__x, ptr, "b", "iq", label);		\
 		break;							\
 	case 2:								\
-		__put_user_goto(x, ptr, "w", "ir", label);		\
+		__put_user_goto(__x, ptr, "w", "ir", label);		\
 		break;							\
 	case 4:								\
-		__put_user_goto(x, ptr, "l", "ir", label);		\
+		__put_user_goto(__x, ptr, "l", "ir", label);		\
 		break;							\
 	case 8:								\
-		__put_user_goto_u64(x, ptr, label);			\
+		__put_user_goto_u64(__x, ptr, label);			\
 		break;							\
 	default:							\
 		__put_user_bad();					\
 	}								\
+	instrument_put_user(__x, ptr, size);				\
 } while (0)
 
 #ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
@@ -305,6 +312,7 @@ do {									\
 	default:							\
 		(x) = __get_user_bad();					\
 	}								\
+	instrument_get_user(x);						\
 } while (0)
 
 #define __get_user_asm(x, addr, itype, ltype, label)			\
_

Patches currently in -mm which might be from glider@google.com are

stackdepot-reserve-5-extra-bits-in-depot_stack_handle_t.patch
instrumentedh-allow-instrumenting-both-sides-of-copy_from_user.patch
x86-asm-instrument-usercopy-in-get_user-and-put_user.patch
asm-generic-instrument-usercopy-in-cacheflushh.patch
kmsan-add-rest-documentation.patch
kmsan-introduce-__no_sanitize_memory-and-__no_kmsan_checks.patch
kmsan-mark-noinstr-as-__no_sanitize_memory.patch
x86-kmsan-pgtable-reduce-vmalloc-space.patch
libnvdimm-pfn_dev-increase-max_struct_page_size.patch
kmsan-add-kmsan-runtime-core.patch
kmsan-disable-instrumentation-of-unsupported-common-kernel-code.patch
maintainers-add-entry-for-kmsan.patch
mm-kmsan-maintain-kmsan-metadata-for-page-operations.patch
mm-kmsan-call-kmsan-hooks-from-slub-code.patch
kmsan-handle-task-creation-and-exiting.patch
init-kmsan-call-kmsan-initialization-routines.patch
instrumentedh-add-kmsan-support.patch
kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch
kmsan-add-iomap-support.patch
input-libps2-mark-data-received-in-__ps2_command-as-initialized.patch
dma-kmsan-unpoison-dma-mappings.patch
virtio-kmsan-check-unpoison-scatterlist-in-vring_map_one_sg.patch
kmsan-handle-memory-sent-to-from-usb.patch
kmsan-add-tests-for-kmsan.patch
kmsan-disable-strscpy-optimization-under-kmsan.patch
crypto-kmsan-disable-accelerated-configs-under-kmsan.patch
kmsan-disable-physical-page-merging-in-biovec.patch
block-kmsan-skip-bio-block-merging-logic-for-kmsan.patch
kcov-kmsan-unpoison-area-list-in-kcov_remote_area_put.patch
security-kmsan-fix-interoperability-with-auto-initialization.patch
objtool-kmsan-list-kmsan-api-functions-as-uaccess-safe.patch
x86-kmsan-disable-instrumentation-of-unsupported-code.patch
x86-kmsan-skip-shadow-checks-in-__switch_to.patch
x86-kmsan-handle-open-coded-assembly-in-lib-iomemc.patch
x86-kmsan-use-__msan_-string-functions-where-possible.patch
x86-kmsan-sync-metadata-pages-on-page-fault.patch
x86-kasan-kmsan-support-config_generic_csum-on-x86-enable-it-for-kasan-kmsan.patch
x86-fs-kmsan-disable-config_dcache_word_access.patch
x86-kmsan-dont-instrument-stack-walking-functions.patch
entry-kmsan-introduce-kmsan_unpoison_entry_regs.patch
bpf-kmsan-initialize-bpf-registers-with-zeroes.patch
mm-fs-initialize-fsdata-passed-to-write_begin-write_end-interface.patch
x86-kmsan-enable-kmsan-builds-for-x86.patch

