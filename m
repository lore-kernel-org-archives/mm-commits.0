Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFECECAAD3
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 20:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiIEU2r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 16:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiIEU2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 16:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAB465254
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 13:27:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6168360689
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 20:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC444C43470;
        Mon,  5 Sep 2022 20:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662409629;
        bh=5etc+6H+B4ogF9pYEx+GGabdtY+YASSEDHP2XBr9Zfc=;
        h=Date:To:From:Subject:From;
        b=t2GLAMOhH3jOgj6dwo3qvMeLRwKaBnR6Vv+vyf5L1G0No7bX4D1KrFwI9jesfJ23O
         LzkVbBvVQzNr7+8h4Af7+H3RX8dDb6B3tNpgGRcIVPf9knqkvhqdBJGVgjgpsi78yG
         e2U145lOYa2QW89VTC+1sRZP9mlFvIoK7WEERPBQ=
Date:   Mon, 05 Sep 2022 13:27:09 -0700
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
Subject: + kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch added to mm-unstable branch
Message-Id: <20220905202709.AC444C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: unpoison @tlb in arch_tlb_gather_mmu()
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch

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
Subject: kmsan: unpoison @tlb in arch_tlb_gather_mmu()
Date: Mon, 5 Sep 2022 14:24:27 +0200

This is an optimization to reduce stackdepot pressure.

struct mmu_gather contains 7 1-bit fields packed into a 32-bit unsigned
int value.  The remaining 25 bits remain uninitialized and are never used,
but KMSAN updates the origin for them in zap_pXX_range() in mm/memory.c,
thus creating very long origin chains.  This is technically correct, but
consumes too much memory.

Unpoisoning the whole structure will prevent creating such chains.

Link: https://lkml.kernel.org/r/20220905122452.2258262-20-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
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

 mm/mmu_gather.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/mmu_gather.c~kmsan-unpoison-tlb-in-arch_tlb_gather_mmu
+++ a/mm/mmu_gather.c
@@ -1,6 +1,7 @@
 #include <linux/gfp.h>
 #include <linux/highmem.h>
 #include <linux/kernel.h>
+#include <linux/kmsan-checks.h>
 #include <linux/mmdebug.h>
 #include <linux/mm_types.h>
 #include <linux/mm_inline.h>
@@ -265,6 +266,15 @@ void tlb_flush_mmu(struct mmu_gather *tl
 static void __tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
 			     bool fullmm)
 {
+	/*
+	 * struct mmu_gather contains 7 1-bit fields packed into a 32-bit
+	 * unsigned int value. The remaining 25 bits remain uninitialized
+	 * and are never used, but KMSAN updates the origin for them in
+	 * zap_pXX_range() in mm/memory.c, thus creating very long origin
+	 * chains. This is technically correct, but consumes too much memory.
+	 * Unpoisoning the whole structure will prevent creating such chains.
+	 */
+	kmsan_unpoison_memory(tlb, sizeof(*tlb));
 	tlb->mm = mm;
 	tlb->fullmm = fullmm;
 
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

