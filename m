Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF379C6FA83
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 20:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiIEU0h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 16:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiIEU0K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 16:26:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CC91EEE3
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 13:26:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D675B815D7
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 20:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91877C433D6;
        Mon,  5 Sep 2022 20:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662409566;
        bh=0S9onuW6A//uC9RDgJ5dQKOpJK2Ikok2W+JDWGJssHc=;
        h=Date:To:From:Subject:From;
        b=jC+8QhOgWqnoknhFAyZmQbC+jHjDQVlNl+cdEHcsUFdq/Oh3U88hDF/OzYBK62jPJ
         5tgFawye4kqA0yolYgOINabbClN2pjia+pAJBGQlyWBI5tFknb0e/K+JT/4WftSLpm
         daXtUxnIBtXT0rXsVaNrrTeGM11OKlqnIsYp126w=
Date:   Mon, 05 Sep 2022 13:26:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, vegard.nossum@oracle.com, vbabka@suse.cz,
        tglx@linutronix.de, rostedt@goodmis.org, rientjes@google.com,
        pmladek@suse.com, peterz@infradead.org, penberg@kernel.org,
        mst@redhat.com, mingo@redhat.com, mark.rutland@arm.com,
        luto@kernel.org, liushixin2@huawei.com, keescook@chromium.org,
        iii@linux.ibm.com, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, gor@linux.ibm.com, elver@google.com,
        edumazet@google.com, ebiggers@google.com, dvyukov@google.com,
        cl@linux.com, bp@alien8.de, axboe@kernel.dk, ast@kernel.org,
        arnd@arndb.de, andreyknvl@google.com, andreyknvl@gmail.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + stackdepot-reserve-5-extra-bits-in-depot_stack_handle_t.patch added to mm-unstable branch
Message-Id: <20220905202606.91877C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: stackdepot: reserve 5 extra bits in depot_stack_handle_t
has been added to the -mm mm-unstable branch.  Its filename is
     stackdepot-reserve-5-extra-bits-in-depot_stack_handle_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stackdepot-reserve-5-extra-bits-in-depot_stack_handle_t.patch

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
Subject: stackdepot: reserve 5 extra bits in depot_stack_handle_t
Date: Mon, 5 Sep 2022 14:24:10 +0200

Some users (currently only KMSAN) may want to use spare bits in
depot_stack_handle_t.  Let them do so by adding @extra_bits to
__stack_depot_save() to store arbitrary flags, and providing
stack_depot_get_extra_bits() to retrieve those flags.

Also adapt KASAN to the new prototype by passing extra_bits=0, as KASAN
does not intend to store additional information in the stack handle.

Link: https://lkml.kernel.org/r/20220905122452.2258262-3-glider@google.com
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
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Liu Shixin <liushixin2@huawei.com>
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

 include/linux/stackdepot.h |    8 ++++++++
 lib/stackdepot.c           |   29 ++++++++++++++++++++++++-----
 mm/kasan/common.c          |    2 +-
 3 files changed, 33 insertions(+), 6 deletions(-)

--- a/include/linux/stackdepot.h~stackdepot-reserve-5-extra-bits-in-depot_stack_handle_t
+++ a/include/linux/stackdepot.h
@@ -14,9 +14,15 @@
 #include <linux/gfp.h>
 
 typedef u32 depot_stack_handle_t;
