Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C209C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJCVPX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiJCVNz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B59A5465E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC5F8610A3
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C789C433C1;
        Mon,  3 Oct 2022 21:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831356;
        bh=oTYKQOJn6rJ/w4iEyyQIY2rDyGzaqPHvh5QUNoSTOgg=;
        h=Date:To:From:Subject:From;
        b=ad1efLBvWuaOmM4KccXnjXvaGULAZbb5LRPAtkTrIoGPXgZy6tKjtsrDhR+iVCmfk
         bdv1dbRbGR0oObpTLVBYLw0bslW/Ww87q0rlE+LRrAuccE74zjeUcr7R4JXBxszJ+e
         /M+fSQ2h+/cy8aGn1Jxhe7cO/IjCMZvVyK1CBx54=
Date:   Mon, 03 Oct 2022 14:09:15 -0700
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
Subject: [merged mm-stable] x86-kmsan-handle-cpu-entry-area.patch removed from -mm tree
Message-Id: <20221003210916.2C789C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86: kmsan: handle CPU entry area
has been removed from the -mm tree.  Its filename was
     x86-kmsan-handle-cpu-entry-area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 MAINTAINERS                  |    1 +
 arch/x86/include/asm/kmsan.h |   32 ++++++++++++++++++++++++++++++++
 arch/x86/mm/Makefile         |    3 +++
 arch/x86/mm/kmsan_shadow.c   |   20 ++++++++++++++++++++
 mm/kmsan/shadow.c            |    6 +++++-
 5 files changed, 61 insertions(+), 1 deletion(-)

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


