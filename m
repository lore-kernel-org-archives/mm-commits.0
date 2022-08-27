Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189CFECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 02:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345492AbiH0CMz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 22:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345499AbiH0CKz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 22:10:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CEBEA8B3
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 19:10:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F93FB8337D
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 02:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DCEC433C1;
        Sat, 27 Aug 2022 02:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661566250;
        bh=tLM/AZetv3e4CiqDwzhjmnI1FT17x+2ac3FHL5wqrco=;
        h=Date:To:From:Subject:From;
        b=m66xyWpWwpcJzt+Tj6hOetttWzqIaxYkAzLkRVLt/bZsY97be9voMyDVdOmWW3YUU
         TQhoygYLP+Jg03MCVdWqUcnUttm6ObTD/VJdTiQ6fvGtTNkzG9rt5B4DKyPuKnspZa
         EmWhdbmILzt9vJfXDtkuGOcaCOU25FTkUg1kkRrg=
Date:   Fri, 26 Aug 2022 19:10:49 -0700
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
Subject: + x86-kmsan-enable-kmsan-builds-for-x86.patch added to mm-unstable branch
Message-Id: <20220827021050.15DCEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: kmsan: enable KMSAN builds for x86
has been added to the -mm mm-unstable branch.  Its filename is
     x86-kmsan-enable-kmsan-builds-for-x86.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kmsan-enable-kmsan-builds-for-x86.patch

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
Subject: x86: kmsan: enable KMSAN builds for x86
Date: Fri, 26 Aug 2022 17:08:07 +0200

Make KMSAN usable by adding the necessary Kconfig bits.

Also declare x86-specific functions checking address validity
in arch/x86/include/asm/kmsan.h.

Link: https://lkml.kernel.org/r/20220826150807.723137-45-glider@google.com
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

 arch/x86/Kconfig             |    1 
 arch/x86/include/asm/kmsan.h |   55 +++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

--- /dev/null
+++ a/arch/x86/include/asm/kmsan.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * x86 KMSAN support.
+ *
+ * Copyright (C) 2022, Google LLC
+ * Author: Alexander Potapenko <glider@google.com>
+ */
+
+#ifndef _ASM_X86_KMSAN_H
+#define _ASM_X86_KMSAN_H
+
+#ifndef MODULE
+
+#include <asm/processor.h>
+#include <linux/mmzone.h>
+
+/*
+ * Taken from arch/x86/mm/physaddr.h to avoid using an instrumented version.
+ */
+static inline bool kmsan_phys_addr_valid(unsigned long addr)
+{
+	if (IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
+		return !(addr >> boot_cpu_data.x86_phys_bits);
+	else
+		return true;
+}
+
+/*
+ * Taken from arch/x86/mm/physaddr.c to avoid using an instrumented version.
+ */
+static inline bool kmsan_virt_addr_valid(void *addr)
+{
+	unsigned long x = (unsigned long)addr;
+	unsigned long y = x - __START_KERNEL_map;
+
+	/* use the carry flag to determine if x was < __START_KERNEL_map */
+	if (unlikely(x > y)) {
+		x = y + phys_base;
+
+		if (y >= KERNEL_IMAGE_SIZE)
+			return false;
+	} else {
+		x = y + (__START_KERNEL_map - PAGE_OFFSET);
+
+		/* carry flag will be set if starting x was >= PAGE_OFFSET */
+		if ((x > y) || !kmsan_phys_addr_valid(x))
+			return false;
+	}
+
+	return pfn_valid(x >> PAGE_SHIFT);
+}
+
+#endif /* !MODULE */
+
+#endif /* _ASM_X86_KMSAN_H */
--- a/arch/x86/Kconfig~x86-kmsan-enable-kmsan-builds-for-x86
+++ a/arch/x86/Kconfig
@@ -169,6 +169,7 @@ config X86
 	select HAVE_ARCH_KASAN			if X86_64
 	select HAVE_ARCH_KASAN_VMALLOC		if X86_64
 	select HAVE_ARCH_KFENCE
+	select HAVE_ARCH_KMSAN			if X86_64
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_MMAP_RND_BITS		if MMU
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if MMU && COMPAT
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

