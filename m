Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CB6C04A95
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 15:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbiI1PYR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbiI1PX5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 11:23:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAC95D11B
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 08:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C11FB820EB
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 15:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C657C433D6;
        Wed, 28 Sep 2022 15:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664378538;
        bh=NW8Vn5UFfFJst50KGkROfwfpYn1yWSwSswfjEnLRUmQ=;
        h=Date:To:From:Subject:From;
        b=W4LgP1THpgUe6XugZL3gngXWpHTpdDATmn+YnffwGCjMVxRywB+YX6E7rHAgSq/qt
         yua7fh0z/JhZynqxX9gu7abmp7+s4niFHzDz4PFUxfNZmyGHs6PcAvda+9CP2Ylk/4
         9IcPmYK4AcpjmrzoG4tCu48GPLLX1/C86byzUAY4=
Date:   Wed, 28 Sep 2022 08:22:10 -0700
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
Subject: + x86-kmsan-handle-cpu-entry-area.patch added to mm-unstable branch
Message-Id: <20220928152218.0C657C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: kmsan: handle CPU entry area
has been added to the -mm mm-unstable branch.  Its filename is
     x86-kmsan-handle-cpu-entry-area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kmsan-handle-cpu-entry-area.patch

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
Subject: x86: kmsan: handle CPU entry area
Date: Wed, 28 Sep 2022 14:32:19 +0200

Among other data, CPU entry area holds exception stacks, so addresses from
this area can be passed to kmsan_get_metadata().

This previously led to kmsan_get_metadata() returning NULL, which in turn
resulted in a warning that triggered further attempts to call
kmsan_get_metadata() in the exception context, which quickly exhausted the
exception stack.

This patch allocates shadow and origin for the CPU entry area on x86 and
introduces arch_kmsan_get_meta_or_null(), which performs arch-specific
metadata mapping.

Link: https://lkml.kernel.org/r/20220928123219.1101883-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Fixes: 21d723a7c1409 ("kmsan: add KMSAN runtime core")
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


--- a/arch/x86/include/asm/kmsan.h~x86-kmsan-handle-cpu-entry-area
+++ a/arch/x86/include/asm/kmsan.h
@@ -11,9 +11,41 @@
 
 #ifndef MODULE
 
+#include <asm/cpu_entry_area.h>
 #include <asm/processor.h>
 #include <linux/mmzone.h>
 
+DECLARE_PER_CPU(char[CPU_ENTRY_AREA_SIZE], cpu_entry_area_shadow);
+DECLARE_PER_CPU(char[CPU_ENTRY_AREA_SIZE], cpu_entry_area_origin);
+
+/*
+ * Functions below are declared in the header to make sure they are inlined.
+ * They all are called from kmsan_get_metadata() for every memory access in
+ * the kernel, so speed is important here.
+ */
+
+/*
+ * Compute metadata addresses for the CPU entry area on x86.
+ */
+static inline void *arch_kmsan_get_meta_or_null(void *addr, bool is_origin)
+{
+	unsigned long addr64 = (unsigned long)addr;
+	char *metadata_array;
+	unsigned long off;
+	int cpu;
+
+	if ((addr64 < CPU_ENTRY_AREA_BASE) ||
+	    (addr64 >= (CPU_ENTRY_AREA_BASE + CPU_ENTRY_AREA_MAP_SIZE)))
+		return NULL;
+	cpu = (addr64 - CPU_ENTRY_AREA_BASE) / CPU_ENTRY_AREA_SIZE;
+	off = addr64 - (unsigned long)get_cpu_entry_area(cpu);
+	if ((off < 0) || (off >= CPU_ENTRY_AREA_SIZE))
+		return NULL;
+	metadata_array = is_origin ? cpu_entry_area_origin :
+				     cpu_entry_area_shadow;
+	return &per_cpu(metadata_array[off], cpu);
+}
+
 /*
  * Taken from arch/x86/mm/physaddr.h to avoid using an instrumented version.
  */
--- /dev/null
+++ a/arch/x86/mm/kmsan_shadow.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * x86-specific bits of KMSAN shadow implementation.
+ *
+ * Copyright (C) 2022 Google LLC
+ * Author: Alexander Potapenko <glider@google.com>
+ */
+
+#include <asm/cpu_entry_area.h>
+#include <linux/percpu-defs.h>
+
+/*
+ * Addresses within the CPU entry area (including e.g. exception stacks) do not
+ * have struct page entries corresponding to them, so they need separate
+ * handling.
+ * arch_kmsan_get_meta_or_null() (declared in the header) maps the addresses in
+ * CPU entry area to addresses in cpu_entry_area_shadow/cpu_entry_area_origin.
+ */
+DEFINE_PER_CPU(char[CPU_ENTRY_AREA_SIZE], cpu_entry_area_shadow);
+DEFINE_PER_CPU(char[CPU_ENTRY_AREA_SIZE], cpu_entry_area_origin);
--- a/arch/x86/mm/Makefile~x86-kmsan-handle-cpu-entry-area
+++ a/arch/x86/mm/Makefile
@@ -46,6 +46,9 @@ obj-$(CONFIG_HIGHMEM)		+= highmem_32.o
 KASAN_SANITIZE_kasan_init_$(BITS).o := n
 obj-$(CONFIG_KASAN)		+= kasan_init_$(BITS).o
 
+KMSAN_SANITIZE_kmsan_shadow.o	:= n
+obj-$(CONFIG_KMSAN)		+= kmsan_shadow.o
+
 obj-$(CONFIG_MMIOTRACE)		+= mmiotrace.o
 mmiotrace-y			:= kmmio.o pf_in.o mmio-mod.o
 obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
--- a/MAINTAINERS~x86-kmsan-handle-cpu-entry-area
+++ a/MAINTAINERS
@@ -11379,6 +11379,7 @@ L:	kasan-dev@googlegroups.com
 S:	Maintained
 F:	Documentation/dev-tools/kmsan.rst
 F:	arch/*/include/asm/kmsan.h
+F:	arch/*/mm/kmsan_*
 F:	include/linux/kmsan*.h
 F:	lib/Kconfig.kmsan
 F:	mm/kmsan/
--- a/mm/kmsan/shadow.c~x86-kmsan-handle-cpu-entry-area
+++ a/mm/kmsan/shadow.c
@@ -12,7 +12,6 @@
 #include <linux/cacheflush.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
-#include <linux/percpu-defs.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/stddef.h>
@@ -126,6 +125,7 @@ void *kmsan_get_metadata(void *address,
 {
 	u64 addr = (u64)address, pad, off;
 	struct page *page;
+	void *ret;
 
 	if (is_origin && !IS_ALIGNED(addr, KMSAN_ORIGIN_SIZE)) {
 		pad = addr % KMSAN_ORIGIN_SIZE;
@@ -136,6 +136,10 @@ void *kmsan_get_metadata(void *address,
 	    kmsan_internal_is_module_addr(address))
 		return (void *)vmalloc_meta(address, is_origin);
 
+	ret = arch_kmsan_get_meta_or_null(address, is_origin);
+	if (ret)
+		return ret;
+
 	page = virt_to_page_or_null(address);
 	if (!page)
 		return NULL;
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
x86-kmsan-handle-cpu-entry-area.patch

