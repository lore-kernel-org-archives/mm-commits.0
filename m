Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39939C2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC75122404
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604450498;
	bh=Sw6o5ywx9VxB4L8W9QeNaazrD8+Au4FLqsCYuoQPBSU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nRg+FhMdfMB5Ex71sGhy8H2oHtYCQggHFNax5F/0wF3ue0ZqBx6kmoSeICUcgMgkO
	 nZ1MovkCi1bScA1p/J1UKJJqTJL6GPZorEMsBCzxgip4HSKqWAL71dl6DSUx2/yKqi
	 FzYeFbBV2TtQx+Bz+9tCyHICOZeGhpK4QeS9zUD0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgKDAli (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 19:41:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgKDAli (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 19:41:38 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12DA9223C7;
        Wed,  4 Nov 2020 00:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604450497;
        bh=Sw6o5ywx9VxB4L8W9QeNaazrD8+Au4FLqsCYuoQPBSU=;
        h=Date:From:To:Subject:From;
        b=Fvq4MobsvXhSpBxcIpo5pZo9aYmQJdlEF49d66R/vyUZiAw9m9pdzGADy/G/MIs9q
         V+JO/tVccYO28nA6j7W8DdUXJ6meLac63M+MXU5uC4ErkSYfh6agqSqFT0mZ+3+XK2
         sBvCZiRgvxdCIUCjRRIR3mP88yifze7YH6tgkipo=
Date:   Tue, 03 Nov 2020 16:41:35 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vbabka@suse.cz,
        tglx@linutronix.de, sjpark@amazon.de, rientjes@google.com,
        peterz@infradead.org, penberg@kernel.org, paulmck@kernel.org,
        mingo@redhat.com, mark.rutland@arm.com, luto@kernel.org,
        keescook@chromium.org, joern@purestorage.com, jannh@google.com,
        iamjoonsoo.kim@lge.com, hpa@zytor.com, hdanton@sina.com,
        gregkh@linuxfoundation.org, elver@google.com, edumazet@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, corbet@lwn.net,
        cl@linux.com, catalin.marinas@arm.com, bp@alien8.de,
        aryabinin@virtuozzo.com, andreyknvl@google.com, glider@google.com
Subject:  + kfence-kasan-make-kfence-compatible-with-kasan.patch
 added to -mm tree
Message-ID: <20201104004135.FxT5D%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence, kasan: make KFENCE compatible with KASAN
has been added to the -mm tree.  Its filename is
     kfence-kasan-make-kfence-compatible-with-kasan.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-kasan-make-kfence-compatible-with-kasan.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-kasan-make-kfence-compatible-with-kasan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kfence, kasan: make KFENCE compatible with KASAN

Make KFENCE compatible with KASAN. Currently this helps test KFENCE
itself, where KASAN can catch potential corruptions to KFENCE state, or
other corruptions that may be a result of freepointer corruptions in the
main allocators.

Link: https://lkml.kernel.org/r/20201103175841.3495947-7-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Co-developed-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joern Engel <joern@purestorage.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kfence |    2 +-
 mm/kasan/common.c  |   19 +++++++++++++++++++
 mm/kasan/generic.c |    3 ++-
 3 files changed, 22 insertions(+), 2 deletions(-)

--- a/lib/Kconfig.kfence~kfence-kasan-make-kfence-compatible-with-kasan
+++ a/lib/Kconfig.kfence
@@ -5,7 +5,7 @@ config HAVE_ARCH_KFENCE
 
 menuconfig KFENCE
 	bool "KFENCE: low-overhead sampling-based memory safety error detector"
-	depends on HAVE_ARCH_KFENCE && !KASAN && (SLAB || SLUB)
+	depends on HAVE_ARCH_KFENCE && (SLAB || SLUB)
 	depends on JUMP_LABEL # To ensure performance, require jump labels
 	select STACKTRACE
 	help
--- a/mm/kasan/common.c~kfence-kasan-make-kfence-compatible-with-kasan
+++ a/mm/kasan/common.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
+#include <linux/kfence.h>
 #include <linux/kmemleak.h>
 #include <linux/linkage.h>
 #include <linux/memblock.h>
@@ -124,6 +125,10 @@ void kasan_poison_shadow(const void *add
 	 */
 	address = reset_tag(address);
 
+	/* Skip KFENCE memory if called explicitly outside of sl*b. */
+	if (is_kfence_address(address))
+		return;
+
 	shadow_start = kasan_mem_to_shadow(address);
 	shadow_end = kasan_mem_to_shadow(address + size);
 
@@ -141,6 +146,14 @@ void kasan_unpoison_shadow(const void *a
 	 */
 	address = reset_tag(address);
 
+	/*
+	 * Skip KFENCE memory if called explicitly outside of sl*b. Also note
+	 * that calls to ksize(), where size is not a multiple of machine-word
+	 * size, would otherwise poison the invalid portion of the word.
+	 */
+	if (is_kfence_address(address))
+		return;
+
 	kasan_poison_shadow(address, size, tag);
 
 	if (size & KASAN_SHADOW_MASK) {
@@ -396,6 +409,9 @@ static bool __kasan_slab_free(struct kme
 	tagged_object = object;
 	object = reset_tag(object);
 
+	if (is_kfence_address(object))
+		return false;
+
 	if (unlikely(nearest_obj(cache, virt_to_head_page(object), object) !=
 	    object)) {
 		kasan_report_invalid_free(tagged_object, ip);
@@ -444,6 +460,9 @@ static void *__kasan_kmalloc(struct kmem
 	if (unlikely(object == NULL))
 		return NULL;
 
+	if (is_kfence_address(object))
+		return (void *)object;
+
 	redzone_start = round_up((unsigned long)(object + size),
 				KASAN_SHADOW_SCALE_SIZE);
 	redzone_end = round_up((unsigned long)object + cache->object_size,
--- a/mm/kasan/generic.c~kfence-kasan-make-kfence-compatible-with-kasan
+++ a/mm/kasan/generic.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
+#include <linux/kfence.h>
 #include <linux/kmemleak.h>
 #include <linux/linkage.h>
 #include <linux/memblock.h>
@@ -332,7 +333,7 @@ void kasan_record_aux_stack(void *addr)
 	struct kasan_alloc_meta *alloc_info;
 	void *object;
 
-	if (!(page && PageSlab(page)))
+	if (is_kfence_address(addr) || !(page && PageSlab(page)))
 		return;
 
 	cache = page->slab_cache;
_

Patches currently in -mm which might be from glider@google.com are

mm-add-kernel-electric-fence-infrastructure.patch
x86-kfence-enable-kfence-for-x86.patch
mm-kfence-insert-kfence-hooks-for-slab.patch
mm-kfence-insert-kfence-hooks-for-slub.patch
kfence-kasan-make-kfence-compatible-with-kasan.patch