+/*
+ * Number of bits in the handle that stack depot doesn't use. Users may store
+ * information in them.
+ */
+#define STACK_DEPOT_EXTRA_BITS 5
 
 depot_stack_handle_t __stack_depot_save(unsigned long *entries,
 					unsigned int nr_entries,
+					unsigned int extra_bits,
 					gfp_t gfp_flags, bool can_alloc);
 
 /*
@@ -59,6 +65,8 @@ depot_stack_handle_t stack_depot_save(un
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries);
 
+unsigned int stack_depot_get_extra_bits(depot_stack_handle_t handle);
+
 int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
 		       int spaces);
 
--- a/lib/stackdepot.c~stackdepot-reserve-5-extra-bits-in-depot_stack_handle_t
+++ a/lib/stackdepot.c
@@ -43,7 +43,8 @@
 #define STACK_ALLOC_OFFSET_BITS (STACK_ALLOC_ORDER + PAGE_SHIFT - \
 					STACK_ALLOC_ALIGN)
 #define STACK_ALLOC_INDEX_BITS (DEPOT_STACK_BITS - \
-		STACK_ALLOC_NULL_PROTECTION_BITS - STACK_ALLOC_OFFSET_BITS)
+		STACK_ALLOC_NULL_PROTECTION_BITS - \
+		STACK_ALLOC_OFFSET_BITS - STACK_DEPOT_EXTRA_BITS)
 #define STACK_ALLOC_SLABS_CAP 8192
 #define STACK_ALLOC_MAX_SLABS \
 	(((1LL << (STACK_ALLOC_INDEX_BITS)) < STACK_ALLOC_SLABS_CAP) ? \
@@ -56,6 +57,7 @@ union handle_parts {
 		u32 slabindex : STACK_ALLOC_INDEX_BITS;
 		u32 offset : STACK_ALLOC_OFFSET_BITS;
 		u32 valid : STACK_ALLOC_NULL_PROTECTION_BITS;
+		u32 extra : STACK_DEPOT_EXTRA_BITS;
 	};
 };
 
@@ -77,6 +79,14 @@ static int next_slab_inited;
 static size_t depot_offset;
 static DEFINE_RAW_SPINLOCK(depot_lock);
 
+unsigned int stack_depot_get_extra_bits(depot_stack_handle_t handle)
+{
+	union handle_parts parts = { .handle = handle };
+
+	return parts.extra;
+}
+EXPORT_SYMBOL(stack_depot_get_extra_bits);
+
 static bool init_stack_slab(void **prealloc)
 {
 	if (!*prealloc)
@@ -140,6 +150,7 @@ depot_alloc_stack(unsigned long *entries
 	stack->handle.slabindex = depot_index;
 	stack->handle.offset = depot_offset >> STACK_ALLOC_ALIGN;
 	stack->handle.valid = 1;
+	stack->handle.extra = 0;
 	memcpy(stack->entries, entries, flex_array_size(stack, entries, size));
 	depot_offset += required_size;
 
@@ -382,6 +393,7 @@ EXPORT_SYMBOL_GPL(stack_depot_fetch);
  *
  * @entries:		Pointer to storage array
  * @nr_entries:		Size of the storage array
+ * @extra_bits:		Flags to store in unused bits of depot_stack_handle_t
  * @alloc_flags:	Allocation gfp flags
  * @can_alloc:		Allocate stack slabs (increased chance of failure if false)
  *
@@ -393,6 +405,10 @@ EXPORT_SYMBOL_GPL(stack_depot_fetch);
  * If the stack trace in @entries is from an interrupt, only the portion up to
  * interrupt entry is saved.
  *
+ * Additional opaque flags can be passed in @extra_bits, stored in the unused
+ * bits of the stack handle, and retrieved using stack_depot_get_extra_bits()
+ * without calling stack_depot_fetch().
+ *
  * Context: Any context, but setting @can_alloc to %false is required if
  *          alloc_pages() cannot be used from the current context. Currently
  *          this is the case from contexts where neither %GFP_ATOMIC nor
@@ -402,10 +418,11 @@ EXPORT_SYMBOL_GPL(stack_depot_fetch);
  */
 depot_stack_handle_t __stack_depot_save(unsigned long *entries,
 					unsigned int nr_entries,
+					unsigned int extra_bits,
 					gfp_t alloc_flags, bool can_alloc)
 {
 	struct stack_record *found = NULL, **bucket;
-	depot_stack_handle_t retval = 0;
+	union handle_parts retval = { .handle = 0 };
 	struct page *page = NULL;
 	void *prealloc = NULL;
 	unsigned long flags;
@@ -489,9 +506,11 @@ exit:
 		free_pages((unsigned long)prealloc, STACK_ALLOC_ORDER);
 	}
 	if (found)
-		retval = found->handle.handle;
+		retval.handle = found->handle.handle;
 fast_exit:
-	return retval;
+	retval.extra = extra_bits;
+
+	return retval.handle;
 }
 EXPORT_SYMBOL_GPL(__stack_depot_save);
 
@@ -511,6 +530,6 @@ depot_stack_handle_t stack_depot_save(un
 				      unsigned int nr_entries,
 				      gfp_t alloc_flags)
 {
-	return __stack_depot_save(entries, nr_entries, alloc_flags, true);
+	return __stack_depot_save(entries, nr_entries, 0, alloc_flags, true);
 }
 EXPORT_SYMBOL_GPL(stack_depot_save);
--- a/mm/kasan/common.c~stackdepot-reserve-5-extra-bits-in-depot_stack_handle_t
+++ a/mm/kasan/common.c
@@ -36,7 +36,7 @@ depot_stack_handle_t kasan_save_stack(gf
 	unsigned int nr_entries;
 
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
-	return __stack_depot_save(entries, nr_entries, flags, can_alloc);
+	return __stack_depot_save(entries, nr_entries, 0, flags, can_alloc);
 }
 
 void kasan_set_track(struct kasan_track *track, gfp_t flags)
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
entry-kmsan-introduce-kmsan_unpoison_entry_regs.patch
bpf-kmsan-initialize-bpf-registers-with-zeroes.patch
mm-fs-initialize-fsdata-passed-to-write_begin-write_end-interface.patch
x86-kmsan-enable-kmsan-builds-for-x86.patch

